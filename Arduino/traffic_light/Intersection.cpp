#include "Intersection.h"

#include <Arduino.h>

Intersection::Intersection(TrafficLight light1, TrafficLight light2, Sensor line1, Sensor line2, Sensor pirSensor1, Sensor pirSensor2) 
: m_light1(light1), m_light2(light2), m_lineSensor1(line1), m_lineSensor2(line2), m_pirSensor1(pirSensor1), m_pirSensor2(pirSensor2) {
    light1.setOnlyGreen();
    light2.setOnlyRed();
    setState(IntersectionState::Light1Green);
    m_sensorCooldown.start();
}

void Intersection::setState(IntersectionState state) {
    endState(m_currentState);
    m_currentState = state;
    startState(m_currentState);
}

void Intersection::startState(IntersectionState state) {
    switch (state) {
        case IntersectionState::Light1Green:
            startLight1Green();
            break;
        case IntersectionState::Light2Green:
            startLight2Green();
            break;
        case IntersectionState::SwitchLight1ToGreen:
            startSwitchLight1ToGreen();
            break;
        case IntersectionState::SwitchLight2ToGreen:
            startSwitchLight2ToGreen();
            break;
    }
}

void Intersection::startLight1Green() {
    Serial.println("1 Green");
    m_light1.setOnlyGreen();
    m_light2.setOnlyRed();
}

void Intersection::startLight2Green() {
    Serial.println("2 Green");
    m_light1.setOnlyRed();
    m_light2.setOnlyGreen();
}

void Intersection::startSwitchLight1ToGreen() {
    Serial.println("Switching to 1");
    m_light2.setState(State::GreenToRed);
    timer1.resetCountDown();
    timer1.start();
}

void Intersection::startSwitchLight2ToGreen() {
    Serial.println("Switching to 2");
    m_light1.setState(State::GreenToRed);
    timer1.resetCountDown();
    timer1.start();
}

void Intersection::update() {
    m_light1.update();
    m_light2.update();
    m_sensorCooldown.update();

    switch (m_currentState) {
        case IntersectionState::Light1Green:
            updateLight1Green();
            break;
        case IntersectionState::Light2Green:
            updateLight2Green();
            break;
        case IntersectionState::SwitchLight1ToGreen:
            updateSwitchLight1ToGreen();
            break;
        case IntersectionState::SwitchLight2ToGreen:
            updateSwitchLight2ToGreen();
            break;
    }
}

void Intersection::updateLight1Green() {
    if (m_lineSensor1.read() == HIGH && m_sensorCooldown.countDownEnded()) {
        setState(IntersectionState::SwitchLight2ToGreen);
    } else if (m_pirSensor2.read() == HIGH && m_sensorCooldown.countDownEnded()) {
        setState(IntersectionState::SwitchLight2ToGreen);
    }
}

void Intersection::updateLight2Green() {
    if (m_lineSensor2.read() == HIGH && m_sensorCooldown.countDownEnded()) {
        setState(IntersectionState::SwitchLight1ToGreen);
    } else if (m_pirSensor1.read() == HIGH && m_sensorCooldown.countDownEnded()) {
        setState(IntersectionState::SwitchLight1ToGreen);
    }
}

void Intersection::updateSwitchLight1ToGreen() {
    timer1.update();
    if (timer1.countDownEnded()) {
        setState(IntersectionState::Light1Green);
    }
}

void Intersection::updateSwitchLight2ToGreen() {
    timer1.update();
    if (timer1.countDownEnded()) {
        setState(IntersectionState::Light2Green);
    }
}

void Intersection::endState(IntersectionState state) {
    switch (state) {
        case IntersectionState::Light1Green:
            endLight1Green();
            break;
        case IntersectionState::Light2Green:
            endLight2Green();
            break;
        case IntersectionState::SwitchLight1ToGreen:
            endSwitchLight1ToGreen();
            break;
        case IntersectionState::SwitchLight2ToGreen:
            endSwitchLight2ToGreen();
            break;
    }
}

void Intersection::endLight1Green() {

}

void Intersection::endLight2Green() {

}

void Intersection::endSwitchLight1ToGreen() {
    m_sensorCooldown.resetCountDown();
    m_sensorCooldown.start();
}

void Intersection::endSwitchLight2ToGreen() {
    m_sensorCooldown.resetCountDown();
    m_sensorCooldown.start();
}

