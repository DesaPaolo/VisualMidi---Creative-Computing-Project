
void setup() {

  //size(600, 600);
  fullScreen();
  background(0);

  MidiBus.list(); // List all our MIDI devices
  //loopMIDI = new MidiBus(this, 0, 1);// Connect to one of the devices
  //launchPad = new MidiBus(this, 2, 1);// Connect to one of the devices
  minilogue = new MidiBus(this, 1, 1);// Connect to one of the devices

  instrumentType = 0; //monophony
  tempNotes = new ArrayList <Note>();
  sustainedNotes = new ArrayList <Note>();
  prevNote = new Note(0, 0);

  Ani.init(this);
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
      alfa += 0.1 * modulationRate;
      fill(255, 0, 0);
      noStroke();
      ellipse(prevNote.position.x, (prevNote.position.y - pitchBend) + modulation * sin(alfa), 20 + cutOffFilter, 20 + abs(pitchBend) + cutOffFilter);
    }
  }
}
