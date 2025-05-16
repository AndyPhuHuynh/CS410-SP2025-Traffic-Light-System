class Timer {
    unsigned long m_timerDuration = 0;
    unsigned long m_prevTimeMilli = 0;
    unsigned long m_timerMilli = 0;
    bool m_countingDown = false;
  public:
    Timer(unsigned long durationMilli);
  
    // Must be called at the beginning of the loop function before an timer logic
    void update();  
    
    bool countDownEnded();
  
    void start();
  
    void resetCountDown();
  
    unsigned long getTimeMilli();

    double getTimeSeconds();

    double getSecondsSinceStart() {
      return (m_timerDuration / 1000) - getTimeSeconds();
    }
  };