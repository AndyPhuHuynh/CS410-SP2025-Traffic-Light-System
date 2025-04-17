#include "Devices.h"

#include <Arduino.h>

// Must be created in setup or loop, not global space
TrafficLight::TrafficLight(uint8_t green, uint8_t yellow, uint8_t red, State state) {
    greenPin = green;
    yellowPin = yellow;
    redPin = red;
    currentState = state;

    setupPins();
    startState(currentState);
}

void TrafficLight::setupPins() {
    pinMode(greenPin, OUTPUT);
    pinMode(yellowPin, OUTPUT);
    pinMode(redPin, OUTPUT);
}

void TrafficLight::setGreenLight(uint8_t mode) {
    digitalWrite(greenPin, mode);
}

void TrafficLight::setYellowLight(uint8_t mode) {
    digitalWrite(yellowPin, mode);
}

void TrafficLight::setRedLight(uint8_t mode) {
    digitalWrite(redPin, mode);
}

void TrafficLight::setOnlyGreen() {
    setGreenLight(HIGH);
    setYellowLight(LOW);
    setRedLight(LOW);
}

void TrafficLight::setOnlyYellow() {
    setGreenLight(LOW);
    setYellowLight(HIGH);
    setRedLight(LOW);
}

void TrafficLight::setOnlyRed() {
    setGreenLight(LOW);
    setYellowLight(LOW);
    setRedLight(HIGH);
}

void TrafficLight::setState(State state) {
    currentState = state;
    startState(state);
}

void TrafficLight::startState(State state) {
    switch (state) {
        case State::ConstantGreen:
            startConstantGreen();
            break;
        case State::GreenToRed:
            startGreenToRed();
            break;
        case State::ConstantRed:
            startConstantRed();
            break;
    }
}

void TrafficLight::startConstantGreen() {
    setOnlyGreen();
}

void TrafficLight::startGreenToRed() {
    setOnlyGreen();

    greenTimer.resetCountDown();
    yellowTimer.resetCountDown();
    redTimer.resetCountDown();

    greenTimer.start();
}

void TrafficLight::startConstantRed() {
    setOnlyRed();
}

void TrafficLight::update() {
    switch (currentState) {
        case State::ConstantGreen:
            updateConstantGreen();
            break;
        case State::GreenToRed:
            updateGreenToRed();
            break;
        case State::ConstantRed:
            updateConstantRed();
            break;
    }
}

void TrafficLight::updateConstantGreen() {

}
  
void TrafficLight::updateGreenToRed() {
    greenTimer.update();
    yellowTimer.update();
    redTimer.update();

    if (greenTimer.countDownEnded()) {
        setOnlyYellow();
        yellowTimer.start();
        greenTimer.resetCountDown();
    }

    if (yellowTimer.countDownEnded()) {
        setOnlyRed();
        redTimer.start();
        yellowTimer.resetCountDown();
    }

    if (redTimer.countDownEnded()) {
        setOnlyGreen();
        greenTimer.start();
        redTimer.resetCountDown();
        setState(State::ConstantRed);
    }
}

void TrafficLight::updateConstantRed() {

}

Sensor::Sensor(uint8_t input) {
    inputPin = input;
    setupPins();
}
  
void Sensor::setupPins() {
    pinMode(inputPin, INPUT);
}

uint8_t Sensor::read() {
    return digitalRead(inputPin);
} 