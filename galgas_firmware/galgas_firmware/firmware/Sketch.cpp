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

#include <Arduino.h>
#include <Wire.h>
#include "MCP342X.h"

// LEDs: 
constexpr int LED1_PIN = 9; // uC pin 13, PB1
constexpr int LED2_PIN = 10; // uC pin 14, PB2

// The ADC:
MCP342X adc;
bool adc_init_ok = false;
const auto ADC_GAIN = MCP342X_GAIN_4X;

// The residual strain, acquired after reset:
int16_t adc_zero_strain_offset = 0;

// TODO: Adjust this constant, by trial and error.
// TODO: Split in several constants with more physical meaning? See other TO-DOs below
double STRAIN_TO_PWM_CONST = 0.1;



// func. decls:
void do_led_ramp_up_down(int led_id, int delay_speed_ms = 6);

void setup()
{
	// Flash LEDs at start up:
	do_led_ramp_up_down(LED1_PIN, 3);
	do_led_ramp_up_down(LED2_PIN, 3);

	// Init I2C bus:
	Wire.begin();
	// Use max I2C speed (400 kHz)
	TWBR = 12;

	// Init serial port:
	Serial.begin(9600);

	// wait for Serial comms to become ready
	while (!Serial) {}
		
	Serial.println("# Didactic Strain Gauges-LED System");
	Serial.println("# System is up and ready!");
}

void loop()
{
	// Test connection to ADC once after boot up:
	// --------------------------------------------------
	if (!adc_init_ok)
	{
		Serial.println("# Testing ADC connection...");
		adc_init_ok = adc.testConnection();
		if (adc_init_ok)
		{
			Serial.println("# MCP342X connection successful!");

			adc.configure(
				MCP342X_MODE_CONTINUOUS |
				MCP342X_CHANNEL_1 |
				MCP342X_SIZE_16BIT |
				ADC_GAIN
				);

			Serial.print("# ADC config register=");
			Serial.println(adc.getConfigRegShdw(), HEX);
			
			// Read a few samples (a discard them) waiting for the 
			// analog value to stabilize after reset, then take it as 
			// the "residual strain" offset value:
			// (16bit -> continuous rate of 15 SPS)
			for (int i=0;i<15;i++)
			{
				adc.startConversion();
				adc.getResult(&adc_zero_strain_offset);
			}
			Serial.print("# Using ADC offset value=");
			Serial.println(adc_zero_strain_offset);

			Serial.println("# Entering main program...");
		}
		else
		{
			Serial.println("# ***MCP342X connection failed****!");
			Serial.println("# Retrying in one second...");
			delay(1000);
			return;
		}
	}
	
	// Main task: read ADC and flash LEDs accordingly
	// --------------------------------------------------
	int16_t  adc_value;
	adc.startConversion();
	adc.getResult(&adc_value);
	
	// Strain is measured - offset (residual structural strain)
	const int32_t real_strain = adc_value - adc_zero_strain_offset;
	
	// TODO: Convert to actual strain value.
	
	// Convert to PWM (0-255)
	int pwm_value= STRAIN_TO_PWM_CONST * real_strain;
	
	// TODO: positive / negative, one LED or the other one.
	analogWrite(LED1_PIN, pwm_value);

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