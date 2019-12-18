class Ramp {
  
  float rampValue;    // current ramp value -> che useremo per modulare i parametri grafici
  float rampStartMillis; // constructor init millisecond
  float rampDuration; // ramp duration in ms
  boolean run; // ramp trigger state
  int range; // -1 to 1 ( full ramp ) or 0 to 1 ( half ramp)
  int stepId; //0 -> attack, 1-> decay, 2 -> release
  
  Ramp () { 
    rampDuration = 0;
    rampStartMillis = 0; 
    run = false;
    rampValue = 0;
    range = 0;
    stepId =-1;
  } 

  Ramp (float duration, float startTime, int rampRange, int stepId) {
    rampDuration = duration; // durata della rampa
    rampStartMillis = startTime; // tempo di inizio
    run = true; 
    range = rampRange;  
    this.stepId = stepId;
  }

  void trigger() {
    if (rampValue == 1) { 
      run = false;
      endedRamp();
    }
    if (run) {
      rampValue =  lerp(range,1, constrain((millis()-rampStartMillis)/rampDuration, 0, 1)); 
      textSize(32);
      text((millis() - startingTime)/1000 +"\n" +stepId , 50, 50);
    }   
    else {
      //println("a");
    }  
  }
  
}
    
