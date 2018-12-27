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

// LEDs: 
constexpr int LED1_PIN = 9; // uC pin 13, PB1
constexpr int LED2_PIN = 10; // uC pin 14, PB2

void setup()
{
	pinMode(LED1_PIN, OUTPUT);
	pinMode(LED2_PIN, OUTPUT);
}

void loop() 
{
	// put your main code here, to run repeatedly:
	for (int pc = 0; pc <255; pc++)
	{
		analogWrite(LED1_PIN, pc);
		analogWrite(LED2_PIN, pc);
		delay(5);
	}

}

