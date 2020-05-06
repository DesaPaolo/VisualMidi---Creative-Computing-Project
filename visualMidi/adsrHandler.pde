/**
Initializes the ADSR values
*/
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

  ampSus = 100; 
  EGAmpSus = 100;
  cutOffFilter = 100;
  EGInt = 0;
}

/**
Creates a linear ramp for attack, decay and release (amplitude values)
@param note note of which to create the ramp
*/
private void nextRamp(Note note) {

  int step = note.ramp.stepId;
  switch(step) {
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

  if (step<4) {  
    startingTime = millis();
  } else if (step==4) {
    removeNote(note);
  }
}
/**
@param note note that can be removed from the playing notes
*/
private void removeNote(Note note) {
  note.toRemove = true;
}

/**
Starts the new ramp, that can be attack,, decay or release phase
@param note note of which to start the new ramp
@param filter if true generates a ficlter cutoff ramp, otherwise an amplitud eone
*/
public void endedRamp(Note note, boolean filter) {
  if (!filter) {
    note.ramp.stepId++;
    nextRamp(note);
  } else {
    note.filterRamp.stepId++;
    nextFilterRamp(note);
  }
}

public void startReleaseB(Note note) {
  /*crea la rampa di release per la nota*/
}

/**
Creates a linear ramp for attack, decay and release (filter cutoff values)
@param note note of which to create the ramp
*/
private void nextFilterRamp(Note note) {

  int stepz = note.filterRamp.stepId;
  switch(stepz) {
  case 1:
    //println("FILTER REACHED DECAY");
    note.filterRamp = new Ramp(EGTimes[stepz], millis(), 0, stepz, note.filterAdsrValues[1], note.filterAdsrValues[2], note, true);
    break;
  case 2: 
    //println("FILTER REACHED SUSTAIN");
    break; 
  case 3:
    //println("FILTER REACHED Release 2" + note.filterAdsrValues[2] +" 3" + note.filterAdsrValues[3]);
    note.filterRamp = new Ramp(EGTimes[stepz], millis(), 0, stepz, note.filterAdsrValues[2], note.filterAdsrValues[3], note, true);
    break;
  }
}