#include <WiFi.h>
#include <WiFiMulti.h>
#include <WiFiClientSecure.h>
#include <Arduino_JSON.h>
#include <Preferences.h>
#include <ESP32Servo.h>
#include <Keypad.h>
#include <LiquidCrystal_I2C.h>

// Configuration
#define SSID_PRIMARY "Dubem's Phone"
#define PSWD_PRIMARY "password7"
#define SSID_SECONDARY "THATDUBEMGUY"
#define PSWD_SECONDARY "thatdubemguy."
// #define HOST "iot-door-lock-system.onrender.com"
#define HOST "dubemchukwu.pythonanywhere.com"
#define PORT 443
#define LED_PIN 2
#define HASH "6f9d9614b195f255e7bb3744b92f9486713d9b7eb92edba244bc0f11907ae7c5"
#define TRIG 16
#define ECHO 17
#define SERVO 23
#define R1 13
#define R2 12
#define R3 14
#define R4 27
#define C1 26
#define C2 25
#define C3 33
#define C4 32
#define ROWS 4
#define COLS 4
#define BUZZ 4

// Important Constants
#define STATE_CHECK_INTERVAL 79
#define LOCK_CHECK_INTERVAL 410
#define PIN_CHECK_INTERVAL 631
#define WIFI_CHECK_INTERVAL 10000
#define DOOR_OPEN_INTERVAL 5000

// Connection timeouts
#define HTTP_TIMEOUT 750
#define WIFI_CONNECT_TIMEOUT 10000
#define WEB_SERVO_THRESHOLD 10000

// System state
struct {
  bool state = false;
  bool prevState = false;
  bool lock = false;
  bool prevLock = false;
  String pin = "2134";
  int LoadCtrl = 0;
  unsigned long LoadTime = millis();
  unsigned long CheckDelay = millis();
  unsigned long PageDelay = millis();
  unsigned long WebLockDelay = millis();
  bool CheckPassword = false;
  bool WatchingAPI = false;
  bool PageBool = false;
} sys;

// Timing
unsigned long tState = 0;
unsigned long tLock = 0;
unsigned long tPin = 0;
unsigned long tWifi = 0;

// LED controller
struct {
  bool active = false;
  unsigned long start = 0;
  uint16_t interval = 0;
} led;

// Servo Controller
enum ServoPosition {ZERO, HALF, FULL};
struct _SERVO_ {
  bool state = false;
  uint16_t interval = 0;
  ServoPosition position = ZERO;
};

_SERVO_ _servo_;
_SERVO_ WebServo;

// variables
char keys[ROWS][COLS] = {
  {'1', '2', '3', 'A'},
  {'4', '5', '6', 'B'},
  {'7', '8', '9', 'C'},
  {'*', '0', '#', 'D'},
};

byte RowPins[ROWS] = {R1, R2, R3, R4};
byte ColPins[COLS] = {C1, C2, C3, C4};
const int PIN_CURSOR_COL = 6;
String InputPin = "";
enum Page { WELCOME, HOME, RUNNING, HALT, UNLOCKED, LOCKED, DISABLE, HOLD_DISABLED, HOLD_PROCESSING, HOLD_STATUS, PROCESSING};
Page currentPage = WELCOME;
enum WPage { once, other};
WPage StatPage = other;
enum Actions {STATE, LOCK, PIN};
Actions actions = STATE;
unsigned long lastUpdate = 0;
int animFrame = 0;
long duration;
float distance;
float prev_dist;
unsigned long pastTime; 
int distance_, xDistance;
int AdjCol = 6;
int ScreenDelay = 5000;

// Global objects
Preferences prefs;
WiFiMulti wifiMulti;
Servo servo;
Keypad keypad = Keypad(makeKeymap(keys), RowPins, ColPins, ROWS, COLS);
LiquidCrystal_I2C lcd(0x27, 16, 2);
TaskHandle_t APICore;

// Function declarations
void connectWifi();
bool isWifiConnected();
void blinkLed(uint16_t duration);
void updateLed();
void updateServo();
bool apiGet(const char* endpoint, JSONVar& response);
void checkState();
void checkLock();
void checkPin();
void BackSpace();
void HomePage();
int getDist();
void WelcomePage();
void ErrorPage();
void SuccessPage();
void printCentered();
void HandleInput();
bool CheckPassword(String Password);
void PageTemplate(String FirstText, String SecondText);
void WiFiEvent(WiFiEvent_t event);

void setup() {
  Serial.begin(115200);
  pinMode(LED_PIN, OUTPUT);
  pinMode(TRIG, OUTPUT);
  pinMode(ECHO, INPUT);
  pinMode(BUZZ, OUTPUT);
  lcd.init();
  lcd.clear();
  lcd.backlight();
  servo.setPeriodHertz(50);
  servo.attach(SERVO, 500, 2400);
  servo.write(0);

  digitalWrite(LED_PIN, LOW);
  // Load saved state
  prefs.begin("DLIS", false);
  sys.pin = prefs.getString("pin", "2134");
  sys.lock = prefs.getBool("lock", false);
  sys.prevLock = sys.lock;
  
  Serial.println("\n[INIT] Door Lock System v1.0");
  Serial.printf("[INIT] Lock: %s\n", sys.lock ? "LOCKED" : "UNLOCKED");
  PageTemplate("System","Starting up");

  Serial.print("[CORE] MANUAL running on core ");
  Serial.print(xPortGetCoreID());
  Serial.println(" ...");

  WiFi.onEvent(WiFiEvent);
  connectWifi();
  xTaskCreatePinnedToCore(
    RunApiTask,
    "APICore",
    10000,
    NULL,
    1,
    &APICore,
    0);
  sys.CheckDelay = millis();
}

void loop() {
  unsigned long now = millis();
  // Non blocking functions
  updateLed();
  updateServoAuto();
  updateServoMan();
  
  // Check WiFi periodically
  if (now - tWifi >= WIFI_CHECK_INTERVAL) {
    tWifi = now;
    if (!isWifiConnected()) {
      Serial.println("[WIFI] Wifi - Not Connected");
      switch(StatPage){
        case once:
          WifiPage();
          // connectWifi();
          StatPage = other;
          currentPage = HOME;
          break;
        case other:
          currentPage = HOME;
          Serial.println("[UI] display home page");
          break;
      }
    }
  }

  // Skip API calls if WiFi down
  if (wifiMulti.run() != WL_CONNECTED) return;

  // Serial.println("[UI] lcd displaying the needed content");
  switch (currentPage) {
    case WELCOME:
      pastTime = millis();
      WelcomePage();
      if(millis() - sys.CheckDelay > 250){
        sys.CheckDelay = millis();
        currentPage = HOME;
      }
      break;
      
    case HOME:
      HomePage();
      currentPage = RUNNING;
      InputPin = "";
      Serial.println("[MANUAL] Ready for PIN input");
      break;
      
    case RUNNING:
      if (Serial.available()) {
        String key = Serial.readString();
        InputPin = key;
        lcd.print("****"); // Show asterisk for security
        Serial.println(InputPin);

        sys.PageBool = true;
        sys.CheckDelay = millis();
        if(CheckPassword(key)){
          sys.CheckPassword = true;
        }else{
          sys.CheckPassword = false;
        }
        currentPage = PROCESSING;
      }
      break;
    
    case PROCESSING:
      currentPage = HOLD_PROCESSING;
      sys.CheckDelay = millis();
      showLoading();
      break;

    case HOLD_PROCESSING:
      if(millis() - sys.CheckDelay >= 1100){
        currentPage = HOLD_STATUS;
        if(sys.CheckPassword){
          sys.PageDelay = millis();
          SuccessPage();
        }else{
          ErrorPage();
        }
        sys.CheckDelay = millis();
      }
      break;

    case HOLD_STATUS:
      if(sys.CheckPassword){
        if(millis() - sys.CheckDelay > DOOR_OPEN_INTERVAL){
        InputPin = "";
        sys.CheckDelay = millis();
        currentPage = HOME;
      }
      }else{
        if(millis() - sys.CheckDelay > DOOR_OPEN_INTERVAL/4){
        InputPin = "";
        sys.CheckDelay = millis();
        currentPage = HOME;
      }
      }
      break;

    case UNLOCKED:
      WebStatusPage("UNLOCKED", true);
      sys.PageDelay = millis();
      sys.WebLockDelay = millis();
      currentPage = HALT;
      break;

    case LOCKED:
      WebStatusPage("LOCKED", false);
      sys.PageDelay = millis();
      currentPage = HALT;
      break;

    case DISABLE:
      PageTemplate("KEYPAD", "DISABLED");
      currentPage = HOLD_DISABLED;
      break;

    case HOLD_DISABLED:
      if(!sys.lock){
        currentPage = HOME;
      }
      break;
    
    case HALT:
      if(!sys.state){
        if(millis() - sys.PageDelay > 1000){
        currentPage = HOME;
        }
      }
      break;
  }

  Serial.flush();
  yield();
}

void WiFiEvent(WiFiEvent_t event){
  switch(event){
    case ARDUINO_EVENT_WIFI_STA_START:
      Serial.println("[WIFI] Station started");
      break;
      
    case ARDUINO_EVENT_WIFI_STA_CONNECTED:
      Serial.printf("\n[WIFI] Connected: %s\n", WiFi.SSID().c_str());
      break;

    case ARDUINO_EVENT_WIFI_STA_GOT_IP:
      Serial.printf("[WIFI] IP: %s | RSSI: %d dBm\n", 
                WiFi.localIP().toString().c_str(), WiFi.RSSI());
      break;

    case ARDUINO_EVENT_WIFI_STA_DISCONNECTED:
      // Serial.println("[WiFi] Disconnected.");
      Serial.println("[WIFI] Reconnecting...");
      connectWifi();
      break;

    default:
      break;
  }
}

void RunApiTask(void * pvParameters){
  Serial.print("[CORE] API running on core ");
  Serial.print(xPortGetCoreID());
  Serial.println(" ...");
  for(;;){
    unsigned long now = millis();
    // Stagger API calls for load distribution
    if (wifiMulti.run() != WL_CONNECTED) continue;
    
    switch (actions) {
      case STATE:
        // Serial.println("[STATE] Checking the state of the API!");
        actions = LOCK;
        if (now - tState >= STATE_CHECK_INTERVAL){
          checkState();
          tState = millis();
        }
        break;

      case LOCK:
        // Serial.println("[LOCK] Checking the lock state of the API!");
        actions = PIN;
        if (now - tLock >= LOCK_CHECK_INTERVAL){
          checkLock();
          tLock = millis();
        }
        break;

      case PIN:
        // Serial.println("[PIN] Checking the pin state of the API!");
        actions = STATE;
        if (now - tPin >= PIN_CHECK_INTERVAL) {
          checkPin();
          tPin = millis();
        }
        break;
    }
    yield();
  }
}

void printCentered(String text, int row) {
  int pos = (16 - text.length()) / 2;
  lcd.setCursor(pos, row);
  lcd.print(text);
}

void WifiPage(){
  lcd.clear();
  lcd.noBlink();
  printCentered("Wifi Not", 0);
  printCentered("Connected", 1);
}

void PageTemplate(String FirstText = "", String SecondText = ""){
  lcd.clear();
  lcd.noBlink();
  printCentered(FirstText, 0);
  printCentered(SecondText, 1);
}

void HomePage(){
  InputPin = "";
  lcd.clear();
  lcd.noBlink();
  lcd.setCursor(1, 0);
  lcd.print("Input Your Pin");
  lcd.setCursor(AdjCol, 1);
  lcd.blink();
}

void WebStatusPage(String message, bool state){
  tone(BUZZ, 500, int(3*ScreenDelay/4));
  noTone(BUZZ);
  lcd.clear();
  lcd.noBlink();
  printCentered("Door", 0);
  printCentered(message, 1);
  WebServo.state = state;
  if (state) sys.WebLockDelay = millis();
}

void SuccessPage(){
  tone(BUZZ, 500, int(ScreenDelay));
  noTone(BUZZ);
  lcd.clear();
  lcd.noBlink();
  lcd.setCursor(4, 0);
  lcd.print("Unlocked");
  lcd.setCursor(2, 1);
  lcd.print("SuccessFully");
  // HandleDoorLock();
  // delay(ScreenDelay);
  // servo.write(180);
  _servo_.state = true;
  _servo_.interval = DOOR_OPEN_INTERVAL/2;
}

void updateServoMan(){
  if(WebServo.state){
    if(WebServo.position == FULL) return;
    for(int i=0; i<=180; i+=2){
    servo.write(i);
    delay(int((2/180)*(WebServo.interval/2)));
    };
    servo.write(180);
    Serial.println("[ACTION] servo is from 0 -> 180");
    WebServo.position = FULL;
  }else{
    if(WebServo.position == ZERO) return;
    for(int i=180; i>=0; i-=2){
      servo.write(i);
      delay(int((2/180)*(WebServo.interval/2)));
    };
    servo.write(0);
    Serial.println("[ACTION] servo is from 180 -> 0");
    WebServo.position = ZERO;
  };
  if(millis() - sys.WebLockDelay> WEB_SERVO_THRESHOLD){
    WebServo.state = false;
    currentPage = HOME;
  }
}

void updateServoAuto(){
  if(_servo_.state){
    if(millis() - sys.PageDelay > DOOR_OPEN_INTERVAL/2){
      _servo_.state = !_servo_.state;
    }
    if(_servo_.position == FULL) return;
    for(int i=0; i<=180; i+=2){
    servo.write(i);
    delay(int((2/180)*(_servo_.interval/2)));
    };
    servo.write(180);
    Serial.println("[ACTION] servo is from 0 -> 180");
    _servo_.position = FULL;
  }else{
    if(_servo_.position == ZERO) return;
    for(int i=180; i>=0; i-=2){
      servo.write(i);
      delay(int((2/180)*(_servo_.interval/2)));
    };
    servo.write(0);
    Serial.println("[ACTION] servo is from 180 -> 0");
    _servo_.position = ZERO;
  };

  // if(sys.PageBool && millis() - sys.PageDelay > DOOR_OPEN_INTERVAL){
  //   sys.PageBool = false;
  //   currentPage = HOME;
  // }
}

void ErrorPage(){
  lcd.clear();
  lcd.noBlink();
  lcd.setCursor(3, 0);
  lcd.print("Incorrect");
  lcd.setCursor(3, 1);
  lcd.print("Password!");
  // delay(ScreenDelay);
}

void slideText(String text, int row, int finalPos, int delayMs = 50) {
  int startPos = 16;
  for (int pos = startPos; pos >= finalPos; pos--) {
    lcd.setCursor(0, row);
    lcd.print("                "); // Clear row
    lcd.setCursor(pos, row);
    lcd.print(text);
    delay(delayMs);
  }
}

void WelcomePage(){
  lcd.clear();
  lcd.noCursor();
  lcd.noBlink();
  printCentered("Welcome", 0);
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

void HandleInput(char key){
  String _key_ = String(key);
  lcd.setCursor(AdjCol, 1);
  lcd.print("-");
  AdjCol++;
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

bool CheckPassword(String Password){
  lcd.noBlink();
  if(Password.length() == 4){
    showLoading();
    if(Password == sys.pin){
      return true;
    }else{
      return false;
    }
  }else{
    return false;
  }
}

void showLoading() {
  lcd.clear();
  lcd.noBlink();
  printCentered("Processing", 0);
  
  char loadChars[] = {'|', '/', '-', '\\'};
  for (int i = 0; i < 12; i++) {
    lcd.setCursor(7, 1);
    lcd.print(loadChars[i % 4]);
    delay(170);
  }
}

void connectWifi() {
  if (wifiMulti.run() == WL_CONNECTED) {
    return;
  }
  
  Serial.print("[WIFI] Connecting");
  WiFi.setHostname("DLIS");
  wifiMulti.addAP(SSID_PRIMARY, PSWD_PRIMARY);
  wifiMulti.addAP(SSID_SECONDARY, PSWD_SECONDARY);

  wifiMulti.run(WIFI_CONNECT_TIMEOUT/30, false);
  
  // unsigned long start = millis();
  // while (wifiMulti.run() != WL_CONNECTED) {
  //   if (millis() - start >= WIFI_CONNECT_TIMEOUT) {
  //     Serial.println("\n[WIFI] Timeout!");
  //     return;
  //   }
  //   StatPage = once;
  //   delay(250);
  //   Serial.print(".");
  // }
  Serial.println("...");
  
  // Serial.printf("\n[WIFI] Connected: %s\n", WiFi.SSID().c_str());
  // Serial.printf("[WIFI] IP: %s | RSSI: %d dBm\n", 
  //               WiFi.localIP().toString().c_str(), WiFi.RSSI());
}

bool isWifiConnected() {
  if (wifiMulti.run() == WL_CONNECTED){
    StatPage = other;
    return true;
  }
  StatPage = once;
  Serial.println("[WIFI] Disconnected!");
  return false;
}

void blinkLed(uint16_t duration) {
  led.active = true;
  led.start = millis();
  led.interval = duration;
  digitalWrite(LED_PIN, HIGH);
}

void updateLed() {
  if (led.active && (millis() - led.start >= led.interval)) {
    led.active = false;
    digitalWrite(LED_PIN, LOW);
  }
}

bool apiGet(const char* endpoint, JSONVar& payload) {
  if (wifiMulti.run() != WL_CONNECTED) return false;

  WiFiClientSecure *client = new WiFiClientSecure;
  if (!client) return false;
  
  client->setInsecure();
  
  // Connect with timeout
  if (!client->connect(HOST, PORT)) {
    if(!sys.WatchingAPI){
      Serial.printf("✓ Connecting to %s:%d\n", HOST, PORT);
      sys.WatchingAPI = !sys.WatchingAPI;
    }
    delete client;
    return false;
  }

  // Build request
  String req = String("GET ") + endpoint + " HTTP/1.1\r\n" +
               "Host: " + HOST + "\r\n" +
               "User-Agent: ESP32\r\n";
  
  if (strcmp(endpoint, "/DLIS/pin") == 0) {
    req += "key: " + String(HASH) + "\r\n";
  }
  
  req += "Connection: close\r\n\r\n";
  client->print(req);

  // Wait for response
  unsigned long timeout = millis();
  while (!client->available()) {
    if (millis() - timeout > HTTP_TIMEOUT) {
      client->stop();
      delete client;
      return false;
    }
    yield();
  }

  // Serial.println("[HTTPS] Reading response:");
  // Parse response
  String body = "";
  bool inBody = false;
  int statusCode = 0;
  
  while (client->available()) {
    String line = client->readStringUntil('\n');
    
    if (statusCode == 0 && line.startsWith("HTTP/")) {
      statusCode = line.substring(9, 12).toInt();
    }
    
    if (line == "\r" || line.isEmpty()) {
      inBody = true;
      continue;
    }
    
    if (inBody) body += line;
  }

  int jsonStart = body.indexOf('{');          
  int jsonEnd = body.lastIndexOf('}');
  String json;

  if (jsonStart != -1 && jsonEnd != -1) {
  json = body.substring(jsonStart, jsonEnd + 1);
  // Serial.println(json);
  } else {
    Serial.println("JSON not found in response");
  }

  client->stop();
  delete client;
  
  if (statusCode != 200){
    Serial.printf("[HTTPS] ❌ Status: %d\n", statusCode);
    return false;
  }
  payload = JSON.parse(json);
  sys.WatchingAPI = !sys.WatchingAPI;
  return JSON.typeof(payload) != "undefined";
}

void checkState() {
  JSONVar data;
  
  if (!apiGet("/DLIS/state", data)) return;
  
  if (data.hasOwnProperty("state")) {
    sys.state = (bool)data["state"];
    
    if (sys.state != sys.prevState) {
      Serial.printf("[STATE] %s\n", sys.state ? "ACTIVE" : "INACTIVE");
      
      if (sys.state) {
        currentPage = UNLOCKED;
      }else{
        currentPage = LOCKED;
      }
      
      sys.prevState = sys.state;
    }
  }
}

void checkLock() {
  JSONVar data;
  
  if (!apiGet("/DLIS/lock", data)) return;
  
  if (data.hasOwnProperty("lock")) {
    sys.lock = (bool)data["lock"];
    
    if (sys.lock != sys.prevLock) {
      Serial.printf("[LOCK] %s\n", sys.lock ? "LOCKED" : "UNLOCKED");
      
      if (sys.lock) {
        currentPage = DISABLE;
      }
      
      sys.prevLock = sys.lock;
      prefs.putBool("lock", sys.lock);
    }
  }
}

void checkPin() {
  JSONVar data;
  
  if (!apiGet("/DLIS/pin", data)) return;
  
  if (data.hasOwnProperty("pin")) {
    String newPin = String((const char*)data["pin"]);
    
    if (newPin.length() == 4 && newPin != sys.pin) {
      Serial.printf("[PIN] Updated: %s\n", newPin.c_str());      
      sys.pin = newPin;
      prefs.putString("pin", newPin);
    }
  }
}