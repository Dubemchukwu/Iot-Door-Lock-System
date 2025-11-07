#include <Keypad.h>

const byte ROWS = 4;  //four rows
const byte COLS = 3;  //three columns

char keys[ROWS][COLS] = {
  { '1', '2', '3'},
  { '4', '5', '6'},
  { '7', '8', '9'},
  { '*', '0', '#'}
};

byte rowPins[ROWS] = { 13, 12, 14, 27};  //connect to the row pinouts of the keypad
byte colPins[COLS] = { 26, 25, 33};  //connect to the column pinouts of the keypad

//Create an object of keypad
Keypad keypad = Keypad(makeKeymap(keys), rowPins, colPins, ROWS, COLS);

void setup() {
  Serial.begin(115200);
}

void loop() {
  char key = keypad.getKey();  // Read the key

  // Print if key pressed
  if (key) {
    Serial.print("Key Pressed : ");
    Serial.println(key);
  }
}