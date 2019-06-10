#include <SoftwareSerial.h>
#include <AsyncDelay.h>


// Nachricht, die gerade Zeichen für Zeichen empfangen wird.
String nachricht = "";

const byte rxPin = 10;
const byte txPin = 11;

SoftwareSerial bluetooth(rxPin, txPin);
AsyncDelay delay_3s;


void setup() {
  bluetooth.begin(9600);
  Serial.begin(9600);
  while (!Serial) {
    ; // wait for serial port to connect. Needed for native USB port only
  }
  delay_3s.start(3000, AsyncDelay::MILLIS);
  pinMode(LED_BUILTIN, OUTPUT);; 
}

void loop() {
  empangeNachricht();
}


void empangeNachricht(){
  if (bluetooth.available()) {
    char c = bluetooth.read();

    // Wir schmeissen möglichen Müll vor der Nachicht weg
    if (c == '{'){
      delay_3s.repeat();
      nachricht = "";
      digitalWrite(LED_BUILTIN, HIGH); 
    }
    
    nachricht += c;
  } 
  else if (nachricht.endsWith("}") || delay_3s.isExpired()){
    // Wir haben die erwartete Nachricht empfangen.
    nachricht.replace("{", "");
    nachricht.replace("}", "");

    if (nachricht != NULL && nachricht != ""){
      Serial.println(nachricht);
      sendeNachricht(nachricht);
    }
    delay_3s.repeat();
    nachricht = "";
    digitalWrite(LED_BUILTIN, LOW);
  }
}

void sendeNachricht(String _nachricht){
   bluetooth.println("{" + _nachricht + "}");
}
