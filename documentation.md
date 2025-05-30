# ESP32 Documentation

- [Devices.hpp](#deviceshpp)
  - [Enumerations](#enumerations)
  - [Constants](#constants)
  - [Class: TrafficLight](#class-trafficlight)
    - [Control Lights](#control-lights)
    - [Set States](#set-states)
    - [Start State Handlers](#start-state-handlers)
    - [Update State Handlers](#update-state-handlers)
    - [State JSON](#state-json)
    - [Light status](#light-status)
  - [Class: Sensor](#class-sensor)

- [Intersection.hpp](#intersectionhpp)
  - [Enumerations](#enumerations-1)
  - [Constants](#constants-1)
  - [Class: Intersection](#class-intersection)
    - [Start State Handlers](#start-state-handlers-1)
    - [Update State Handlers](#update-state-handlers-1)
    - [End State Handlers](#end-state-handlers)
    - [State JSON](#state-json-1)

- [Timer.hpp](#timerhpp)
  - [Class: Timer](#class-timer)


# Devices.hpp

## Enumerations

```enum class State```

Represents the state of the traffic light
- ```AllOff```          - All lights are off.
- ```ConstantGreen```   - Green light is constantly active
- ```GreenToRed```      - Transition from green to red with yellow in between
- ```ConstantRed```     - Red light is continuously on

## Constants

```int greenToRed_GreenTime``` - Duration in milliseconds the green light stays on during a transition.

```int greenToRed_YellowTime``` - Duration in milliseconds the yellow light stays on during a transition.

```int greenToRed_TransitionTime``` - Total duration for the green-to-red transition (greenToRed_GreenTime + greenToRed_YellowTime).

## Class: TrafficLight
A simple traffic light module

```TrafficLight(uint8_t green, uint8_t yellow, uint8_t red)``` - Constructs a traffic light with the given pin numbers in the default state of AllOff

```TrafficLight(uint8_t green, uint8_t yellow, uint8_t red, State state)``` - Constructs a traffic light with the given pin numbers and state

```void setupPins()``` - Configures the LED pins as output.

### Control Lights
---

```void setGreenLight(uint8_t mode);```

```void setYellowLight(uint8_t mode);```

```void setRedLight(uint8_t mode);```

Sets each light to HIGH or LOW

### Set States
---
```void setAllOff()```

```void setOnlyGreen()```

```void setOnlyYellow()```

```void setOnlyRed()```

Sets the state of the traffic light to its respective state

### Start State Handlers
---
```void startState(State state)```

```void startAllOff()```

```void startConstantGreen()```

```void startGreenToRed()```

```void startConstantRed()```

Performs any necessary initialization when changing to a new state.

### Update State Handlers
---
```void update()```

```void updateAllOff()```

```void updateConstantGreen()```

```void updateGreenToRed()```

```void updateConstantRed()```

Must be called in the loop function. Manages logic that happens every frame for each state. Handles state transitions and timing.

### State JSON
---
```std::string getJson()``` - Gets the JSON representation of the traffic light

### Light status
---
```bool isGreen()```

```bool isYellow()```

```bool isRed()```

Checks if a specific light is on or off

## Class: Sensor

```Sensor(uint8_t input)``` - Constructs a sensor with the given pin

```void setupPins()``` - Configures the given pin as an input

```uint8_t read()``` - Reads the current value of the pin (HIGH or LOW)




# Intersection.hpp 

## Enumerations

```enum class IntersectionState```

Represents the state of the traffic light
- ```Light1Green``` - Light 1 is green and light 2 is red

- ```Light2Green``` - Light 1 is red and light 2 is green

- ```SwitchLight1ToGreen``` Light 1 transitions to green green while light 2 transitions to red

- ```SwitchLight2ToGreen``` Light 2 transitions to green green while light 1 transitions to red

## Constants
```int SENSOR_COOLDOWN``` - The delay in milliseconds between when a sensor can cause the intersection to change state

## Class: Intersection
A cross intersection with two traffic lights

```c++
Intersection(TrafficLight light1, TrafficLight light2, 
             Sensor lineSensor1, Sensor lineSensor2 Sensor 
             pirSensor1, Sensor pirSensor2);
```
Constructs the intersection with the given lights and sensors

```void setState(IntersectionState state)``` - Sets the state of the intersection

### Start State Handlers
---
```void startState(IntersectionState state);```

```void startLight1Green();```

```void startLight2Green();```

```void startSwitchLight1ToGreen();```

```void startSwitchLight2ToGreen();```

Performs any necessary initialization when entering a new state.

### Update State Handlers
---
```void update();```

```void updateLight1Green()```

```void updateLight2Green()```

```void updateSwitchLight1ToGreen()```

```void updateSwitchLight2ToGreen()```

Must be called in the loop function. Manages logic that happens every frame for each state. Handles state transitions and timing.

### End State Handlers
---
```void endState(IntersectionState state);```

```void endLight1Green()```

```void endLight2Green()```

```void endSwitchLight1ToGreen()```

```void endSwitchLight2ToGreen()```

Performs any necessary initialization when transition out of a state

### State JSON
```std::string getLight1GreenJson()```

```std::string getLight2GreenJson()```

```std::string getSwitchLight1ToGreenJson()```

```std::string getSwitchLight2ToGreenJson()```

```std::string getStateJSON()```

Gets the JSON representation of each the intersection when for each state

# Timer.hpp

## Class: Timer
Represents a timer that counts down every frame

```Timer(unsigned long durationMilli)``` - Constructs a timer with its countdown time in milliseconds

```void update()``` - Must be called in the loop function to count the timer down

```bool countDownEnded()``` - Returns true if the timer has finished counting down

```void start()``` - Starts the countdown if the timer is paused

```void resetCountDown()``` - Resets the timer's internal countdown to the starting time

```unsigned long getTimeMilli()``` - Gets the current time that's passed since the timer has started in milliseconds

```double getTimeSeconds()``` - Gets the current time that's passed since the timer has started in seconds, counting down from the starting duration

```double getSecondsSinceStart()``` - Gets the current time that's passed sicne ethe timer has started in seconds, counting up from zero
