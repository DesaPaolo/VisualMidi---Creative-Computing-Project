void setup() {

  size(600,600, P3D);
  //fullScreen(P3D);
  background(0);

  MidiBus.list(); // List all our MIDI devices
  minilogue = new MidiBus(this, 1, 1);// Connect to one of the devices
  //instrumentType = 0;
  //sustainedNotes = new ArrayList <Note>();
  //prevNote = new Note(0, 0);
  
  adsrInit();

  //Ani.init(this); // Animation library init 
  
}

void draw() {
  
  //background
  fill(cutOffFilter);
  rect(0, 0, width, height);
  lights();
 
  //Chiama update della view per ogni nota. Da aggiungere differenza tra monofonia e polifonia e limite 
  //massimo di voci a 4, per rispecchiare sempre l'audio output del minilogue.
  if (!tempNotes.isEmpty()) {
    for (int i=0; i<tempNotes.size(); i++ ) { 

      tempNotes.get(i).ramp.trigger();
      tempNotes.get(i).update();
     
    }
  }
  
}

private void removeNote(Note note) {
    note.toRemove = true;
}

/*Antonino Code*/
/*When attack finishes this function is called and generates the decay ramp. It's also called when sustain finishes this*/
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
      note.ramp = new Ramp(EGTimes[stepz], millis(), 0, stepz, note.filterAdsrValues[0], note.filterAdsrValues[1], note, false);
      break;
    case 2: 
      println("FILTER REACHED SUSTAIN");
      break; 
    case 3:
      println("FILTER REACHED Release");
      note.ramp = new Ramp(EGTimes[stepz], millis(), 0, stepz, note.filterAdsrValues[1], note.filterAdsrValues[2], note, false);
      break;
  }

  
}


/*End Antonino Code*/
