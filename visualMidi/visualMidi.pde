
void setup() {

  //size(600, 600);
  fullScreen();
  background(0);

  MidiBus.list(); // List all our MIDI devices
  //loopMIDI = new MidiBus(this, 0, 1);// Connect to one of the devices
  minilogue = new MidiBus(this, 4, 2);// Connect to one of the devices
  //launchPad = new MidiBus(this, 2, 1);// Connect to one of the devices
  

  instrumentType = 0; //monophonic (= 1 polyphonic)
  tempNotes = new ArrayList <Note>();
  sustainedNotes = new ArrayList <Note>();
  prevNote = new Note(0, 0);

  Ani.init(this); // Animation library init 
  
  
  /*Antonino code*/
   step = 0;
   ramp = new Ramp();
   attackTimeMs = 5000;
   decayTimeMs = 3000;
   releaseTimeMs = 4000;
   times = new float[3];
   times[0] = attackTimeMs;
   times[1] = decayTimeMs;
   times[2] = releaseTimeMs;
   velValues = new int[3];
   velValues[0] = (int)map(prevNoteVelocity, 0, 127, 0, 255);
   velValues[1] = (int)map(susValue, 0, 127, 0, 255);
   velValues[2] = velValues[1];
   isPressed = false;
  
  /*End Antonino code*/
}

void draw() {
  
  //background
  fill(0);
  rect(0, 0, width, height);

  //draw notes
  if (instrumentType == 1) { //poliphony
  
    for (int i=0; i<tempNotes.size(); i++ ) {  
      tempNotes.get(i).show();
    }
    
  } else { //monophony
  
    if (!tempNotes.isEmpty()) {
      
      
      alfa += 0.1 * modulationRate; //lfo phase
      float x = prevNote.position.x;
      float y = (prevNote.position.y - pitchBend) + modulation * sin(alfa);
      float orizontalDiameter = 20 + cutOffFilter;
      float verticalDiameter = 20 + abs(pitchBend) + cutOffFilter;
      
      opacity = map (prevNote.velocity, 0, 127, 100, 255);
      println("velocity is " + prevNote.velocity);
      println("opacity is " + opacity);
      fill(255, 0, 0, ramp.rampValue); //ramp Antonino
      noStroke();
      ellipse(x, y, orizontalDiameter, verticalDiameter); //midiHandler and Note manages the animation of the ellipse
      
      
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
      ramp = new Ramp(times[step], millis(), 0, step, velValues[1], 0);
      break;
  }
  
  if(step<3) {  
    startingTime = millis();
  }
  
}

public void endedRamp() {
  step++;
  //step= step%3;
  nextRamp();
}
/*End Antonino Code*/
