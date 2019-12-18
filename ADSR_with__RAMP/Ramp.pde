class Ramp {
  
  float rampValue;    // current ramp value -> che useremo per modulare i parametri grafici
  float rampStartMillis; // constructor init millisecond
  float rampDuration; // ramp duration in ms
  boolean run; // ramp trigger state
  int range; // -1 to 1 ( full ramp ) or 0 to 1 ( half ramp)
  int stepId; //0 -> attack, 1-> decay, 2 -> release
  String stepName;
  
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
      if(stepId==0) {
        stepName = "Attack";
      }
      else if(stepId==1) {
        stepName = "Decay";
      }
      else if (stepId ==2) {
        stepName = "Release";
      }
      text("Seconds: " + (int)((millis() - startingTime)/1000) +"\nADSR Step:" +stepName , 1920/3, 1080/3);
    }   
    else {
      //println("a");
    }  
  }
  
}
    
