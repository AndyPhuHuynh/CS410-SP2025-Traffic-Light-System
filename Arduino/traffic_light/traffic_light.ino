uint8_t input_pin = 22;
uint8_t pir_pin = 19;
uint8_t green_pin = 18;
uint8_t yellow_pin = 4;
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

  void setOnlyGreen() {
    setGreenLight(HIGH);
    setYellowLight(LOW);
    setRedLight(LOW);
  }

  void setOnlyYellow() {
    setGreenLight(LOW);
    setYellowLight(HIGH);
    setRedLight(LOW);
  }

  void setOnlyRed() {
    setGreenLight(LOW);
    setYellowLight(LOW);
    setRedLight(HIGH);
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

class Timer {
  unsigned long m_timerDuration = 0;
  unsigned long m_prevTimeMilli = 0;
  unsigned long m_timerMilli = 0;
  bool m_countingDown = false;
public:
  Timer(unsigned long durationMilli) {
    m_prevTimeMilli = millis();
    m_timerDuration = durationMilli;
  }

  // Must be called at the beginning of the loop function before an timer logic
  void update() {
    Serial.println("countingdown\n");
    if (m_countingDown) {
      unsigned long deltaTMilli = millis() - m_prevTimeMilli;
      m_prevTimeMilli = millis();
      m_timerMilli += deltaTMilli;
    }
    if (m_timerMilli >= m_timerDuration) {
      m_countingDown = false;
    }
  }

  bool countDownEnded() {
    return m_timerMilli >= m_timerDuration;
  }

  void start() {
    m_prevTimeMilli = millis();
    m_countingDown = true;
  }

  void resetCountDown() {
    m_timerMilli = 0;
  }

  unsigned long getTimeMilli() {
    return m_timerMilli;
  }

  double getTimeSeconds() {
    return static_cast<double>(m_timerMilli) / 1000;
  }
};

Timer *greenTimer;
Timer *yellowTimer;
Timer *redTimer;

TrafficLight light(green_pin, yellow_pin, red_pin);
Sensor lineSensor(input_pin);
Sensor pirSensor(pir_pin);

void setup() {
  // put your setup code here, to run once:
  // pinMode(output_pin, OUTPUT);
  light.setupPins();
  lineSensor.setupPins();
  pirSensor.setupPins();

  greenTimer = new Timer(2000);
  yellowTimer = new Timer(1000);
  redTimer = new Timer(2000);
  
  greenTimer->start();
  light.setOnlyGreen();
  Serial.begin(9600);
}

void loop() {
  greenTimer->update();
  yellowTimer->update();
  redTimer->update();

  if (greenTimer->countDownEnded()) {
    Serial.println("greenEnd");
    light.setOnlyYellow();
    yellowTimer->start();
    greenTimer->resetCountDown();
  }

  if (yellowTimer->countDownEnded()) {
    Serial.println("yellowEnd");
    light.setOnlyRed();
    redTimer->start();
    yellowTimer->resetCountDown();
  }

  if (redTimer->countDownEnded()) {
    Serial.println("redEnd");
    light.setOnlyGreen();
    greenTimer->start();
    redTimer->resetCountDown();
  }
}
