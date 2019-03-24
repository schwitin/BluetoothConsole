#include <SoftwareSerial.h>


// Nachricht, die gerade Zeichen für Zeichen empfangen wird.
String nachricht = "";

const byte rxPin = 10;
const byte txPin = 11;

SoftwareSerial bluetooth(rxPin, txPin);


void setup() {
  bluetooth.begin(9600);
  Serial.begin(9600);    
  pinMode(LED_BUILTIN, OUTPUT);
  //digitalWrite(LED_BUILTIN, LOW); 
}

void loop() {
  empangeNachricht();
}


void empangeNachricht(){
  //digitalWrite(LED_BUILTIN, HIGH); 
  if (bluetooth.available()) {
    char c = bluetooth.read();

    // Wir schmeissen möglichen Müll vor der Nachicht weg
    if (c == '{'){
      nachricht = "";
      //digitalWrite(LED_BUILTIN, HIGH); 
    }
    
    // Nachricht ggf. unvollständig => wir verwerfen diese
    if (c == '}' && !nachricht.startsWith("{")){
      nachricht = "";
      return;
    }
    nachricht += c;
    Serial.println(nachricht);

  } 
  else if (nachricht.endsWith("}")){
    // Wir haben die erwartete Nachricht empfangen. Das ist unsere Distanz.
    nachricht.replace("{", "");
    nachricht.replace("}", "");
    sendeNachricht(nachricht);

    nachricht = "";
    //digitalWrite(LED_BUILTIN, LOW);
  }
}

void sendeNachricht(String _nachricht){
   bluetooth.println("{" + _nachricht + "}");
}
