/**
This class generates a series of values that belongs to a linear ramp.
It is used to implement graphically the ADSR envelopes
*/
public class Ramp {

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
  /**
  Class constructor
  */
  Ramp () { 
    rampDuration = 0;
    rampStartMillis = 0; 
    run = false;
    //rampValue = 0;
    range = 0;
    stepId =-1;
  } 
  /**
  Class constructor
  @param duration duration of the ramp
  @param startTime starting time
  @param rampRange sets the ramp range of values
  @param stepId set the step id for the ramp, it is different for an attack ramp, a decay or release one
  @param startValue starting value
  @param endValue end value of the ramp
  @param Note note associated to the ramp
  @param filter if true is a filter cutoff ramp, else an amplitude one
  */
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
  /**
  Called each frame. Changes linearly the value of the ramp
  */
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
      textSize(32);
      if (stepId==0) {
        stepName = "Attack";
      } else if (stepId==1) {
        stepName = "Decay";
      } else if (stepId ==2) {
        stepName = "Sustain";
      } else if (stepId ==3) {
        stepName = "Release";
      }
      //text("Seconds: " + (int)((millis() - startingTime)/1000) +"\nADSR Step:" +stepName , 1920/3, 1080/3);
    } else {
    }
  }
  /**
  Check wheter it is necessary to start the release of the note
  */
  public void startRelease() {
    //endedRamp(/*"inizia release"*/1, note);
    /*chiama funzione startRelease(Note note)*/
    stepId = 2;
    endedRamp(note, this.filter);
  }
}
