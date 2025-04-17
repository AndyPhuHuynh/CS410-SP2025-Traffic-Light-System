uint8_t input_pin = 22;
uint8_t pir_pin = 19;
uint8_t green_pin = 18;
uint8_t red_pin = 21;

class TrafficLight {
  uint8_t greenPin;
  uint8_t yellowPin;
  uint8_t redPin;
public:
  TrafficLight(uint8_t green, uint8_t yellow, uint8_t red) {
    greenPin = green;
    yellowPin = yellow;
    redPin = red;
  }

  void setupPins() {
    pinMode(greenPin, OUTPUT);
    pinMode(yellowPin, OUTPUT);
    pinMode(redPin, OUTPUT);
  }

  void setGreenLight(uint8_t mode) {
    digitalWrite(greenPin, mode);
  }

  void setYellowLight(uint8_t mode) {
    digitalWrite(yellowPin, mode);
  }

  void setRedLight(uint8_t mode) {
    digitalWrite(redPin, mode);
  }
};

class Sensor {
  uint8_t inputPin;
public:
  Sensor(uint8_t input) {
    inputPin = input;
  }

  void setupPins() {
    pinMode(inputPin, INPUT);
  }

  uint8_t read() {
    return digitalRead(inputPin);
  } 
};

TrafficLight light(green_pin, 0, red_pin);
Sensor lineSensor(input_pin);
Sensor pirSensor(pir_pin);

void setup() {
  // put your setup code here, to run once:
  // pinMode(output_pin, OUTPUT);
  light.setupPins();
  lineSensor.setupPins();
  pirSensor.setupPins();
  Serial.begin(9600);
}

void loop() {
  // put your main code here, to run repeatedly:
  light.setRedLight(lineSensor.read());
  light.setGreenLight(pirSensor.read());
  
  delay(100);
}
