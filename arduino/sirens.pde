#define OFF 0
#define ON 1

int siren_one_pin = 4;
int siren_one_state = OFF;
int siren_two_pin = 5;
int siren_two_state = OFF;

void setup() {
  // Initialize serial communication:
  Serial.begin(9600); 

  // Set up our pins
  pinMode(siren_one_pin, OUTPUT);
  pinMode(siren_two_pin, OUTPUT);
}

void loop() {
  // Dump our state
//  Serial.print("SirenOne[");
//    Serial.print(siren_one_state);
//    Serial.println("]");
//  Serial.print("SirenTwo[");
//    Serial.print(siren_two_state);
//    Serial.println("]");
  
  // Read our input
  if (Serial.available() > 0) {
    int in_byte = Serial.read();
    
    // We support both toggling and forced on/off
    //
    // d = Siren 1 OFF
    // D = Siren 1 ON
    // f = Siren 2 OFF
    // F = Siren 2 ON
    //
    // e = Toggle Siren 1
    // r = Toggle Siren 2
    
    switch (in_byte) {
    case 'd':
      // Siren 1 OFF
      digitalWrite(siren_one_pin, LOW);
      siren_one_state = OFF;
      break;
    case 'f':
      // Siren 2 OFF    
      digitalWrite(siren_two_pin, LOW);
      siren_one_state = OFF;
      break;
    case 'D':    
      // Siren 1 ON
      digitalWrite(siren_one_pin, HIGH);
      siren_one_state = ON;
      break;
    case 'F':
      // Siren 2 ON    
      digitalWrite(siren_two_pin, HIGH);
      break;
    case 'e': 
      // Toggle Siren 1
      if(siren_one_pin = ON) {
        digitalWrite(siren_one_pin, LOW);
        siren_one_state = OFF;
      } else {
        digitalWrite(siren_one_pin, HIGH);
        siren_one_state = ON;
      }
      break;
    case 'r': 
      // Toggle Siren 2
      if(siren_two_pin = ON) {
        digitalWrite(siren_two_pin, LOW);
        siren_two_state = OFF;
      } else {
        digitalWrite(siren_two_pin, HIGH);
        siren_two_state = ON;
      }
      break;
    } 
  }
}

