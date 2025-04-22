#pragma once

#include <cstdint>

#include "Timer.h"

enum class State {
    AllOff,
    ConstantGreen,
    GreenToRed,
    ConstantRed,
};

constexpr int greenToRed_GreenTime = 2000;
constexpr int greenToRed_YellowTime = 1000;
constexpr int greenToRed_TransitionTime = greenToRed_GreenTime + greenToRed_YellowTime;

class TrafficLight {
    uint8_t greenPin;
    uint8_t yellowPin;
    uint8_t redPin;

    State currentState;

    Timer greenTimer = Timer(2000);
    Timer yellowTimer = Timer(1000);
    Timer redTimer = Timer(2000);
public:
    TrafficLight(uint8_t green, uint8_t yellow, uint8_t red);
    TrafficLight(uint8_t green, uint8_t yellow, uint8_t red, State state);
  
    void setupPins();
  
    void setGreenLight(uint8_t mode);
    void setYellowLight(uint8_t mode);
    void setRedLight(uint8_t mode);
  
    void setAllOff();
    void setOnlyGreen();
    void setOnlyYellow();
    void setOnlyRed();

    void setState(State state);

    void startState(State state);

    void startAllOff();
    void startConstantGreen();
    void startGreenToRed();
    void startConstantRed();

    // Must be called at the beginning of the loop
    void update();

    void updateAllOff();
    void updateConstantGreen();
    void updateGreenToRed();
    void updateConstantRed();

    String getStateString() {
        if (this->isRed()) return "red";
        if (this->isYellow()) return "yellow";
        if (this->isGreen()) return "green";
        return "off";
    }

};

class Sensor {
    uint8_t inputPin;
public:
    Sensor(uint8_t input);
    void setupPins();
    uint8_t read();
};

