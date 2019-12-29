int choice;
PImage startscreen;
PFont newFont;

void setup() {
  
  //size(600, 600);
  fullScreen();
  background(0);
  startscreen = loadImage("korg.jpg");
  image(startscreen, 0, 0);
  
  MidiBus.list(); // List all our MIDI devices
  //loopMIDI = new MidiBus(this, 0, 1);// Connect to one of the devices
  minilogue = new MidiBus(this, 4, 5);// Connect to one of the devices
  //launchPad = new MidiBus(this, 2, 1);// Connect to one of the devices
  

  instrumentType = 0; //monophonic (= 1 polyphonic)
  tempNotes = new ArrayList <Note>();
  sustainedNotes = new ArrayList <Note>();
  prevNote = new Note(0, 0);

  Ani.init(this); // Animation library init 
  
  
  /*Antonino code*/
  /* step = 0;
   ramp = new Ramp();
   attackTimeMs = 300;//default value, poi si aggiorna col CC
   decayTimeMs = 500; //idem
   releaseTimeMs = 400; // idem
   times = new float[3];
   times[0] = attackTimeMs;
   times[1] = decayTimeMs;
   times[2] = releaseTimeMs;
   velValues = new int[4]; //a, d, s, r
   velValues[0] = (int)map(prevNoteVelocity, 0, 127, 0, 255);
   velValues[1] = (int)map(susValue, 0, 127, 0, 255);
   velValues[2] = 0;
   velValues[3] = velValues[1];
   isPressed = false;*/
  
  /*End Antonino code*/
}

void draw() {
  
  
  
  image(startscreen, 0, 0);
  if (mousePressed){
    prevDraw();
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


/*Michele Menu's code*/
void prevDraw(){
  //draw notes
  if (instrumentType == 1) { //poliphony
  
  //background
  fill(cutOffFilter);
  rect(0, 0, width, height);
  
    for (int i=0; i<tempNotes.size(); i++ ) {  
      tempNotes.get(i).show();
    }
    
  } else { //monophony
  
  //background
  fill(0);
  rect(0, 0, width, height);
  
    if (!tempNotes.isEmpty()) {
      
      
      alfa += 0.1 * modulationRate; //lfo phase
      float x = prevNote.position.x;
      float y = (prevNote.position.y - pitchBend) + modulation * sin(alfa);
      float orizontalDiameter = 20 + cutOffFilter;
      float verticalDiameter = 20 + abs(pitchBend) + cutOffFilter;
      
      opacity = map (prevNote.velocity, 0, 127, 100, 255);
      //println("velocity is " + prevNote.velocity);
      //println("opacity is " + opacity);
      fill(255, 255, 255, ramp.rampValue); //ramp Antonino
      println("isPressed boolean is "+isPressed);
      if ((isPressed && step != 2)||(step ==3)){
        ramp.trigger();
      }
      println("rampValue in draw is " + ramp.rampValue);
      noStroke();
      ellipse(x, y, orizontalDiameter, verticalDiameter); //midiHandler and Note manages the animation of the ellipse
      
      
    }
  }
}
