#include <ESP32Servo.h>
#include <Keypad.h>
#include <LiquidCrystal_I2C.h>

#include <HTTPClient.h>
#include <Arduino_JSON.h>

// constants
#define API "https://iot-door-lock-system.onrender.com/"

#define c1 16
#define c2 4
#define c3 0
#define c4 2
#define r1 19
#define r2 18
#define r3 5
#define r4 17
#define ServoPin 23
#define BuzzerPin 22
#define LedPin 15
// #define SDA 33 21
// #define SCL 32 22
#define TRIG 16
#define ECHO 17
const byte ROWS = 4;
const byte COLS = 4;

enum Mode {
  STATE,
  LOCK,
  PIN,
  DFLT
};

Mode mode;

// variables
char keys[ROWS][COLS] = {
  {'1', '2', '3', 'A'},
  {'4', '5', '6', 'B'},
  {'7', '8', '9', 'C'},
  {'*', '0', '#', 'D'},
};
byte RowPins[ROWS] = {r1, r2, r3, r4};
byte ColPins[COLS] = {c1, c2, c3, c4};
String password = "2134";
String InputPin;
String FalseInput;
int AdjCol = 6;
int ScreenDelay = 5000;
long duration;
float distance;
float prev_dist;
bool displayCondition = true;

// instances
HTTPClient http;
Servo servo;
Keypad keypad = Keypad(makeKeymap(keys), RowPins, ColPins, ROWS, COLS);
LiquidCrystal_I2C lcd(0x27, 16, 2);

// Functions
void HomePage(){
  InputPin = "";
  lcd.clear();
  lcd.noBlink();
  lcd.setCursor(1, 0);
  lcd.print("Input Your Pin");
  lcd.setCursor(AdjCol, 1);
  lcd.blink();
}

void SuccessPage(){
  tone(BuzzerPin, 500, int(3*ScreenDelay/4));
  noTone(BuzzerPin);
  lcd.clear();
  lcd.noBlink();
  lcd.setCursor(4, 0);
  lcd.print("Unlocked");
  lcd.setCursor(2, 1);
  lcd.print("SuccessFully");
  HandleDoorLock();
  delay(ScreenDelay);
  servo.write(0);
  HomePage();
}

void ErrorPage(){
  lcd.clear();
  lcd.noBlink();
  lcd.setCursor(3, 0);
  lcd.print("Incorrect");
  lcd.setCursor(3, 1);
  lcd.print("Password!");
  delay(ScreenDelay);
  HomePage();
}

void WelcomePage(){
  String WelcomeMessage = "in";
  lcd.clear();
  lcd.noBlink();
  lcd.setCursor(4, 0);
  lcd.print("Welcome");
  delay(1000);
  lcd.setCursor(6, 1);
  lcd.blink();
  Serial.println("Running!");
  for(int i=0; i<WelcomeMessage.length(); i++){
    lcd.setCursor(6+i, 1);
    lcd.print(WelcomeMessage[i]);
    delay(250);
  }
  delay(2000);
  HomePage();
}

int getDist(){
  digitalWrite(TRIG, LOW);
  delayMicroseconds(2);

  digitalWrite(TRIG, HIGH);
  delayMicroseconds(10);
  digitalWrite(TRIG, LOW);

  duration = pulseIn(ECHO, HIGH);

  distance = (duration * 0.0343)/2;

  distance = (distance * 0.7) + (prev_dist * 0.3);
  prev_dist = distance;
  return distance;
}

void setup() {
  Serial.begin(115200);
  // Wire.begin(SDA, SCL);
  lcd.init();
  lcd.clear();
  lcd.backlight();
  servo.setPeriodHertz(50);
  servo.attach(ServoPin);
  pinMode(TRIG, OUTPUT);
  pinMode(ECHO, INPUT);
  pinMode(LedPin, OUTPUT);
  pinMode(BuzzerPin, OUTPUT);
  servo.write(0);
}

void BackSpace(){
  lcd.noBlink();
  int Amt = AdjCol - 7;
  String TempStr = InputPin;
  String Spacer;
  InputPin = "";
  for(int i=0; i<Amt; i++){
    InputPin += TempStr[i];
  }
  lcd.setCursor(6, 1);
  for(int a=0; a<=Amt; a++){
      Spacer += " ";
  }
  lcd.print(Spacer);
  lcd.setCursor(6, 1);
  lcd.print(InputPin);
  if (AdjCol > 6){
    AdjCol --;
  };
  lcd.blink();
}

void loop(){
  // getDist() <= 35
  if(displayCondition == displayCondition){
    lcd.cursor();
    lcd.backlight();
    lcd.blink();
    if(displayCondition == true){
      WelcomePage();
    }
    // runAlways();
    // displayCondition = false;
  }
  // }else{
  //   lcd.noCursor();
  //   lcd.noBacklight();
  //   lcd.noBlink();
  //   lcd.clear();
  //   displayCondition = true;
  // }
}

void runAlways() {
  char key = keypad.getKey();
  if (key) {
    BuzzerInput();
    if (key == '*'){
      AdjCol = 6;
      CheckPassword();
    }else if (key == '#'){
      BackSpace();
    }else{
      InputPin += String(key);
      HandleInput(key);
    };
  };
}

void HandleInput(char key){
  String _key_ = String(key);
  lcd.setCursor(AdjCol, 1);
  lcd.print("-");
  AdjCol++;
}

void BuzzerInput(){
  tone(BuzzerPin, 500, 10);
  noTone(BuzzerPin);
}

void HandleDoorLock(){
  for(int i=0; i<=90; i=i+5){
    servo.write(i);
    delay(250);
  }
}

void LedSequence(){
  for(int i=0; i<=10; i++){
  digitalWrite(LedPin, HIGH);
  delay(250);
  digitalWrite(LedPin, LOW);
  delay(250);
  }
}

void ErrorSequence(){
  for(int i=0; i<3; i++){
    digitalWrite(LedPin, HIGH);
    delay(800);
    digitalWrite(LedPin, LOW);
    delay(200);
  }
  for(int j=0; j<2; j++){
    digitalWrite(LedPin, HIGH);
    delay(200);
    digitalWrite(LedPin, LOW);
    delay(200);
  }
}

void CheckPassword(){
  lcd.noBlink();
  if (InputPin.length() == 4){
    if(InputPin == password){
      SuccessPage();
    } else {
      ErrorPage();
    };
  }else{
    ErrorPage();
  };
}
