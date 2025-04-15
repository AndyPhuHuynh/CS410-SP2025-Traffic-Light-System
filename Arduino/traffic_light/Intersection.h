#include "Devices.h"

enum class IntersectionState {
    Light1Green,
    Light2Green,
    SwitchLight1ToGreen,
    SwitchLight2ToGreen,
};

class Intersection {
    TrafficLight m_light1;
    TrafficLight m_light2;

    Sensor m_pirSensor1;
    Sensor m_pirSensor2;

    IntersectionState m_currentState = IntersectionState::Light1Green;    

    Timer timer1 = Timer(greenToRed_TransitionTime);
public:
    Intersection(TrafficLight light1, TrafficLight light2, Sensor pirSensor1, Sensor pirSensor2);
    
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
};