
#define SERVO 4

void setup() {
  // put your setup code here, to run once:
  // ledcAttach(0, uint32_t freq, uint8_t resolution)
  // ledcWriteTone(SERVO, 2000);
  pinMode(SERVO, OUTPUT);
  Serial.begin(115200);
}

void loop() {
  // put your main code here, to run repeatedly:
  digitalWrite(SERVO, HIGH);
  Serial.println("Doing something here!!");
  delay(1000);
  digitalWrite(SERVO, LOW);
  // delay(1000);
  // ledcWriteTone(SERVO, 2000);
}
