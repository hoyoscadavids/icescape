void setup() {
 Serial.begin(115200);
 pinMode(2, INPUT_PULLUP);
 pinMode(3, INPUT_PULLUP);
 pinMode(10, OUTPUT);
 pinMode(11, OUTPUT);
}

void setPinHigh(int pin){
 for (int i = 0; i < 2; i++){
   digitalWrite(i+10, LOW);
 }

 digitalWrite(pin+10, HIGH);
}

void loop() {
 for (int i = 0; i < 2; i++){
   setPinHigh(i);

   for (int j = 2; j < 4; j++){

     if (i == 0){
       Serial.print("Zeile 1 / ");
     }else{
       Serial.print("Zeile 2 / ");
     }
     if (j == 2){
       Serial.print("Spalte 1: ");
     }else{
       Serial.print("Spalte 2: ");
     }

     Serial.println(digitalRead(j));

   }
 }

 delay(500);
}
