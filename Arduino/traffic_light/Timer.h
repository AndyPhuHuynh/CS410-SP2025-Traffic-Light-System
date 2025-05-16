// Class to represent a timer that counts down
class Timer {
    // The duration the timer counts down from in milliseconds
    unsigned long m_timerDuration = 0;
    // The previous time in milliseconds since the start of the program that the timer was last ticked 
    unsigned long m_prevTimeMilli = 0;
    // The current time the timer is at in milliseconds
    unsigned long m_timerMilli = 0;
    // If the timer is currently active or not
    bool m_countingDown = false;
public:
    // Constructor that sets the duration
    Timer(unsigned long durationMilli);
  
    // Must be called at the beginning of the loop function before an timer logic
    void update();  
    
    // Returns true if the timer has finished counting down
    bool countDownEnded();
  
    // Starts timer's countdown if it is paused
    void start();

    // Sets the current time the timer is at back to the starting duration
    void resetCountDown();
  
    // Gets the current time that's passed since the timer has started in milliseconds
    unsigned long getTimeMilli();

    // Gets the current time that's passed since the timer has started in seconds, counting down from the starting duration
    double getTimeSeconds();

    // Gets the current time that's passed sicne ethe timer has started in seconds, counting up from zero
    double getSecondsSinceStart();
};