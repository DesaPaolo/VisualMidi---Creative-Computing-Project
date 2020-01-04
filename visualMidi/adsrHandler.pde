/*Antonino Code*/
/*When attack finishes this function is called and generates the decay ramp. It's also called when sustain finishes this*/
public void adsrInit() {
  
  times = new float[4];
  attackTimeMs = 1;
  decayTimeMs = 1000;
  releaseTimeMs = 1;
  times[0] = attackTimeMs;
  times[1] = decayTimeMs;
  times[2] = -1;
  times[3] = releaseTimeMs;
  
  EGTimes = new float[4];
  EGTimes[0] = attackTimeMs;
  EGTimes[1] = decayTimeMs;
  EGTimes[2] = -1;
  EGTimes[3] = releaseTimeMs;
  
}

private void nextRamp(Note note) {

  int step = note.ramp.stepId;
  switch(step){
    case 1:
      //println("REACHED DECAY");
      note.ramp = new Ramp(times[step], millis(), 0, step, note.adsrValues[0], note.adsrValues[1], note, false);
      break;
    case 2: 
      //println("REACHED SUSTAIN");
      break; 
    case 3:
      //println("REACHED Release");
      note.ramp = new Ramp(times[step], millis(), 0, step, note.adsrValues[1], 0, note, false);
      break;
  }
  
  if(step<4) {  
    startingTime = millis();
  }
  else if(step==4) {
    removeNote(note);
  } 
}

private void removeNote(Note note) {
    note.toRemove = true;
}

public void endedRamp(Note note, boolean filter) {
  if(!filter) {
    note.ramp.stepId++;
    nextRamp(note);    
  }
  else {
    note.filterRamp.stepId++;
    nextFilterRamp(note);
  }

}

public void startReleaseB(Note note) {
  /*crea la rampa di release per la nota*/  
}

private void nextFilterRamp(Note note) {

  int stepz = note.filterRamp.stepId;
  switch(stepz){
    case 1:
      println("FILTER REACHED DECAY");
      note.filterRamp = new Ramp(EGTimes[stepz], millis(), 0, stepz, note.filterAdsrValues[1], note.filterAdsrValues[2], note, true);
      break;
    case 2: 
      println("FILTER REACHED SUSTAIN");
      break; 
    case 3:
      println("FILTER REACHED Release");
      note.filterRamp = new Ramp(EGTimes[stepz], millis(), 0, stepz, note.filterAdsrValues[2], note.filterAdsrValues[3], note, true);
      break;
  }

  
}
/*End Antonino Code*/
