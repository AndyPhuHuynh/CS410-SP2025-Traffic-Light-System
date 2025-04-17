#pragma once

#include <cstdint>

#include "Timer.h"

enum class State {
    ConstantGreen,
    GreenToRed,
    ConstantRed,
};

class TrafficLight {
    uint8_t greenPin;
    uint8_t yellowPin;
    uint8_t redPin;

    State currentState;

    Timer greenTimer = Timer(2000);
    Timer yellowTimer = Timer(1000);
    Timer redTimer = Timer(2000);
public:
    TrafficLight(uint8_t green, uint8_t yellow, uint8_t red, State state);
  
    void setupPins();
  
    void setGreenLight(uint8_t mode);
    void setYellowLight(uint8_t mode);
    void setRedLight(uint8_t mode);
  
    void setOnlyGreen();
    void setOnlyYellow();
    void setOnlyRed();

    void setState(State state);

    void startState(State state);

    void startConstantGreen();
    void startGreenToRed();
    void startConstantRed();

    // Must be called at the beginning of the loop
    void update();

    void updateConstantGreen();
    void updateGreenToRed();
    void updateConstantRed();
};

class Sensor {
    uint8_t inputPin;
public:
    Sensor(uint8_t input);
    void setupPins();
    uint8_t read();
};

