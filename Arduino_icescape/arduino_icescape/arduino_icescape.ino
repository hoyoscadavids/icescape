#include "LPD8806.h"
#define BTSerial Serial1
#define BAUD 115200

int nLEDs = 96;
int dataPin  = 8;
int clockPin = 9;
LPD8806 strip = LPD8806(nLEDs, dataPin, clockPin);

char ledArray[48];
int reedArray[48];

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
 colorWipe(strip.Color(  255,   200, 245), 50);
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
 //     delay(wait);
  }

}

void loop() {
  
 
 if(BTSerial.available()){
  String data = BTSerial.readStringUntil('\n');
  bool started = false;
  int nextIndex = 0;
  char start = '+', finish = '-';
   if (data.length() > 0){
         for(int i = 0; i < data.length(); i++){
             
             if(data.charAt(i) == finish){
                started = false;
              }
            
           if(started == true){
             
                ledArray[nextIndex] = data.charAt(i);
                nextIndex++;
              }
             if(data.charAt(i) == start){
                started = true;
              }
           
    }   
    for(int i = 0; i < 96; i+=2){
      if(ledArray[i/2] == '1'){
        strip.setPixelColor(i, 255, 200, 245);
        strip.setPixelColor(i+1, 255, 200, 245);
        }
       else if(ledArray[i/2] == '0'){
        strip.setPixelColor(i, 0, 50, 255);
        strip.setPixelColor(i+1, 0, 50, 255);
        }
       
          strip.show();
      }
      // Serial.write(ledArray);   
     //  Serial.println("I got this String: ");
        
 }
}
 

  for(int row = 0; row < 10; row++) {
    setPinLow(row);
    for(int element=0; element<5; element++){
        Serial.print(digitalRead(2 + element));
        reedArray[element+(row*sizeof(element))] = digitalRead(2+element);
          

        
    }
    for(int i=0; i<48; i++){
      if(reedArray[i]== '0' && reedArray[i]==ledArray[i]){
        strip.setPixelColor(2*i, 255, 0, 0);
        strip.setPixelColor(2*i+1, 255, 0, 0);
        
        }
     }
         
    
    Serial.println("");
  }
  Serial.println("---------------------------");
  //delay(200);


}
