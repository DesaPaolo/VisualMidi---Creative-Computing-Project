private ArrayList<Note> tempNotes;
private int instrumentType = 0;

public void midiInit() {

  MidiBus.list(); // List all our MIDI devices
  minilogue = new MidiBus(this, 0, 3);// Connect to one of the devices
  tempNotes = new ArrayList<Note>();
}

//NOTE ON
void noteOn(int channel, int pitch, int velocity) {

  println("Note ON");

  Note newNote = new Note(pitch, velocity);

  //Assuming there is no sustain pedal

  if (!tempNotes.isEmpty()) { 
    prevNote = tempNotes.get(tempNotes.size()-1);
  } 

  newNote.noteOnEffect();
  tempNotes.add(newNote);
}

//NOTE OFF
void noteOff(int channel, int pitch, int velocity) {

  println("Note OFF");


  for (int i=0; i<tempNotes.size(); i++ ) {
    if (tempNotes.get(i).getPitch() == pitch) {
      if (i == tempNotes.size()-1) {//synth animation
        prevNote = tempNotes.get(i);
      }
      tempNotes.get(i).ramp.startRelease(); //per rimuovere la nota dopo la fine del release
    }
  }

  if (!tempNotes.isEmpty()) { //synth animation
    tempNotes.get(tempNotes.size()-1).noteOffEffect();
  }
}


//CONTROL CHANGE
void controllerChange(int channel, int number, int value) {

  println("CONTROL: " + number + " CONTROL VALUE: " + value);
  println("channel " + channel);
  println("t3: " + times[3]);
  switch (number) {
  case 64: //Sustain Pedal  --->   ≤63 off, ≥64 on

    if (instrumentType == 0) { //piano

      if (value>=64) { //sustain on
        sustainPedal = true;
      } else { //sustain off ----> noteOff of each sustained notes

        if (sustainedNotes.size()>0) { 
          for (int i=0; i<sustainedNotes.size(); i++) {
            for (int j=0; j<tempNotes.size(); j++) {
              if (sustainedNotes.get(i).getPitch() == tempNotes.get(j).getPitch()) {
                println("Note Off of " + tempNotes.get(j).getPitch());
                tempNotes.remove(j);
              }
            }
          }
        }
        sustainedNotes.clear();
        sustainPedal = false;
      }
    }
    break;

  case 1: //Modulation Wheel ---> 0-127
    modulation=mapLog(value, 0, 127, 1, 100);
    break;
  case 26: //!!!!!!!! MINILOGUE HAS INT VALUE AS MODULATION WHEEL ---> 0-127
    modulation=map(value, 0, 127, 1, 100); // or mapLog?
    break;

  case 24:
    modulationRate = mapLog(value, 0, 127, 0.1, 97); // minilogue "rate" knob
    break;

  case 43:
    cutOffFilter = (int)(mapLog(value, 0, 127, 0.1, 255)); //cut off
    println("Cutoff filter is " + cutOffFilter);
    break;

  case 16: //atck
    times[0] = map(value, 0, 127, 0, 3500);
    println("AttackTime is " + times[0]);
    break;
  case 17: //dcy
    times[1] = map(value, 0, 127, 0, 4000);
    println("DecayTime is " + times[1]);
    break; 

  case 18: //sus
    ampSus = map(value, 0, 127, 0, 100);
    times[2] = -1;
    break;

  case 19: //rel
    times[3] = mapLog(value, 0, 127, 0.1, 4500);
    println("ReleaseTime is " + times[3]);
    break;

  case 20:
    EGTimes[0] = map(value, 0, 127, 0, 3000);
    break;

  case 21:
    EGTimes[1] = map(value, 0, 127, 0, 6000);
    break;

  case 22:
    EGAmpSus = map(value, 0, 127, 0, 100);
    EGTimes[2] = -1;
    break;

  case 23:
    EGTimes[3] = map(value, 0, 127, 0, 6000);
    break;

  case 45: //EG INT
    /*
    if(value>=68) {
     contour = 1;
     }
     else if (value<=60) {
     contour = -1;
     }
     else {
     contour = 0;
     }*/

    EGInt = map(value, 0, 127, -100, 100);//prima era mappato da 0 a 255
    break;

  default:
    //nothing
  }
}


//PITCH BEND CONTROL (!= CONTROL CHANGE)  

//https://github.com/sparks/themidibus/blob/master/examples/AdvancedMIDIMessageIO/AdvancedMIDIMessageIO.pde

// Notice all bytes below are converted to integeres using the following system:
// int i = (int)(byte & 0xFF) 
// This properly convertes an unsigned byte (MIDI uses unsigned bytes) to a signed int
// Because java only supports signed bytes, you will get incorrect values if you don't do so

void midiMessage(MidiMessage message) { // You can also use midiMessage(MidiMessage message, long timestamp, String bus_name)
  // Receive a MidiMessage
  // MidiMessage is an abstract class, the actual passed object will be either javax.sound.midi.MetaMessage, javax.sound.midi.ShortMessage, javax.sound.midi.SysexMessage.
  // Check it out here http://java.sun.com/j2se/1.5.0/docs/api/javax/sound/midi/package-summary.html
  //println();
  //println("MidiMessage Data:");
  //println("--------");
  //println("Status Byte/MIDI Command:"+message.getStatus());
  for (int i = 1; i < message.getMessage().length; i++) {    //SHOW MIDI MESSAGES CODE & VALUE
    //println("Param "+(i+1)+": "+(int)(message.getMessage()[i] & 0xFF));
  }
  if (message.getStatus() == 224) { //PITCHBEND! !!!MSB ARE THE SECOND MESSAGE----> we consider only MSB
    pitchBend = map((int)(message.getMessage()[2] & 0xFF), 0, 127, -64, 64);
  }
}
