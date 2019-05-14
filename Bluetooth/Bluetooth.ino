#define BTSerial Serial1
#define BAUD 115200

void setup() {
    BTSerial.begin(BAUD);
    Serial.begin(BAUD);
}

void loop() {
    String data = BTSerial.readStringUntil('\n');



    if (data.length() > 0){
        Serial.println("I got this String: ");
        Serial.println(data);
    }

}

