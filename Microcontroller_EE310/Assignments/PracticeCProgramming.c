/*
------Program Description
This program simulates a temperature monitoring system using a PIC18 microcontroller. 
A structure is used to store sensor information, including a sensor ID and its temperature value. 
The program continuously evaluates the temperature using a function and controls three LEDs 
connected to PORTD to indicate the temperature level. A low temperature is defined as below 25°C 
and turns on the green LED, a medium temperature is defined as 25°C to less than 30°C and turns 
on the yellow LED, and a high temperature is defined as 30°C or above and turns on the red LED. 
This program demonstrates how structures, functions, and GPIO control can be combined to monitor 
and respond to sensor data in an embedded system.
*/

#define _XTAL_FREQ 4000000 
#include <xc.h>
//-------------------------------------
// Simple definitions
//-------------------------------------
#define ON   1
#define OFF  0

//-------------------------------------
// Structure for sensor information
//-------------------------------------
struct SensorData
{
    unsigned char sensorID;
    unsigned char temperature;
};

//-------------------------------------
// Function Prototypes
//-------------------------------------
void InitializeSystem(void);
void MonitorSensor(struct SensorData s);
void TurnOffAllLEDs(void);

//-------------------------------------
// Main Program
//-------------------------------------
void main(void)
{
    struct SensorData sensor1;

    InitializeSystem();

    // Example sensor values
    sensor1.sensorID = 1;
    sensor1.temperature = 28;

    while(1)
    {
        MonitorSensor(sensor1);

        // Example changing temperature values
        __delay_ms(2000);
        sensor1.temperature = 22;
        MonitorSensor(sensor1);

        __delay_ms(2000);
        sensor1.temperature = 27;
        MonitorSensor(sensor1);

        __delay_ms(2000);
        sensor1.temperature = 3985;
        MonitorSensor(sensor1);
    }
}

//-------------------------------------
// Initialize Port Directions
//-------------------------------------
void InitializeSystem(void)
{
    TRISDbits.TRISD0 = 0;   // Green LED output
    TRISDbits.TRISD1 = 0;   // Yellow LED output
    TRISDbits.TRISD2 = 0;   // Red LED output

    PORTDbits.RD0 = OFF;
    PORTDbits.RD1 = OFF;
    PORTDbits.RD2 = OFF;
}

//-------------------------------------
// Turn OFF all LEDs
//-------------------------------------
void TurnOffAllLEDs(void)
{
    PORTDbits.RD0 = OFF;
    PORTDbits.RD1 = OFF;
    PORTDbits.RD2 = OFF;
}

//-------------------------------------
// Monitor sensor temperature
//-------------------------------------
void MonitorSensor(struct SensorData s)
{
    TurnOffAllLEDs();

    if(s.temperature < 25)
    {
        PORTDbits.RD0 = ON;    // Green LED ON
    }
    else if(s.temperature >= 25 && s.temperature < 50)
    {
        PORTDbits.RD1 = ON;    // Yellow LED ON
    }
    else
    {
        PORTDbits.RD2 = ON;    // Red LED ON
    }
}
