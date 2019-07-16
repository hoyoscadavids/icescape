
#include "LPD8806.h"
#define BTSerial Serial1
#define BAUD 115200

// LED initialization
int nLEDs = 96;
int dataPin  = 8;
int clockPin = 9;
LPD8806 strip = LPD8806(nLEDs, dataPin, clockPin);

char ledArray[48];
int reedArray[48];
bool reversedRow = false;

void setup() {
  for (int i = 0; i < 48; i ++) {
    reedArray[i] = 1;
    ledArray[i] = '1';
  }
  BTSerial.begin(BAUD);
  Serial.begin(BAUD);

  // Initialize pins for the Matrix
  pinMode(2, INPUT_PULLUP);
  pinMode(3, INPUT_PULLUP);
  pinMode(4, INPUT_PULLUP);
  pinMode(5, INPUT_PULLUP);
  pinMode(6, INPUT_PULLUP);
  pinMode(22, OUTPUT);
  pinMode(23, OUTPUT);
  pinMode(24, OUTPUT);
  pinMode(25, OUTPUT);
  pinMode(26, OUTPUT);
  pinMode(27, OUTPUT);
  pinMode(28, OUTPUT);
  pinMode(29, OUTPUT);
  pinMode(30, OUTPUT);
  pinMode(31, OUTPUT);

  strip.begin();
  strip.show();
  colorWipe(strip.Color(0, 50, 255), 50);
}

void setPinLow(int pin) {
  for (int i = 0; i < 10; i++) {
    bool isPin = (i == pin);
    bool PinLevel = !isPin;
    digitalWrite(i + 22, PinLevel);
  }
}

void colorWipe(uint32_t c, uint8_t wait) {
  // Colors the whole field
  int i;

  for (i = 0; i < strip.numPixels(); i++) {
    // Change the color of all the LEDS.
    // strip.show() is called every time to give a slow wipe effect
    strip.setPixelColor(i, c);
    strip.show();
  }

}

void lost(int index) {
  strip.setPixelColor(index * 2 , 255, 0, 0);
  strip.setPixelColor(index * 2 + 1, 255, 0, 0);
  colorWipe(strip.Color(255, 0, 0), 50);
  delay(2000);
  colorWipe(strip.Color(0, 50, 255), 50);
  delay(200);
  showRoute();
  delay(2000);
  colorWipe(strip.Color(0, 50, 255), 50);
}

void showRoute() {
  for (int i = 0; i < 96; i += 2) {
    if (ledArray[i / 2] == '1') {
      strip.setPixelColor(i, 255, 200, 245);
      strip.setPixelColor(i + 1, 255, 200, 245);
    }
    else if (ledArray[i / 2] == '0') {
      strip.setPixelColor(i, 0, 50, 255);
      strip.setPixelColor(i + 1, 0, 50, 255);
    }
    strip.show();
  }
}

void loop() {
  if (BTSerial.available()) {
    // If there's data to read from the bluetooth, then pack it in the 
    // LED array
    // The data comes in the form 0+0000000000000000-
    // The number before the "+" means the order of the positions in the matrix (0 - 2)
    // The next 16 binary numbers describe if the LED should be on or off (16 * 3 = 48 Fields)
    // The "-" represents the end of the String
    // 
    String data = BTSerial.readStringUntil('\n');
    bool started = false;
    int nextIndex = 0;
    char start = '+', finish = '-';
    if (data.length() > 0) {
      for (int i = 0; i < data.length(); i++) {
        if (data.charAt(i) == finish) {
          started = false;
        }
        if (started == true) {

          ledArray[nextIndex] = data.charAt(i);
          nextIndex++;
        }
        if (data.charAt(i) == start) {
          started = true;
        }
      }
      showRoute();
      delay(5000);
      colorWipe(strip.Color(0, 50, 255), 50);
    }
    Serial.println("");
  }

  int helperIndex = 0, offset = 0, elementCounter = 0;
  for (int row = 0; row < 10; row++) {
    // Check the whole matrix to get the player's position
    helperIndex = 0;
    helperIndex = (row % 2 == 0) ? 0 : 4;
    setPinLow(row);
    for (int element = 0; element < 5; element++) {
      int index = (element + (row * 5)) + helperIndex;
      if (row >= 3) {
        offset = 1;
      }
      if (row >= 6) {
        offset = 2;
      }
      if (row % 2 != 0) {
        helperIndex -= 2;
      }
      reedArray[index - offset] = digitalRead(2 + element);
      if ((reedArray[index] == 0 && ledArray[index] == '0')) {
        // If the field is wrong
        lost(index);
      }
      else if ((reedArray[index] == 0 && ledArray[index] == '1' )) {
        if ((row == 9 || row == 8 && (element == 3 || element == 4))) {
          // If the player comes to the last field: Displays Green
          colorWipe(strip.Color(0, 50, 0), 50);
          delay(1000);
          colorWipe(strip.Color(0, 50, 255), 50);
        }
        else {
          // Color the Field White when the movement was correct
          strip.setPixelColor(index * 2 ,  255, 200, 245);
          strip.setPixelColor(index * 2 + 1,  255, 200, 245);
        }
      }
      elementCounter++;
      strip.show();
    }
  }
}
