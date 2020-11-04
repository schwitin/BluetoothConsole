
int ziegel[5][200];
int anzahlZiegel;


void setup() {
  //Serial.begin(9600);
  //if(!Serial){;}
  Serial1.begin(9600);
  //Serial1.setTimeout(4000);
}

void loop() {
  readZiegel();
}


void readZiegel(){
  char myBuffer[5];
  int feld;
  int charIndex;
  char c;
  
  while(true){
    if (Serial1.available()) 
    {
      c = Serial1.read();
      if(c == '}')
      {        
        c = ' ';
        sendeAntwort();
        return;
      }
      
      if(c == '{')
      {
        anzahlZiegel = 0;
        charIndex = 0;
        feld = 0;
        c = ' ';
        continue;        
      }
      
      
      myBuffer[charIndex] = c;
      charIndex++;
      if(charIndex == 4)
      {
        myBuffer[charIndex] = '\0';
        ziegel[feld][anzahlZiegel] = atoi(myBuffer);
        charIndex = 0;
        myBuffer[charIndex] = '\0';
        feld++;
        
        if(feld == 4)
        {
          feld = 0;
          anzahlZiegel++;          
        } 
      }
      
    } 
  }
}


void sendeAntwort()
{
  Serial1.print("{Anzahl:");
  Serial1.print(anzahlZiegel);
  Serial1.print(" 0=");
  Serial1.print(ziegel[0][0]);
  Serial1.print(" 1=");
  Serial1.print(ziegel[1][0]);
  Serial1.print(" 2=");
  Serial1.print(ziegel[2][0]);
  Serial1.print(" 3=");
  Serial1.print(ziegel[3][0]);  
  Serial1.println("}");
}
