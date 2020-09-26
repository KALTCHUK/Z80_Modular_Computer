void setup() {
  pinMode(2,INPUT_PULLUP);
  pinMode(3,INPUT_PULLUP);
  pinMode(4,INPUT_PULLUP);
  pinMode(5,INPUT_PULLUP);
  
  if (digitalRead(2) == LOW)    tone(13, 2400);
  if (digitalRead(3) == LOW)    tone(13, 4800);
  if (digitalRead(4) == LOW)    tone(13, 9600);
  if (digitalRead(5) == LOW)    tone(13,19200);
}

void loop() {

}
