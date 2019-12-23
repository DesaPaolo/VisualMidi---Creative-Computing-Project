
void setup() {

  size(1000,1000);
  //fullScreen();
  background(0);

  MidiBus.list(); // List all our MIDI devices
  minilogue = new MidiBus(this, 1, 1);// Connect to one of the devices
  instrumentType = 0;
  sustainedNotes = new ArrayList <Note>();
  prevNote = new Note(0, 0);

  Ani.init(this); // Animation library init 
  
  
}

void draw() {
  
  //background
  fill(0);
  rect(0, 0, width, height);

  //draw notes. Da aggiungere differenza tra monofonia e polifonia e limite 
  //massimo di voci a 4 per rispecchiare sempre l'audio output del minilogue
  if (!tempNotes.isEmpty()) {
    for (int i=0; i<tempNotes.size(); i++ ) { 
      tempNotes.get(i).update();
    }
  }

}
  





/*Antonino Code*/
/*When attack finishes this function is called and generates the decay ramp. It's also called when sustain finishes this*/
private void nextRamp() {
  
  switch(step){
    case 1: 
      ramp = new Ramp(times[step], millis(), 0, step, velValues[0], velValues[1]);
      break;
    case 2: 
      println("Step 2 AAAA");
      break; 
    case 3:
      ramp = new Ramp(times[step], millis(), 0, step, velValues[1], 0);
      break;
  }
  
  if(step<4) {  
    startingTime = millis();
  }
  
}

public void endedRamp() {
  step++;
  //step= %3;
  nextRamp();
}
/*End Antonino Code*/
