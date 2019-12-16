
void setup() {

  //size(600, 600);
  fullScreen();
  background(0);

  MidiBus.list(); // List all our MIDI devices
  //loopMIDI = new MidiBus(this, 0, 1);// Connect to one of the devices
  minilogue = new MidiBus(this, 3, 3);// Connect to one of the devices
  //launchPad = new MidiBus(this, 2, 1);// Connect to one of the devices
  

  instrumentType = 0; //monophonic (= 1 polyphonic)
  tempNotes = new ArrayList <Note>();
  sustainedNotes = new ArrayList <Note>();
  prevNote = new Note(0, 0);

  Ani.init(this); // Animation library init 
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
      
      fill(255, 0, 0);
      noStroke();
      ellipse(x, y, orizontalDiameter, verticalDiameter); //midiHandler and Note manages the animation of the ellipse
      
      
    }
  }
}
