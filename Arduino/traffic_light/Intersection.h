#include "Devices.h"

#include <Arduino.h>
#include <string>

enum class IntersectionState {
    Light1Green,
    Light2Green,
    SwitchLight1ToGreen,
    SwitchLight2ToGreen,
};

const int SENSOR_COOLDOWN = 5000;

class Intersection {
    TrafficLight m_light1;
    TrafficLight m_light2;

    Sensor m_lineSensor1;
    Sensor m_lineSensor2;

    Sensor m_pirSensor1;
    Sensor m_pirSensor2;

    IntersectionState m_currentState = IntersectionState::Light1Green;    

    Timer timer1 = Timer(greenToRed_TransitionTime);
    Timer m_sensorCooldown = Timer(SENSOR_COOLDOWN);
public:
    Intersection(TrafficLight light1, TrafficLight light2, 
                Sensor lineSensor1, Sensor lineSensor2,
                Sensor pirSensor1, Sensor pirSensor2);
    
    void setState(IntersectionState state);

    void startState(IntersectionState state);

    void startLight1Green();
    void startLight2Green();
    void startSwitchLight1ToGreen();
    void startSwitchLight2ToGreen();

    void update();

    void updateLight1Green();
    void updateLight2Green();
    void updateSwitchLight1ToGreen();
    void updateSwitchLight2ToGreen();

    void endState(IntersectionState state);

    void endLight1Green();
    void endLight2Green();
    void endSwitchLight1ToGreen();
    void endSwitchLight2ToGreen();

    std::string getLight1GreenJson() {
        return R"( 
            {
                "light1" : { "color" : "green", "timer" : -1},
                "light2" : { "color" : "red", "timer" : -1}
            }
        )";
    }

    std::string getLight2GreenJson() {
        return R"( 
            {
                "light1" : { "color" : "red", "timer" : -1},
                "light2" : { "color" : "green", "timer" : -1}
            }
        )";
    }

    std::string getSwitchLight1ToGreenJson() {
        if (!timer1.countDownEnded()) {
            std::string light1json = " {  \"color\":  \"red\", \"timer\": \"" + std::to_string(timer1.getSecondsSinceStart()) + "\"}";
            std::string light2json = m_light2.getJson();

            return "{ \"light1\":" + light1json + ", \"light2\":" + light2json + "}";
        } else {
            return getLight1GreenJson();
        }
    }

    std::string getSwitchLight2ToGreenJson() {
        if (!timer1.countDownEnded()) {
            std::string light1json = m_light1.getJson();
            std::string light2json = " {  \"color\":  \"red\", \"timer\": \"" + std::to_string(timer1.getSecondsSinceStart()) + "\"}";

            return "{ \"light1\":" + light1json + ", \"light2\":" + light2json + "}";
        } else {
            return getLight2GreenJson();
        }
    }

    // function to get get the colors of light 1 and light 2
    std::string getStateJSON() {
        switch(m_currentState) {
            case IntersectionState::Light1Green:
                return getLight1GreenJson();
            case IntersectionState::Light2Green:
                return getLight2GreenJson();
            case IntersectionState::SwitchLight1ToGreen:
                return getSwitchLight1ToGreenJson();
            case IntersectionState::SwitchLight2ToGreen:
                return getSwitchLight2ToGreenJson();
        }
    }
};
