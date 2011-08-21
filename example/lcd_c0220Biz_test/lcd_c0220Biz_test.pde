#include <WProgram.h>
#include <Wire.h>
#include "LCD_C0220BiZ.h"

// ???:fmalpartida:20110821 

/*!
    @defined    CHAR_WIDTH
    @abstract   Character witdth of the display, expressed in pixeles per character.
*/
#define CHAR_WIDTH  5

/*!
    @defined    LDR_PIN
    @abstract   Light Detection Resistor Analog pin.
    @discussion Define the Analog channel that will be used to read a LDR.
*/
#define LDR_PIN     7

LCD_C0220BIZ lcd = LCD_C0220BIZ ( 2, 20, 0x78, 0 );

/*!
    @const      charBitmap 
    @abstract   Define Character bitmap for the bargraph.
    @discussion Defines a character bitmap to represent a bargraph on a text
    display. The bitmap goes from a blank character to full black.
*/
const uint8_t charBitmap[][8] = {
   { 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0 },
   { 0x10, 0x10, 0x10, 0x10, 0x10, 0x10, 0x10, 0x0 },
   { 0x18, 0x18, 0x18, 0x18, 0x18, 0x18, 0x18, 0x0 },
   { 0x1C, 0x1C, 0x1C, 0x1C, 0x1C, 0x1C, 0x1C, 0x0 },
   { 0x1E, 0x1E, 0x1E, 0x1E, 0x1E, 0x1E, 0x1E, 0x0 },
   { 0x1F, 0x1F, 0x1F, 0x1F, 0x1F, 0x1F, 0x1F, 0x0}
};

/*!
    @function
    @abstract   Braws a bargraph onto the display representing the value passed.
    @discussion Draws a bargraph on the specified row using barLength characters. 
    @param      value[in] Value to represent in the bargraph
    @param      row[in] Row of the LCD where to display the bargraph. Range (0, 1)
    for this display.
    @param      barlength[in] Length of the bar, expressed in display characters.

    @result     None
*/
static void drawBars ( int value, uint8_t row, uint8_t barLength )
{
   int numBars;

   // Set initial titles on the display
   lcd.setCursor (row, 0);
   lcd.print ("L");
   lcd.setCursor (row, 19 );
   lcd.print ("H");

   // Calculate the size of the bar
   value = map ( value, 0, 1024, 0, ( barLength - 1) * CHAR_WIDTH );
   numBars = value / CHAR_WIDTH;

   lcd.setCursor ( row,2 );
   
   // Draw the bars
   while ( numBars-- )
   {
      lcd.print ( char( (sizeof(charBitmap ) / sizeof(charBitmap[0])) - 1 ) );
   }
   
   // Draw the fractions
   numBars = value % CHAR_WIDTH;
   lcd.print ( char(numBars) );
}

void setup ()
{
   int i; 
   int charBitmapSize = (sizeof(charBitmap ) / sizeof (charBitmap[0]));
   
   analogReference ( DEFAULT );
   pinMode ( LDR_PIN, INPUT ); 
   lcd.init ();
   lcd.setContrast(2);
  
   // Load 
   for ( i = 0; i < charBitmapSize; i++ )
   {
      lcd.load_custom_character ( i, (uint8_t *)charBitmap[i] );
   }
}


void loop ()
{
  int lightLevel;
  
  lcd.clear ();
  lcd.print ("Light Level:");
  lightLevel = analogRead (LDR_PIN);
  lcd.setCursor ( 0, 15 );
  lcd.print ( lightLevel );  
  lcd.setCursor (1,0);
  drawBars ( lightLevel, 1, 16 );
  delay (100);
}
