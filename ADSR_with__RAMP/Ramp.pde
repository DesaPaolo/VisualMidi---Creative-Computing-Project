class Ramp {
  float rampValue;    // current ramp value -> che useremo per modulare i parametri grafici
  float rampStartMillis; // constructor init millisecond
  float rampDuration; // ramp duration in ms
  boolean run; // ramp trigger state
  int range; // -1 to 1 ( full ramp ) or 0 to 1 ( half ramp)

  Ramp () { 
    rampDuration = 0;
    rampStartMillis = 0; 
    run = false;
    rampValue = 0;
    range = 0;
  } 

  Ramp (float duration, float startTime, int rampRange) {
    rampDuration = duration; // durata della rampa
    rampStartMillis = startTime; // tempo di inizio
    run = true; 
    range = rampRange;  
  }

  void trigger() {
    if (rampValue == 1) { 
      run = false; 
    }
    if (run) {
      rampValue =  lerp(range,1, constrain((millis()-rampStartMillis)/rampDuration, 0, 1)); 
      textSize(16);
      text((millis() - startingTime)/1000 , 100, 100);
    }   
  }   
  
  
}
    
