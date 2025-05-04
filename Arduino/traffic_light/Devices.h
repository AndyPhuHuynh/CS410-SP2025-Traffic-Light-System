#pragma once

#include <cstdint>
#include <string>

#include "Timer.h"

enum class State {
    AllOff,
    ConstantGreen,
    GreenToRed,
    ConstantRed,
};

constexpr int greenToRed_GreenTime = 5000;
constexpr int greenToRed_YellowTime = 3000;
constexpr int greenToRed_TransitionTime = greenToRed_GreenTime + greenToRed_YellowTime;

class TrafficLight {
    uint8_t greenPin;
    uint8_t yellowPin;
    uint8_t redPin;

    bool m_isRed;
    bool m_isYellow;
    bool m_isGreen;

    State currentState;

    Timer greenTimer = Timer(greenToRed_GreenTime);
    Timer yellowTimer = Timer(greenToRed_YellowTime);
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

    std::string getJson();

    bool isGreen() {
        return m_isGreen;
    }

    bool isYellow() {
        return m_isYellow;
    }

    bool isRed() {
        return m_isRed;
    }
};

class Sensor {
    uint8_t inputPin;
public:
    Sensor(uint8_t input);
    void setupPins();
    uint8_t read();
};

