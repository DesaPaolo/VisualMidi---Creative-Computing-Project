class Ramp {
  
  float rampValue;    // current ramp value -> che useremo per modulare i parametri grafici
  float rampStartMillis; // constructor init millisecond
  float rampDuration; // ramp duration in ms
  boolean run; // ramp trigger state
  int range; // -1 to 1 ( full ramp ) or 0 to 1 ( half ramp)
  int stepId; //0 -> attack, 1-> decay, 2 -> release
  String stepName;
  float startValue;
  float endValue;
  Note note;
  
  boolean filter;
  
  Ramp () { 
    rampDuration = 0;
    rampStartMillis = 0; 
    run = false;
    //rampValue = 0;
    range = 0;
    stepId =-1;
  } 

  Ramp (float duration, float startTime, int rampRange, int stepId, float startValue, float endValue, Note note, boolean filter) {
    rampDuration = duration; // durata della rampa
    rampStartMillis = startTime; // tempo di inizio
    run = true; 
    range = rampRange;  
    this.stepId = stepId;
    this.startValue = startValue;
    this.endValue = endValue;
    this.rampValue = startValue;
    this.note = note;
    this.filter = filter;
    //println("startValue: " + startValue);
    //println("endValue: " + endValue);
  }

  void trigger() {
    //println("rampValue = " + (int)rampValue);
    //println("endValue = " + (int)endValue);
   // println("Step Id = " + stepId);
    if ((int)rampValue == (int)(endValue) && stepId!=2) { 
      run = false;
      endedRamp(this.note, this.filter);
    }
    if (run) {
      rampValue =  lerp(startValue, endValue, constrain((millis()-rampStartMillis)/rampDuration, 0, 1)); 
      //println("LERPAAAAAAAAAA " + rampValue +"\tfilter is"+filter);
      textSize(32);
      if(stepId==0) {
        stepName = "Attack";
      }
      else if(stepId==1) {
        stepName = "Decay";
      }
      else if (stepId ==2) {
        stepName = "Sustain";
      }
      else if (stepId ==3) {
        stepName = "Release";
      }
      //text("Seconds: " + (int)((millis() - startingTime)/1000) +"\nADSR Step:" +stepName , 1920/3, 1080/3);
    }   
    else {
      //println("a");
    }  
  }
  
  public void startRelease() {
   //endedRamp(/*"inizia release"*/1, note);
   /*chiama funzione startRelease(Note note)*/
   stepId = 2;
   susNotes.remove(this.note);
   endedRamp(note, this.filter);
  }  
}
    
