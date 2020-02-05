/*
  Sketch.cpp - Main file for "Didactic Strain Gauges-LED System"
  Copyright (c) 2018-2019 University of Almeria.  All right reserved.

  This library is free software; you can redistribute it and/or
  modify it under the terms of the GNU Lesser General Public
  License as published by the Free Software Foundation; either
  version 2.1 of the License, or (at your option) any later version.

  This library is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
  Lesser General Public License for more details.

  You should have received a copy of the GNU Lesser General Public
  License along with this library; if not, write to the Free Software
  Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
*/

// Firmware designed for ATMEGA328P
// Note: to enable sprintf() of doubles/floats, link with these flags:
// -Wl,-u,vfprintf -lprintf_flt -lm

#include <Arduino.h>
#include <EEPROM.h>
#include <Wire.h>
#include "MCP342X.h"

// Uncomment to enable sending debug text messages to the serial console.
// do NOT leave enabled for production, since several devices would try 
// to write simultaneously to the RS485 bus without arbitration.
//#define SERIAL_DEBUG_MSGS

// LEDs:
constexpr int LED1_PIN = 9; // uC pin 13, PB1
constexpr int LED2_PIN = 10; // uC pin 14, PB2

constexpr int SERIAL_DE_PIN  = 2; // uC pin 32, PD2
constexpr int SERIAL_nRE_PIN = 3; // uC pin 1, PD3

// The ADC:
static MCP342X adc;
static bool adc_init_ok = false;
static const auto ADC_GAIN = MCP342X_GAIN_1X;
static uint8_t MY_ID = 0xff; // My unique board ID, stored in EEPROM

// The residual strain, acquired after reset:
static int16_t adc_zero_strain_offset = 0;

// Last measured strain, in ADC bit units (after offset compensation):
static int32_t measured_real_strain = 0;

// Calculated such as V_adc=0.3 ==> 100% of PWM LED output
static double STRAIN_TO_PWM_CONST = 255.5/ (0.3 * ((2<<15 - 1) / 2.5));

static double threshold_strain_leds = 100;


// func. decls:
static void process_sensors_leds();
static void process_command(const char*cmd);
static void do_led_ramp_up_down(int led_id, int delay_speed_ms = 6);
static void rs485_enable_tx();
static void rs485_enable_rx();
static void rs485_send_string(const char* s);
static uint8_t id_read(); // Read "my ID" from EEPROM
static void id_write(uint8_t id); // write "my ID" to EEPROM


void setup()
{
	// Flash LEDs at start up:
	do_led_ramp_up_down(LED1_PIN, 3);
	do_led_ramp_up_down(LED2_PIN, 3);

	// Init I2C bus:
	Wire.begin();
	// Use max I2C speed (400 kHz)
	TWBR = 12;

	// Read ID from eeprom
	MY_ID = id_read();

	// Configure RS485 control outputs:
	pinMode(SERIAL_DE_PIN, OUTPUT);
	pinMode(SERIAL_nRE_PIN, OUTPUT);
	rs485_enable_rx();

	// Init serial port:
	Serial.begin(115200);

	// read timeout (ms)
	Serial.setTimeout(5);

	// wait for Serial comms to become ready
	while (!Serial) {}
		
}

void loop()
{
	// Test connection to ADC once after boot up:
	// --------------------------------------------------
	if (!adc_init_ok)
	{
#ifdef SERIAL_DEBUG_MSGS
		rs485_send_string("# Testing ADC connection...");
#endif

		adc_init_ok = adc.testConnection();
		if (adc_init_ok)
		{
#ifdef SERIAL_DEBUG_MSGS
			rs485_send_string("# MCP342X connection successful!");
#endif

			adc.configure(
				MCP342X_MODE_CONTINUOUS |
				MCP342X_CHANNEL_1 |
				MCP342X_SIZE_16BIT |
				ADC_GAIN
				);

#ifdef SERIAL_DEBUG_MSGS
			rs485_enable_tx();
			Serial.print("# ADC config register=");
			Serial.println(adc.getConfigRegShdw(), HEX);
			Serial.flush();
			rs485_enable_rx();
#endif

			// Read a few samples (a discard them) waiting for the 
			// analog value to stabilize after reset, then take it as 
			// the "residual strain" offset value:
			// (16bit -> continuous rate of 15 SPS)
			for (int i=0;i<15;i++)
			{
				adc.startConversion();
				adc.getResult(&adc_zero_strain_offset);
			}

#ifdef SERIAL_DEBUG_MSGS
			rs485_enable_tx();
			Serial.print("# Using ADC offset value=");
			Serial.println(adc_zero_strain_offset);
			Serial.flush();
			rs485_enable_rx();
#endif
		}
		else
		{
#ifdef SERIAL_DEBUG_MSGS
			rs485_send_string("# MCP342X connection failed! Retrying in 1 second...");
#endif
			delay(1000);
			return;
		}
	}
	

	// Main ADC reading task:
	process_sensors_leds();

	// check for commands from the PC:
	String sCmd = Serial.readStringUntil('\n');
	if (sCmd.length()>2)
	{
		process_command(sCmd.c_str());
	}
}

// Main task: read ADC and flash LEDs accordingly
void process_sensors_leds()
{
	int16_t  adc_value;
	adc.startConversion();
	adc.getResult(&adc_value);
	
	// Strain is measured - offset (residual structural strain)
	measured_real_strain = adc_value - adc_zero_strain_offset;
	
	// Convert to PWM (0-255)
	double pwm_value_f= .0;
	if (fabs(measured_real_strain)>threshold_strain_leds)
	{
		pwm_value_f = STRAIN_TO_PWM_CONST * measured_real_strain;
	}

	// Saturate:
	const bool is_negative = (pwm_value_f<0);
	if (pwm_value_f<0) pwm_value_f=-pwm_value_f;
	if (pwm_value_f>255) pwm_value_f = 255;
	uint8_t pwm_value = static_cast<uint8_t>(pwm_value_f);
	
	// TODO: positive / negative, one LED or the other one.
	analogWrite(is_negative ? LED2_PIN : LED1_PIN, pwm_value);
	analogWrite(is_negative ? LED1_PIN : LED2_PIN, 0);
}


void do_led_ramp_up_down(int led_id, int delay_speed_ms)
{
	pinMode(led_id, OUTPUT);

	for (int pc = 0; pc <255; pc++)
	{
		analogWrite(led_id, pc);
		delay(delay_speed_ms);
	}
	for (int pc = 255; pc >0; pc--)
	{
		analogWrite(led_id, pc);
		delay(delay_speed_ms);
	}

}

void rs485_enable_tx()
{
	digitalWrite(SERIAL_DE_PIN, true);
	digitalWrite(SERIAL_nRE_PIN, true);
}

void rs485_enable_rx()
{
	digitalWrite(SERIAL_DE_PIN, false);
	digitalWrite(SERIAL_nRE_PIN, false);
}

void rs485_send_string(const char* s)
{
	rs485_enable_tx();
	Serial.print("TX:");
	Serial.println(s);
	Serial.flush();
	rs485_enable_rx();
}

// Read "my ID" from EEPROM
uint8_t id_read()
{
	return EEPROM.read(0x00);
}

// write "my ID" to EEPROM
void id_write(uint8_t id)
{
	EEPROM.write(0x00,id);
}

// Forward declaration of command functions:
static void do_cmd_id();
static void do_cmd_get(const char* varname);
static void do_cmd_set(const char* varname, double value);
static void do_cmd_setid(uint8_t new_id);

// Checks whether "str" starts with "substr"
static inline bool startsWith(const char* str, const char* substr)
{
	return !strncasecmp(str,substr, strlen(substr));
}

/* Format of commands:
*
* TO <ID> <CMD> <ARGS...>
*
*/
void process_command(const char*cmd)
{
	// Windows may be slow to reset the RTS signal so the hardware RS485 board parses our sent data, 
	// so make sure of inserting a "large" delay before we transmit anything:
	delay(30); // ms

	const auto len = strlen(cmd);
	if (len<3)
	{
		// wrong command? corrupt data?
		return;
	}

	if (!startsWith(cmd,"TO "))
	{
		rs485_send_string("does not start TO\n");
		return;
	}

	int target_id = 0xEE; // init to invalid value
	if (!sscanf(cmd+3,"%i",&target_id))
	{
		// Couldn't parse. Don't answer with an error code since we were not sure 
		// about whether the message was sent to this board (!).
		return;
	}

	if (target_id!=MY_ID)
	{
		// silently ignore this commands: it's not for us.
		return;
	}

	// advance cmd pointer to the next useful position:
	cmd+=3;
	while (*cmd!=' ')
	{
		if (*cmd=='\0') return;
		++cmd;
	}
	// Start with the next non blank char:
	cmd++;

	if (!strncmp(cmd,"ID",2))
	{
		return do_cmd_id();
	}
	if (!strncmp(cmd,"SETID ",6))
	{
		unsigned int new_id=0;
		if (1==sscanf(cmd+6,"%u",&new_id))
		{
			do_cmd_setid(new_id);
			return rs485_send_string("OK|ID changed.\n");
		}
		else
		{
			return rs485_send_string("ERROR|Cannot parse new ID value\n");
		}
	}
	if (!strncmp(cmd,"GET ",4))
	{
		return do_cmd_get(cmd+4);
	}

	char s[60];
	sprintf(s,"ERROR|Unrecognized command: `%.20s`\n", cmd);
	rs485_send_string(s);
}

void do_cmd_id()
{
	char s[60];
	sprintf(s,"OK|GalgasDidactivas ID=%u Build: " __TIMESTAMP__  "\n", id_read());
	rs485_send_string(s);
}


void do_cmd_setid(uint8_t new_id)
{
	id_write(new_id);
	MY_ID = new_id;
}

void do_cmd_get(const char* varname)
{
	char s[60];
	if (startsWith(varname,"STRAIN"))
	{
		sprintf(s,"OK|%u\n", measured_real_strain);
		return rs485_send_string(s);
	}
	if (startsWith(varname,"OFFSET"))
	{
		sprintf(s,"OK|%u\n", adc_zero_strain_offset);
		return rs485_send_string(s);
	}
	if (startsWith(varname,"PWM_CONST"))
	{
		sprintf(s,"OK|%u\n", static_cast<unsigned int>(STRAIN_TO_PWM_CONST*1000U));
		return rs485_send_string(s);
	}

	rs485_send_string("ERROR|GET: Unrecognized variable name\n");
}
