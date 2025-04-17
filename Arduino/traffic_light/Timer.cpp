#include <Timer.h> 
 
#include <Arduino.h>

Timer::Timer(unsigned long durationMilli) {
        m_prevTimeMilli = millis();
        m_timerDuration = durationMilli;
    }

void Timer::update() {
    if (m_countingDown) {
        unsigned long currentTime = millis();
        unsigned long deltaTMilli = currentTime - m_prevTimeMilli;
        m_prevTimeMilli = currentTime;
        m_timerMilli += deltaTMilli;
    }

    if (m_timerMilli >= m_timerDuration) {
        m_countingDown = false;
    }
}


bool Timer::countDownEnded() {
    return m_timerMilli >= m_timerDuration;
}

void Timer::start() {
    m_prevTimeMilli = millis();
    m_countingDown = true;
}

void Timer::resetCountDown() {
    m_timerMilli = 0;
}

unsigned long Timer::getTimeMilli() {
    return m_timerMilli;
}

double Timer::getTimeSeconds() {
    return static_cast<double>(m_timerMilli) / 1000;
}