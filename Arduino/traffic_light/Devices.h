#pragma once

#include <cstdint>
#include <string>

#include "Timer.h"

// The four possible states that a traffic light can be in
enum class State {
    AllOff,
    ConstantGreen,
    GreenToRed,
    ConstantRed,
};

// Amount of time in milliseconds the light stays green during the transition state
constexpr int greenToRed_GreenTime = 5000; 
// Amount of time in milliseconds the light stays yellow during the transition state
constexpr int greenToRed_YellowTime = 3000;
// Total time in milliseconds for the light to transition from green to red
constexpr int greenToRed_TransitionTime = greenToRed_GreenTime + greenToRed_YellowTime;

// Traffic Light class. This class represents one traffic light module.
// Must be created in setup or loop, not global space.
class TrafficLight {
    // Pin numbers on the esp32 that each led is connected to
    uint8_t greenPin;
    uint8_t yellowPin;
    uint8_t redPin;

    // Booleans to represent when each respective light is on
    bool m_isRed;
    bool m_isYellow;
    bool m_isGreen;

    // The current state of the traffic light
    State currentState;

    // Timer for transition between light colors
    Timer greenTimer = Timer(greenToRed_GreenTime);
    Timer yellowTimer = Timer(greenToRed_YellowTime);
    Timer redTimer = Timer(2000);
public:
    // Constructor that sets each pin and sets the default state to all off
    TrafficLight(uint8_t green, uint8_t yellow, uint8_t red);
    // Constructor that sets each pin and the initial state
    TrafficLight(uint8_t green, uint8_t yellow, uint8_t red, State state);
  
    // Setup each of the led pins to be in output mode
    void setupPins();
  
    // Sets each respective pin to either HIGH or LOW mode
    void setGreenLight(uint8_t mode);
    void setYellowLight(uint8_t mode);
    void setRedLight(uint8_t mode);
  
    // Sets the state of the traffic light to its respective state
    void setAllOff();
    void setOnlyGreen();
    void setOnlyYellow();
    void setOnlyRed();

    // Sets the state of the traffic light to the given state
    void setState(State state);

    // Called at the start of whenever a state is set
    void startState(State state);

    // The respective start functionality of each state
    void startAllOff();
    void startConstantGreen();
    void startGreenToRed();
    void startConstantRed();

    // Must be called at the beginning of the loop. 
    void update();

    // The respective update functionality of each state
    void updateAllOff();
    void updateConstantGreen();
    void updateGreenToRed();
    void updateConstantRed();

    // Gets the traffic ilght's current state into JSON format
    std::string getJson();

    // Returns the respective value of each boolean
    bool isGreen();
    bool isYellow();
    bool isRed();
};

// Traffic Light class. This class represents a sensor that has one input pin
class Sensor {
    // The pin number of the input pin on the esp32
    uint8_t inputPin;
public:
    // Creates a sensor with the given pin
    Sensor(uint8_t input);
    // Sets the pin to input mode
    void setupPins();
    // Wrapper function to read the current state of the pin
    uint8_t read();
};

