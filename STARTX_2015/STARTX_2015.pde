// STARTX ChipKit source
// 2015 dvnmk

#include <AccelStepper.h>

/* int sigU = A0; int stpU = A1; int enU = A2; // A1 > U ; SIG > STP > EN */
/* int sigV = A3; int stpV = A4; int enV = A5; // B2 > V */
/* int sigW = A6; int stpW = A7; int enW = A8; // C > W */
/* int sigX = A9; int stpX = A10; int enX = A14; // D > X */
/* int sigY = A15; int stpY = 53; int enY = 52; // E > Y */
int sigP = 48; int stpP = 49; int enP = 46; // F > P
int sigQ = 47; int stpQ = 44; int enQ = 45; // G > Q
int sigR = 42; int stpR = 43; int enR = 40; // H > R
int sigS = 41; int stpS = 38; int enS = 39; // I > S
int sigT = 36; int stpT = 37; int enT = 34; // J > T
int sigK = 35; int stpK = 32; int enK = 33; // K
int sigL = 30; int stpL = 31; int enL = 28; // L
int sigM = 26; int stpM = 29; int enM = 25; // M
int sigN = 27; int stpN = 22; int enN = 23; // N
int sigO = 21; int stpO = 20; int enO = 19; // O
int sigF = 18; int stpF = 17; int enF = 16; // P > F
int sigG = 15; int stpG = 14; int enG = 70; // Q > G
int sigH = 71; int stpH = 72; int enH = 73; // R > H
int sigI = 74; int stpI = 75; int enI = 76; // S > I
int sigJ = 77; int stpJ = 2; int enJ = 3; // T > J
int sigA = 4; int stpA = 5; int enA = 6; // U > A
int sigB = 7; int stpB = 78; int enB = 8; // V > B
int sigC = 79; int stpC = 80; int enC = 9; // W > C
int sigD = 81; int stpD = 82; int enD = 10; // X > D
int sigE = 83; int stpE = 11; int enE = 12; // Y > E

int dirA = 101; int dirB = 102; int dirC = 103; int dirD = 104; 
int dirE = 105; int dirF = 106; int dirG = 107; int dirH = 108; 
int dirI = 109; int dirJ = 110; int dirK = 111; int dirL = 112; 
int dirM = 113; int dirN = 114; int dirO = 115; int dirP = 116; 
int dirQ = 117; int dirR = 118; int dirS = 119; int dirT = 120; 
/* int dirU = 121; int dirV = 122; int dirW = 123; int dirX = 124;  */
/* int dirY = 125; // nach andromeda */

int val = 0; // fuer Switch
int stromPin = 84; // strom Ein/Aus
int ms = 85 ; // alle_MS

// 1:Defaults to 2 pins, STP, DIR
AccelStepper stepper1(1, stpA, dirA); AccelStepper stepper2(1, stpB, dirB); AccelStepper stepper3(1, stpC, dirC); 
AccelStepper stepper4(1, stpD, dirD); AccelStepper stepper5(1, stpE, dirE); AccelStepper stepper6(1, stpF, dirF); 
AccelStepper stepper7(1, stpG, dirG); AccelStepper stepper8(1, stpH, dirH); AccelStepper stepper9(1, stpI, dirI); 
AccelStepper stepper10(1, stpJ, dirJ); AccelStepper stepper11(1, stpK, dirK); AccelStepper stepper12(1, stpL, dirL); 
AccelStepper stepper13(1, stpM, dirM); AccelStepper stepper14(1, stpN, dirN); AccelStepper stepper15(1, stpO, dirO); 
AccelStepper stepper16(1, stpP, dirP); AccelStepper stepper17(1, stpQ, dirQ); AccelStepper stepper18(1, stpR, dirR); 
AccelStepper stepper19(1, stpS, dirS); AccelStepper stepper20(1, stpT, dirT); 

int maxSpeed = 1000; // Accelstepper intVar
int accelVar = 500;
//int normSpeed = 100;
int normSpeed = 1500; //BENUTZT??? fur .runSpeed() constant run speed.

void setup()
{  
  pinMode(stromPin, OUTPUT); 
  digitalWrite(stromPin, LOW); // strom init y aus
  pinMode(ms, OUTPUT); 
  digitalWrite(ms, HIGH); // alle_ms 1/16
  Serial.begin(115200); 
  Serial.println(" >> START[X] << ");
  digitalWrite(stromPin, LOW); // init AUS nochmal
  digitalWrite(ms, HIGH); // init ms nochmal 1/16

  //digitalWrite(sigA, LOW); //opto_input init; pull-down-resistor N/A in ChipKit
  pinMode(sigA, INPUT);   pinMode(sigB, INPUT);   pinMode(sigC, INPUT);   pinMode(sigD, INPUT); 
  pinMode(sigE, INPUT);   pinMode(sigF, INPUT);   pinMode(sigG, INPUT);   pinMode(sigH, INPUT); 
  pinMode(sigI, INPUT);   pinMode(sigJ, INPUT);   pinMode(sigK, INPUT);   pinMode(sigL, INPUT); 
  pinMode(sigM, INPUT);   pinMode(sigN, INPUT);   pinMode(sigO, INPUT);   pinMode(sigP, INPUT); 
  pinMode(sigQ, INPUT);   pinMode(sigR, INPUT);   pinMode(sigS, INPUT);   pinMode(sigT, INPUT); 

  // init EN_off(:=HIGH)
  pinMode(enA, OUTPUT);     digitalWrite(enA, HIGH);  pinMode(enB, OUTPUT);     digitalWrite(enB, HIGH); 
  pinMode(enC, OUTPUT);     digitalWrite(enC, HIGH);   pinMode(enD, OUTPUT);     digitalWrite(enD, HIGH); 
  pinMode(enE, OUTPUT);     digitalWrite(enE, HIGH);   pinMode(enF, OUTPUT);     digitalWrite(enF, HIGH); 
  pinMode(enG, OUTPUT);     digitalWrite(enG, HIGH);   pinMode(enH, OUTPUT);     digitalWrite(enH, HIGH); 
  pinMode(enI, OUTPUT);     digitalWrite(enI, HIGH);     pinMode(enJ, OUTPUT);     digitalWrite(enJ, HIGH); 
  pinMode(enK, OUTPUT);     digitalWrite(enK, HIGH);  pinMode(enL, OUTPUT);     digitalWrite(enL, HIGH); 
  pinMode(enM, OUTPUT);     digitalWrite(enM, HIGH);   pinMode(enN, OUTPUT);     digitalWrite(enN, HIGH); 
  pinMode(enO, OUTPUT);     digitalWrite(enO, HIGH);   pinMode(enP, OUTPUT);     digitalWrite(enP, HIGH); 
  pinMode(enQ, OUTPUT);     digitalWrite(enQ, HIGH);   pinMode(enR, OUTPUT);     digitalWrite(enR, HIGH); 
  pinMode(enS, OUTPUT);     digitalWrite(enS, HIGH);     pinMode(enT, OUTPUT);     digitalWrite(enT, HIGH); 

  // setSpeed() ; Speeds of more than 1000 steps per second are unreliable. -> runSpeed()
  // setMaxSpeed() ; Must be > 0. e.g. 200 -> run() accel bis zun hier
  //
  // setAccel auch must be > 0 ; The desired acceleration in steps per second per second.
  // This is an expensive call since it requires a square root to be calculated.
  // Dont call more ofthen than needed. e.g. 100

  //stepper1.setMinPulseWidth(1);   
  stepper1.setMaxSpeed(maxSpeed);      stepper1.setSpeed(normSpeed);      stepper1.setAcceleration(accelVar); 
  stepper2.setMaxSpeed(maxSpeed);      stepper2.setSpeed(normSpeed);      stepper2.setAcceleration(accelVar);
  stepper3.setMaxSpeed(maxSpeed);      stepper3.setSpeed(normSpeed);      stepper3.setAcceleration(accelVar);
  stepper4.setMaxSpeed(maxSpeed);      stepper4.setSpeed(normSpeed);      stepper4.setAcceleration(accelVar);
  stepper5.setMaxSpeed(maxSpeed);      stepper5.setSpeed(normSpeed);      stepper5.setAcceleration(accelVar);
  stepper6.setMaxSpeed(maxSpeed);      stepper6.setSpeed(normSpeed);      stepper6.setAcceleration(accelVar);
  stepper7.setMaxSpeed(maxSpeed);      stepper7.setSpeed(normSpeed);      stepper7.setAcceleration(accelVar);
  stepper8.setMaxSpeed(maxSpeed);      stepper8.setSpeed(normSpeed);      stepper8.setAcceleration(accelVar);
  stepper9.setMaxSpeed(maxSpeed);      stepper9.setSpeed(normSpeed);      stepper9.setAcceleration(accelVar);
  stepper10.setMaxSpeed(maxSpeed);     stepper10.setSpeed(normSpeed);     stepper10.setAcceleration(accelVar);
  stepper11.setMaxSpeed(maxSpeed);     stepper11.setSpeed(normSpeed);     stepper11.setAcceleration(accelVar); 
  stepper12.setMaxSpeed(maxSpeed);     stepper12.setSpeed(normSpeed);     stepper12.setAcceleration(accelVar);
  stepper13.setMaxSpeed(maxSpeed);     stepper13.setSpeed(normSpeed);     stepper13.setAcceleration(accelVar);
  stepper14.setMaxSpeed(maxSpeed);     stepper14.setSpeed(normSpeed);     stepper14.setAcceleration(accelVar);
  stepper15.setMaxSpeed(maxSpeed);     stepper15.setSpeed(normSpeed);     stepper15.setAcceleration(accelVar);
  stepper16.setMaxSpeed(maxSpeed);     stepper16.setSpeed(normSpeed);     stepper16.setAcceleration(accelVar);
  stepper17.setMaxSpeed(maxSpeed);     stepper17.setSpeed(normSpeed);     stepper17.setAcceleration(accelVar);
  stepper18.setMaxSpeed(maxSpeed);     stepper18.setSpeed(normSpeed);     stepper18.setAcceleration(accelVar);
  stepper19.setMaxSpeed(maxSpeed);     stepper19.setSpeed(normSpeed);     stepper19.setAcceleration(accelVar);
  stepper20.setMaxSpeed(maxSpeed);     stepper20.setSpeed(normSpeed);     stepper20.setAcceleration(accelVar);
}

void loop()
{
  stepper1.run();     stepper2.run();     stepper3.run();     stepper4.run();     stepper5.run();
  stepper6.run();     stepper7.run();     stepper8.run();     stepper9.run();     stepper10.run();
  stepper11.run();    stepper12.run();    stepper13.run();    stepper14.run();    stepper15.run();
  stepper16.run();    stepper17.run();    stepper18.run();    stepper19.run();    stepper20.run();

  //Serial teils
  static int v = 0;
  int x = 0;
  if ( Serial.available()) {
    char ch = Serial.read();

    switch(ch) {
    case '0'...'9': 
      v = v * 10 + ch -'0';  
      break;
      
    case 'a' : // Stepper_A
      if ( v  == 8 ) {
      stepper1.setCurrentPosition(0);
      stepper1.move(v);
      v = 0;
      break;
      }  
      else if (stepper1.distanceToGo() != 0)
        {
          x = stepper1.distanceToGo();
          stepper1.stop();
          stepper1.setCurrentPosition(0);
          v = v + x;
          stepper1.move(v);
          v = 0;
          x = 0;
          break;
        }
      else {
      stepper1.setCurrentPosition(0);
      stepper1.move(v);
      v = 0;
      break;
      }
      
      v = 0;
      break;
      
    case 'b' : 
      if ( v  == 8 ) {
      stepper2.setCurrentPosition(0);
      stepper2.move(v);
      v = 0;
      break;
      }  
      else if (stepper2.distanceToGo() != 0)
        {
          x = stepper2.distanceToGo();
          stepper2.stop();
          stepper2.setCurrentPosition(0);
          v = v + x;
          stepper2.move(v);
          v = 0;
          x = 0;
          break;
        } else {
      stepper2.setCurrentPosition(0); 
      stepper2.move(v); 
      v = 0;
      break;
      }
      v = 0;
      break;

    case 'c' : 
      if ( v  == 8 ) {
      stepper3.setCurrentPosition(0);
      stepper3.move(v);
      v = 0;
      break;
      }  
      else if (stepper3.distanceToGo() != 0)
        {
          x = stepper3.distanceToGo();
          stepper3.stop();
          stepper3.setCurrentPosition(0);
          v = v + x;
          stepper3.move(v);
          v = 0;
          x = 0;
          break;
        } else {
      stepper3.setCurrentPosition(0); 
      stepper3.move(v); 
      v = 0;
      break;
      }
      v = 0;
      break;

    case 'd' : 
      if ( v  == 8 ) {
      stepper4.setCurrentPosition(0);
      stepper4.move(v);
      v = 0;
      break;
      }  
      else if (stepper4.distanceToGo() != 0)
        {
          x = stepper4.distanceToGo();
          stepper4.stop();
          stepper4.setCurrentPosition(0);
          v = v + x;
          stepper4.move(v);
          v = 0;
          x = 0;
          break;
        } else {
      stepper4.setCurrentPosition(0); 
      stepper4.move(v); 
      v = 0;
      break;
      }
      v = 0;
      break;

    case 'e' : 
      if ( v  == 8 ) {
      stepper5.setCurrentPosition(0);
      stepper5.move(v);
      v = 0;
      break;
      }  
      else if (stepper5.distanceToGo() != 0)
        {
          x = stepper5.distanceToGo();
          stepper5.stop();
          stepper5.setCurrentPosition(0);
          v = v + x;
          stepper5.move(v);
          v = 0;
          x = 0;
          break;
        } else {
      stepper5.setCurrentPosition(0); 
      stepper5.move(v); 
      v = 0;
      break;
      }
      v = 0;
      break;

    case 'f' : 
      if ( v  == 8 ) {
      stepper6.setCurrentPosition(0);
      stepper6.move(v);
      v = 0;
      break;
      }  
      else if (stepper6.distanceToGo() != 0)
        {
          x = stepper6.distanceToGo();
          stepper6.stop();
          stepper6.setCurrentPosition(0);
          v = v + x;
          stepper6.move(v);
          v = 0;
          x = 0;
          break;
        } else {
      stepper6.setCurrentPosition(0); 
      stepper6.move(v); 
      v = 0;
      break;
      }
      v = 0;
      break;

    case 'g' : 
      if ( v  == 8 ) {
      stepper7.setCurrentPosition(0);
      stepper7.move(v);
      v = 0;
      break;
      }  
      else if (stepper7.distanceToGo() != 0)
        {
          x = stepper7.distanceToGo();
          stepper7.stop();
          stepper7.setCurrentPosition(0);
          v = v + x;
          stepper7.move(v);
          v = 0;
          x = 0;
          break;
        } else {
      stepper7.setCurrentPosition(0); 
      stepper7.move(v); 
      v = 0;
      break;
      }
      v = 0;
      break;

    case 'h' : 
      if ( v  == 8 ) {
      stepper8.setCurrentPosition(0);
      stepper8.move(v);
      v = 0;
      break;
      }  
      else if (stepper8.distanceToGo() != 0)
        {
          x = stepper8.distanceToGo();
          stepper8.stop();
          stepper8.setCurrentPosition(0);
          v = v + x;
          stepper8.move(v);
          v = 0;
          x = 0;
          break;
        } else {
      stepper8.setCurrentPosition(0); 
      stepper8.move(v); 
      v = 0;
      break;
      }
      v = 0;
      break;

    case 'i' : 
      if ( v  == 8 ) {
      stepper9.setCurrentPosition(0);
      stepper9.move(v);
      v = 0;
      break;
      }  
      else if (stepper9.distanceToGo() != 0)
        {
          x = stepper9.distanceToGo();
          stepper9.stop();
          stepper9.setCurrentPosition(0);
          v = v + x;
          stepper9.move(v);
          v = 0;
          x = 0;
          break;
        } else {
      stepper9.setCurrentPosition(0); 
      stepper9.move(v); 
      v = 0;
      break;
      }
      v = 0;
      break;

    case 'j' : 
      if ( v  == 8 ) {
      stepper10.setCurrentPosition(0);
      stepper10.move(v);
      v = 0;
      break;
      }  
      else if (stepper10.distanceToGo() != 0)
        {
          x = stepper10.distanceToGo();
          stepper10.stop();
          stepper10.setCurrentPosition(0);
          v = v + x;
          stepper10.move(v);
          v = 0;
          x = 0;
          break;
        } else {
      stepper10.setCurrentPosition(0); 
      stepper10.move(v); 
      v = 0;
      break;
      }
      v = 0;
      break;

    case 'k' : 
      if ( v  == 8 ) {
      stepper11.setCurrentPosition(0);
      stepper11.move(v);
      v = 0;
      break;
      }  
      else if (stepper11.distanceToGo() != 0)
        {
          x = stepper11.distanceToGo();
          stepper11.stop();
          stepper11.setCurrentPosition(0);
          v = v + x;
          stepper11.move(v);
          v = 0;
          x = 0;
          break;
        } else {
      stepper11.setCurrentPosition(0); 
      stepper11.move(v); 
      v = 0;
      break;
      }
      v = 0;
      break;

    case 'l' : 
      if ( v  == 8 ) {
      stepper12.setCurrentPosition(0);
      stepper12.move(v);
      v = 0;
      break;
      }  
      else if (stepper12.distanceToGo() != 0)
        {
          x = stepper12.distanceToGo();
          stepper12.stop();
          stepper12.setCurrentPosition(0);
          v = v + x;
          stepper12.move(v);
          v = 0;
          x = 0;
          break;
        } else {
      stepper12.setCurrentPosition(0); 
      stepper12.move(v); 
      v = 0;
      break;
      }
      v = 0;
      break;

    case 'm' : 
      if ( v  == 8 ) {
      stepper13.setCurrentPosition(0);
      stepper13.move(v);
      v = 0;
      break;
      }  
      else if (stepper13.distanceToGo() != 0)
        {
          x = stepper13.distanceToGo();
          stepper13.stop();
          stepper13.setCurrentPosition(0);
          v = v + x;
          stepper13.move(v);
          v = 0;
          x = 0;
          break;
        } else {
      stepper13.setCurrentPosition(0); 
      stepper13.move(v); 
      v = 0;
      break;
      }
      v = 0;
      break;

    case 'n' : 
      if ( v  == 8 ) {
      stepper14.setCurrentPosition(0);
      stepper14.move(v);
      v = 0;
      break;
      }  
      else if (stepper14.distanceToGo() != 0)
        {
          x = stepper14.distanceToGo();
          stepper14.stop();
          stepper14.setCurrentPosition(0);
          v = v + x;
          stepper14.move(v);
          v = 0;
          x = 0;
          break;
        } else {
      stepper14.setCurrentPosition(0); 
      stepper14.move(v); 
      v = 0;
      break;
      }
      v = 0;
      break;

    case 'o' : 
      if ( v  == 8 ) {
      stepper15.setCurrentPosition(0);
      stepper15.move(v);
      v = 0;
      break;
      }  
      else if (stepper15.distanceToGo() != 0)
        {
          x = stepper15.distanceToGo();
          stepper15.stop();
          stepper15.setCurrentPosition(0);
          v = v + x;
          stepper15.move(v);
          v = 0;
          x = 0;
          break;
        } else {
      stepper15.setCurrentPosition(0); 
      stepper15.move(v); 
      v = 0;
      break;
      }
      v = 0;
      break;

    case 'p' : 
      if ( v  == 8 ) {
      stepper16.setCurrentPosition(0);
      stepper16.move(v);
      v = 0;
      break;
      }  
      else if (stepper16.distanceToGo() != 0)
        {
          x = stepper16.distanceToGo();
          stepper16.stop();
          stepper16.setCurrentPosition(0);
          v = v + x;
          stepper16.move(v);
          v = 0;
          x = 0;
          break;
        } else {
      stepper16.setCurrentPosition(0); 
      stepper16.move(v); 
      v = 0;
      break;
      }
      v = 0;
      break;

    case 'q' : 
      if ( v  == 8 ) {
      stepper17.setCurrentPosition(0);
      stepper17.move(v);
      v = 0;
      break;
      }  
      else if (stepper17.distanceToGo() != 0)
        {
          x = stepper17.distanceToGo();
          stepper17.stop();
          stepper17.setCurrentPosition(0);
          v = v + x;
          stepper17.move(v);
          v = 0;
          x = 0;
          break;
        } else {
      stepper17.setCurrentPosition(0); 
      stepper17.move(v); 
      v = 0;
      break;
      }
      v = 0;
      break;

    case 'r' : 
      if ( v  == 8 ) {
      stepper18.setCurrentPosition(0);
      stepper18.move(v);
      v = 0;
      break;
      }  
      else if (stepper18.distanceToGo() != 0)
        {
          x = stepper18.distanceToGo();
          stepper18.stop();
          stepper18.setCurrentPosition(0);
          v = v + x;
          stepper18.move(v);
          v = 0;
          x = 0;
          break;
        } else {
      stepper18.setCurrentPosition(0); 
      stepper18.move(v); 
      v = 0;
      break;
      }
      v = 0;
      break;

    case 's' : 
      if ( v  == 8 ) {
      stepper19.setCurrentPosition(0);
      stepper19.move(v);
      v = 0;
      break;
      }  
      else if (stepper19.distanceToGo() != 0)
        {
          x = stepper19.distanceToGo();
          stepper19.stop();
          stepper19.setCurrentPosition(0);
          v = v + x;
          stepper19.move(v);
          v = 0;
          x = 0;
          break;
        } else {
      stepper19.setCurrentPosition(0); 
      stepper19.move(v); 
      v = 0;
      break;
      }
      v = 0;
      break;

    case 't' : 
      if ( v  == 8 ) {
      stepper20.setCurrentPosition(0);
      stepper20.move(v);
      v = 0;
      break;
      }  
      else if (stepper20.distanceToGo() != 0)
        {
          x = stepper20.distanceToGo();
          stepper20.stop();
          stepper20.setCurrentPosition(0);
          v = v + x;
          stepper20.move(v);
          v = 0;
          x = 0;
          break;
        } else {
      stepper20.setCurrentPosition(0); 
      stepper20.move(v); 
      v = 0;
      break;
      }
      v = 0;
      break;

      //set stepper variation (Experimental)
    case '+' :  //setMaxSpeed
      stepper1.setMaxSpeed(v);         stepper2.setMaxSpeed(v);         stepper3.setMaxSpeed(v);   
      stepper4.setMaxSpeed(v);         stepper5.setMaxSpeed(v);         stepper6.setMaxSpeed(v);   
      stepper7.setMaxSpeed(v);         stepper8.setMaxSpeed(v);         stepper9.setMaxSpeed(v);   
      stepper10.setMaxSpeed(v);         stepper11.setMaxSpeed(v);         stepper12.setMaxSpeed(v);   
      stepper13.setMaxSpeed(v);         stepper14.setMaxSpeed(v);         stepper15.setMaxSpeed(v);   
      stepper16.setMaxSpeed(v);         stepper17.setMaxSpeed(v);         stepper18.setMaxSpeed(v);   
      stepper19.setMaxSpeed(v);         stepper20.setMaxSpeed(v);         
      v = 0; 
      break;

    case '=' : //setSpeed
      stepper1.setSpeed(v);       stepper2.setSpeed(v);       stepper3.setSpeed(v); 
      stepper4.setSpeed(v);       stepper5.setSpeed(v);       stepper6.setSpeed(v); 
      stepper7.setSpeed(v);       stepper8.setSpeed(v);       stepper9.setSpeed(v); 
      stepper10.setSpeed(v);       stepper11.setSpeed(v);       stepper12.setSpeed(v); 
      stepper13.setSpeed(v);       stepper14.setSpeed(v);       stepper15.setSpeed(v); 
      stepper16.setSpeed(v);       stepper17.setSpeed(v);       stepper18.setSpeed(v); 
      stepper19.setSpeed(v);       stepper20.setSpeed(v);       
      v = 0; 
      break;

    case '/' : //setAcceleration
      stepper1.setAcceleration(v);       stepper2.setAcceleration(v);       stepper3.setAcceleration(v); 
      stepper4.setAcceleration(v);       stepper5.setAcceleration(v);       stepper6.setAcceleration(v); 
      stepper7.setAcceleration(v);       stepper8.setAcceleration(v);       stepper9.setAcceleration(v); 
      stepper10.setAcceleration(v);       stepper11.setAcceleration(v);       stepper12.setAcceleration(v); 
      stepper13.setAcceleration(v);       stepper14.setAcceleration(v);       stepper15.setAcceleration(v); 
      stepper16.setAcceleration(v);       stepper17.setAcceleration(v);       stepper18.setAcceleration(v); 
      stepper19.setAcceleration(v);       stepper20.setAcceleration(v);       
      v = 0; 
      break;

    case 'Z' : // Allgemeine Kontroll
      if (v == 0) {
        digitalWrite(stromPin, LOW);   
        v = 0; 
      } // Stron_Aus
      else if (v == 1) {
        digitalWrite(stromPin, HIGH);    
        v = 0;
      } // Strom_Ein
      else if (v == 2) {
        digitalWrite(ms, LOW); 
        v =0; // 1/8 mikrostepping
      }
      else if (v ==3) {
        digitalWrite(ms, HIGH); 
        v = 0; // 1/16 mikrostepping (default)
      }
      else { 
      }
      v = 0; 
      break;
 
    case 'A' : // jede Stepper Kontroll
      if (v == 0) {
        digitalWrite(enA,HIGH); 
        v = 0; // v = 0 ostio!
      } // OFF
      else if (v == 1) {
        digitalWrite(enA,LOW); 
        v = 0;
      } // ON
      else if (v == 4) 
      {
        Serial.print("a"); 
        Serial.println(digitalRead(sigA));
        v = 0;
        break;
      }
      else {
        stepper1.setMaxSpeed(v);   
      }
      v = 0; break;

          
     case 'B' : 
      if (v == 0) {
        digitalWrite(enB,HIGH); 
        v = 0;
      } // OFF
      else if (v == 1) {
        digitalWrite(enB,LOW); 
        v = 0;
      } // ON
      else if (v == 4) 
      {
        Serial.print("b");
        Serial.println(digitalRead(sigB)); 
        v = 0;
        break;
      }
      else {
        stepper2.setMaxSpeed(v);
      }
      v = 0;       break;

    case 'C' : 
      if (v == 0) {
        digitalWrite(enC,HIGH); 
        v = 0;
      } // OFF
      else if (v == 1) {
        digitalWrite(enC,LOW); 
        v = 0;
      } // ON
      else if (v == 4) 
      {
        Serial.print("c");
        Serial.println(digitalRead(sigC)); 
        v = 0;
        break;
      }
      else {
        stepper3.setMaxSpeed(v);
      }
      v = 0;       break;  

    case 'D' : 
      if (v == 0) {
        digitalWrite(enD,HIGH); 
        v = 0;
      } // OFF
      else if (v == 1) {
        digitalWrite(enD,LOW); 
        v = 0;
      } // ON
      else if (v == 4) 
      {
        Serial.print("d"); 
        Serial.println(digitalRead(sigD)); 
        v = 0;
        break;
      }
      else {
        stepper4.setMaxSpeed(v);
      }
      v = 0;       break;  

    case 'E' : 
      if (v == 0) {
        digitalWrite(enE,HIGH); 
        v = 0;
      } // OFF
      else if (v == 1) {
        digitalWrite(enE,LOW); 
        v = 0;
      } // ON
      else if (v == 4) 
      {
        Serial.print("e"); 
        Serial.println(digitalRead(sigE)); 
        v = 0;
        break;
      }
      else { 
        stepper5.setMaxSpeed(v);
      }
      v = 0;       break;  

    case 'F' : 
      if (v == 0) {
        digitalWrite(enF,HIGH); 
        v = 0;
      } // OFF
      else if (v == 1) {
        digitalWrite(enF,LOW); 
        v = 0;
      } // ON
      else if (v == 4) 
      {
        Serial.print("f"); 
        Serial.println(digitalRead(sigF)); 
        v = 0;
        break;
      }
      else { 
        stepper6.setMaxSpeed(v);
      }
      v = 0;       break;  

    case 'G' : 
      if (v == 0) {
        digitalWrite(enG,HIGH); 
        v = 0;
      } // OFF
      else if (v == 1) {
        digitalWrite(enG,LOW); 
        v = 0;
      } // ON
      else if (v == 4) 
      {
        Serial.print("g"); 
        Serial.println(digitalRead(sigG)); 
        v = 0;
        break;
      }
      else { 
        stepper7.setMaxSpeed(v);
      }
      v = 0;       break;  

    case 'H' : 
      if (v == 0) {
        digitalWrite(enH,HIGH); 
        v = 0;
      } // OFF
      else if (v == 1) {
        digitalWrite(enH,LOW); 
        v = 0;
      } // ON
      else if (v == 4) 
      {
        Serial.print("h"); 
        Serial.println(digitalRead(sigH)); 
        v = 0;
        break;
      }
      else { 
        stepper8.setMaxSpeed(v);
      }
      v = 0;       break;  

    case 'I' : 
      if (v == 0) {
        digitalWrite(enI,HIGH); 
        v = 0;
      } // OFF
      else if (v == 1) {
        digitalWrite(enI,LOW); 
        v = 0;
      } // ON
      else if (v == 4) 
      {
        Serial.print("i"); 
        Serial.println(digitalRead(sigI)); 
        v = 0;
        break;
      }
      else { 
        stepper9.setMaxSpeed(v);
      }
      v = 0;       break;  

    case 'J' : 
      if (v == 0) {
        digitalWrite(enJ,HIGH); 
        v = 0;
      } // OFF
      else if (v == 1) {
        digitalWrite(enJ,LOW); 
        v = 0;
      }
            else if (v == 4) 
      {
        Serial.print("j"); 
        Serial.println(digitalRead(sigJ)); 
        v = 0;
        break;
      }
      else { 
        stepper10.setMaxSpeed(v);
      }
      v = 0;       break;  

    case 'K' : 
      if (v == 0) {
        digitalWrite(enK,HIGH); 
        v = 0;
      } // OFF
      else if (v == 1) {
        digitalWrite(enK,LOW); 
        v = 0;
      } // ON
      else if (v == 4) 
      {
        Serial.print("k"); 
        Serial.println(digitalRead(sigK)); 
        v = 0;
        break;
      }
      else { 
        stepper11.setMaxSpeed(v);
      }
      v = 0;       break;  

    case 'L' : 
      if (v == 0) {
        digitalWrite(enL,HIGH); 
        v = 0;
      } // OFF
      else if (v == 1) {
        digitalWrite(enL,LOW); 
        v = 0;
      } // ON
      else if (v == 4) 
      {
        Serial.print("l"); 
        Serial.println(digitalRead(sigL)); 
        v = 0;
        break;
      }
      else { 
        stepper12.setMaxSpeed(v);
      }
      v = 0;       break;  

    case 'M' : 
      if (v == 0) {
        digitalWrite(enM,HIGH); 
        v = 0;
      } // OFF
      else if (v == 1) {
        digitalWrite(enM,LOW); 
        v = 0;
      } // ON
      else if (v == 4) 
      {
        Serial.print("m"); 
        Serial.println(digitalRead(sigM)); 
        v = 0;
        break;
      }
      else { 
        stepper13.setMaxSpeed(v);
      }
      v = 0;       break;  

    case 'N' : 
      if (v == 0) {
        digitalWrite(enN,HIGH); 
        v = 0;
      } // OFF
      else if (v == 1) {
        digitalWrite(enN,LOW); 
        v = 0;
      } // ON
      else if (v == 4) 
      {
        Serial.print("n"); 
        Serial.println(digitalRead(sigN)); 
        v = 0;
        break;
      }
      else { 
        stepper14.setMaxSpeed(v);
      }
      v = 0;       break;  

    case 'O' : 
      if (v == 0) {
        digitalWrite(enO,HIGH); 
        v = 0;
      } // OFF
      else if (v == 1) {
        digitalWrite(enO,LOW); 
        v = 0;
      } // ON
      else if (v == 4) 
      {
        Serial.print("o"); 
        Serial.println(digitalRead(sigO)); 
        v = 0;
        break;
      }
      else { 
        stepper15.setMaxSpeed(v);
      }
      v = 0;       break;  

    case 'P' : 
      if (v == 0) {
        digitalWrite(enP,HIGH); 
        v = 0;
      } // OFF
      else if (v == 1) {
        digitalWrite(enP,LOW); 
        v = 0;
      } // ON
      else if (v == 4) 
      {
        Serial.print("p"); 
        Serial.println(digitalRead(sigP)); 
        v = 0;
        break;
      }
      else { 
        stepper16.setMaxSpeed(v);
      }
      v = 0;       break;  

    case 'Q' : 
      if (v == 0) {
        digitalWrite(enQ,HIGH); 
        v = 0;
      } // OFF
      else if (v == 1) {
        digitalWrite(enQ,LOW); 
        v = 0;
      } // ON
      else if (v == 4) 
      {
        Serial.print("q"); 
        Serial.println(digitalRead(sigQ)); 
        v = 0;
        break;
      }
      else { 
        stepper17.setMaxSpeed(v);
      }
      v = 0;       break;  

    case 'R' : 
      if (v == 0) {
        digitalWrite(enR,HIGH); 
        v = 0;
      } // OFF
      else if (v == 1) {
        digitalWrite(enR,LOW); 
        v = 0;
      } // ON
      else if (v == 4) 
      {
        Serial.print("r"); 
        Serial.println(digitalRead(sigR)); 
        v = 0;
        break;
      }
      else { 
        stepper18.setMaxSpeed(v);
      }
      v = 0;       break;  

    case 'S' : 
      if (v == 0) {
        digitalWrite(enS,HIGH); 
        v = 0;
      } // OFF
      else if (v == 1) {
        digitalWrite(enS,LOW); 
        v = 0;
      } // ON
      else if (v == 4) 
      {
        Serial.print("s"); 
        Serial.println(digitalRead(sigS)); 
        v = 0;
        break;
      }
      else { 
        stepper19.setMaxSpeed(v);
      }
      v = 0;       break;  

    case 'T' : 
      if (v == 0) {
        digitalWrite(enT,HIGH); 
        v = 0;
      } // OFF
      else if (v == 1) {
        digitalWrite(enT,LOW); 
        v = 0;
      } // ON
      else if (v == 4) 
      {
        Serial.print("t"); 
        Serial.println(digitalRead(sigT)); 
        v = 0;
        break;
      }
      else { 
        stepper20.setMaxSpeed(v);
      }
      v = 0;       break;  

      //aceelvar !@#$%^&*()-_[]|:;",.
      //(bis 20)      
    
    case '!' : // accelVar kontrol fur 1A
      stepper1.setAcceleration(v);
      v = 0;      break;
    case '@' : // 2B
      stepper2.setAcceleration(v);
      v = 0;      break;
    case '#' : // 3C
      stepper3.setAcceleration(v);
      v = 0;      break;
    case '$' : // 4D
      stepper4.setAcceleration(v);
      v = 0;      break;
    case '%' : // 5E
      stepper5.setAcceleration(v);
      v = 0;      break;
    case '^' : // 6F
      stepper6.setAcceleration(v);
      v = 0;      break;
    case '&' : // 7G
      stepper7.setAcceleration(v);
      v = 0;      break;
    case '*' : // 8H
      stepper8.setAcceleration(v);
      v = 0;      break;
    case '(' : // 9I
      stepper9.setAcceleration(v);
      v = 0;      break;
    case ')' : // 10J
      stepper10.setAcceleration(v);
      v = 0;      break;
    case '-' : // 11K
      stepper11.setAcceleration(v);
      v = 0;      break;
    case '_' : // 12L
      stepper12.setAcceleration(v);
      v = 0;      break;
    case '[' : // 13M
      stepper13.setAcceleration(v);
      v = 0;      break;
    case ']' : // 14N
      stepper14.setAcceleration(v);
      v = 0;      break;
    case '|' : // 15O
      stepper15.setAcceleration(v);
      v = 0;      break;
    case ':' : // 16P
      stepper16.setAcceleration(v);
      v = 0;      break;
    case ';' : // 17Q
      stepper17.setAcceleration(v);
      v = 0;      break;
    case '"' : // 18R
      stepper18.setAcceleration(v);
      v = 0;      break;
    case ',' : // 19S
      stepper19.setAcceleration(v);
      v = 0;      break;
    case '.' : // 20T
      stepper20.setAcceleration(v);
      v = 0;      break;
    
        } //von switch 

  } //von if


} //von loop




