#include "LPD8806.h"
#define BTSerial Serial1
#define BAUD 115200

int nLEDs = 96;
int dataPin  = 8;
int clockPin = 9;
LPD8806 strip = LPD8806(nLEDs, dataPin, clockPin);

int array[48]; //array mit 48 Einträgen 0-47

void setup() {
 BTSerial.begin(BAUD);
 Serial1.begin(BAUD);
 
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
}

void setPinLow(int pin){
    for (int i = 0; i < 10; i++){
        bool isPin = (i==pin);
        bool PinLevel = !isPin;
   
        digitalWrite(i+22, PinLevel);
    }
}

void colorWipe(uint32_t c, uint8_t wait) {
    int i;

    for (i=0; i < strip.numPixels(); i++) {
        strip.setPixelColor(i, c);
        strip.show();
        delay(wait);
    }
}

void loop() {
  int j;
    String data = BTSerial.readStringUntil('\n');
    if (data.length() > 0){
        array[48] = {'data'}; // dann sortieren und überschüssige Einträge löschen
        for (j = 0; j < 48; j++) {
            Serial.println(array[j]);
        //Serial1.println("I got this String: ");
        //Serial1.println(data);
    }
    colorWipe(strip.Color(  127,   127, 127), 50);
        for(int zeile = 0; zeile < 10; zeile++) {
            setPinLow(zeile);
            for(int i=0; i<5; i++){
                Serial1.print(digitalRead(2 + i));
                if (digitalRead == LOW){
                    strip.setPixelColor(i , 0, 127, 127); //einzelne Led ansteuern
                    strip.show(); 
                }
             
            }
        Serial1.println("");
        }
    Serial1.println("---------------------------");
    delay(500);
    }
}
