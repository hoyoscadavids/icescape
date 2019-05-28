#include "LPD8806.h"
#define BTSerial Serial1
#define BAUD 115200

int nLEDs = 96;
int dataPin  = 8;
int clockPin = 9;
LPD8806 strip = LPD8806(nLEDs, dataPin, clockPin);


void setup() {
 BTSerial.begin(BAUD);
 Serial.begin(BAUD);
 
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
 colorWipe(strip.Color(  127,   127, 127), 50);
}

void setPinLow(int pin){
 for (int i = 0; i < 10; i++){
   bool isPin = (i==pin);
   bool PinLevel = !isPin;
   
   digitalWrite(i+22, PinLevel);
  }
<<<<<<< HEAD

=======
>>>>>>> parent of 7d1415a... Update ReedSwitchMatrixtest.ino
}

void colorWipe(uint32_t c, uint8_t wait) {
  int i;

  for (i=0; i < strip.numPixels(); i++) {
      strip.setPixelColor(i, c);
      strip.show();
<<<<<<< HEAD
 //     delay(wait);
  }

}

void loop() {
  
 
 if(BTSerial.available()){
  String data = BTSerial.readStringUntil('\n');
   if (data.length() > 0){
        Serial.println("I got this String: ");
        Serial.println(data);
 }
}
 

  for(int zeile = 0; zeile < 10; zeile++) {
    setPinLow(zeile);
    for(int i=0; i<5; i++){
        Serial.print( digitalRead(2 + i) );
        if (digitalRead == LOW){
 //         strip.setPixelColor(22+i, 0, 127, 127);
 //         strip.show(); 
        }
         
    }
    Serial.println("");
  }
  Serial.println("---------------------------");
  delay(200);


=======
      delay(wait);
  }
}

void loop() {
 String data = BTSerial.readStringUntil('\n');
 if (data.length() > 0){
        Serial1.println("I got this String: ");
        Serial1.println(data);
 }
  colorWipe(strip.Color(  127,   127, 127), 50);
    for(int zeile = 0; zeile < 10; zeile++) {
        setPinLow(zeile);
        for(int i=0; i<5; i++){
            Serial1.print( digitalRead(2 + i) );
            if (digitalRead == LOW){
              strip.setPixelColor(22+i, 0, 127, 127);
              strip.show(); 
            }
             
        }
        Serial1.println("");
    }
    Serial1.println("---------------------------");
    delay(500);
>>>>>>> parent of 7d1415a... Update ReedSwitchMatrixtest.ino
}
/*
 for (int i = 0; i < 10; i++){
   setPinHigh(i);

   for (int j = 2; j < 7; j++){

     if (i == 0){
       Serial.print("Zeile 1 / ");
     if (i == 1){
       Serial.print("Zeile 2 / ");
     if (i == 2){
       Serial.print("Zeile 3 / ");
     if (i == 3){
       Serial.print("Zeile 4 / ");
     if (i == 4){
       Serial.print("Zeile 5 / ");
     if (i == 5){
       Serial.print("Zeile 6 / ");
     if (i == 6){
       Serial.print("Zeile 7 / ");
     if (i == 7){
       Serial.print("Zeile 8 / ");
     if (i == 8){
       Serial.print("Zeile 9 / ");  
     }else{
       Serial.print("Zeile 10 / ");
     }
     if (j == 2){
       Serial.print("Spalte a: ");
     if (j == 3){
       Serial.print("Spalte b: ");
     if (j == 4){
       Serial.print("Spalte c: ");
     if (j == 5){
       Serial.print("Spalte d: ");
     }else{
       Serial.print("Spalte e: ");
     }

     Serial.println(digitalRead(j));

   }
 }

 delay(500);
}
*/
