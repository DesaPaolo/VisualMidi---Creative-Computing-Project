private ArrayList<Note> tempNotes = new ArrayList<Note>();
private int instrumentType;

//NOTE ON
void noteOn(int channel, int pitch, int velocity) {

  println("Note ON");

  Note newNote = new Note(pitch, velocity);

  //Assuming there is no sustain pedal

   if (!tempNotes.isEmpty()) { 
      prevNote = tempNotes.get(tempNotes.size()-1);
    } 
    
   tempNotes.add(newNote);
   newNote.circle.animateNoteOn();

}

//NOTE OFF
void noteOff(int channel, int pitch, int velocity) {
  
    println("Note OFF");
    
    for (int i=0; i<tempNotes.size(); i++ ) {
      if (tempNotes.get(i).getPitch() == pitch) {
        if (i == tempNotes.size()-1) {//synth animation
          prevNote = tempNotes.get(i); 
        }
        tempNotes.remove(i);
      }
    }
    
    if (!tempNotes.isEmpty()) { //synth animation
      tempNotes.get(tempNotes.size()-1).circle.animateNoteOff();
    }
    
  }


//CONTROL CHANGE
void controllerChange(int channel, int number, int value) {

  println("CONTROL: " + number + " CONTROL VALUE: " + value);

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

  //case 11: //Expression Pedal ----> 0-127
    
  //  break;

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
    cutOffFilter = mapLog(value, 0, 127, 0.1, 100); //cut off
    println(cutOffFilter);
  
  case 16: //atck
    times[0] = map(value, 0, 127, 0, 3000);
    println("AttackTime is " + times[0]);
    break;
  case 17: //dcy
    times[1] = map(value, 0, 127, 0, 6000);
    println("DecayTime is " + times[1]);
    break; 
  
  case 18: //sus
    ampSus = map(value, 0, 127, 0, 100);
    break;
  
  case 19: //rel
    times[2] = map(value, 0, 127, 0, 6000);
    println("ReleaseTime is " + times[2]);
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
  for (int i = 1;i < message.getMessage().length;i++) {    //SHOW MIDI MESSAGES CODE & VALUE
    //println("Param "+(i+1)+": "+(int)(message.getMessage()[i] & 0xFF)); 
  }
  if (message.getStatus() == 224) { //PITCHBEND! !!!MSB ARE THE SECOND MESSAGE----> we consider only MSB
    pitchBend = map((int)(message.getMessage()[2] & 0xFF), 0, 127, -64, 64);
  }
}
