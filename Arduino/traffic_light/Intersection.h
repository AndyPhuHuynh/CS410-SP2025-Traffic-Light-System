#include "Devices.h"

#include <Arduino.h>
#include <string>

// All possible states that the intersection can be in
enum class IntersectionState {
    Light1Green,
    Light2Green,
    SwitchLight1ToGreen,
    SwitchLight2ToGreen,
};

// Cooldown time between when sensors can change the state of the intersection
const int SENSOR_COOLDOWN = 5000;

// Intersection class. Represents a cross intersection between two one way roads.
class Intersection {
    // Both traffic lights
    TrafficLight m_light1;
    TrafficLight m_light2;

    // Line sensors for each light
    Sensor m_lineSensor1;
    Sensor m_lineSensor2;

    // Motion sensors for each light
    Sensor m_pirSensor1;
    Sensor m_pirSensor2;

    // The current state for the intersection
    IntersectionState m_currentState = IntersectionState::Light1Green;    

    // Timer for transition between green and red
    Timer timer1 = Timer(greenToRed_TransitionTime);
    // Sensor for the cooldown period
    Timer m_sensorCooldown = Timer(SENSOR_COOLDOWN);
public:
    // Constructor that sets up all the lights and sensors
    Intersection(TrafficLight light1, TrafficLight light2, 
                Sensor lineSensor1, Sensor lineSensor2,
                Sensor pirSensor1, Sensor pirSensor2);
    
    // Sets the current state of the intersections
    void setState(IntersectionState state);

    // Called at the start of whenever a state is set
    void startState(IntersectionState state);

    // The respective start functionality of each state
    void startLight1Green();
    void startLight2Green();
    void startSwitchLight1ToGreen();
    void startSwitchLight2ToGreen();

    // Must be called at the beginning of the loop. 
    void update();

    // The respective update functionality of each state
    void updateLight1Green();
    void updateLight2Green();
    void updateSwitchLight1ToGreen();
    void updateSwitchLight2ToGreen();

    // Called at for the current state before its changed
    void endState(IntersectionState state);

    // The respective end functionality of each state
    void endLight1Green();
    void endLight2Green();
    void endSwitchLight1ToGreen();
    void endSwitchLight2ToGreen();

    // The respective functions to get the JSON representation of the intersection in each state
    std::string getLight1GreenJson();
    std::string getLight2GreenJson();
    std::string getSwitchLight1ToGreenJson();
    std::string getSwitchLight2ToGreenJson();

    // Function to get the JSON state of the intersection
    std::string getStateJSON();
};
