private ArrayList<Note> tempNotes;
private ArrayList<Note> susNotes;

public void midiInit() {

  MidiBus.list(); // List all our MIDI devices
  minilogue = new MidiBus(this, 6, 7);// Connect to one of the devices
  minilogueBusName = minilogue.getBusName();
  guitar = new MidiBus(this, 4, 5);// Connect to one of the devices
  guitarBusName = guitar.getBusName();
  tempNotes = new ArrayList<Note>();
  susNotes = new ArrayList<Note>();
}

//NOTE ON
void noteOn(int channel, int pitch, int velocity) {

  println("Note ON");

  Note newNote = new Note(pitch, velocity);

  //Assuming there is no sustain pedal

  if (voiceLimiter() - susNotes.size()>0) {
    newNote.noteOnEffect();
    tempNotes.add(newNote);
  } else {
    Note n = tempNotes.get(0);
    n.setPitch(pitch);   
    /*prendere la voce meno recente, e cambiarne il pitch con portamento time al nuovo pitch*/
  }
}


private boolean isAvaiableVoice() {

  if (tempNotes.size() < voiceLimiter()) {
    return true;
  } else {
    return false;
  }
}

//NOTE OFF
void noteOff(int channel, int pitch, int velocity) {

  println("Note OFF");

  for (int i=0; i<tempNotes.size(); i++ ) {
    if (tempNotes.get(i).getPitch() == pitch) {
      tempNotes.get(i).ramp.startRelease(); //per rimuovere la nota dopo la fine del release
      tempNotes.get(i).filterRamp.startRelease();
    }
  }
}


//CONTROL CHANGE
void controllerChange(int channel, int number, int value, long timestamp, java.lang.String bus_name) {

  println("CONTROL: " + number + " CONTROL VALUE: " + value);
  println("channel " + channel);
  println("is kemper: " + (bus_name == guitarBusName));
  println("t3: " + times[3]);
  
  if (bus_name == minilogueBusName){ //Potrebbe arrivare lo stesso CC da due bus diversi 
    switch (number) {
  
    case 1: //Modulation Wheel ---> 0-127
      modulation = mapLog(value, 0, 127, 1, 100);
      break;
  
    case 24:
      modulationRate = mapLog(value, 0, 127, 0.1, 97); // minilogue "rate" knob
      break;
  
    case 26: //!!!!!!!! MINILOGUE HAS INT VALUE AS MODULATION WHEEL ---> 0-127
      modulation = mapLog(value, 0, 127, 1, 100); // or mapLog?
      break;
  
    case 43:
      cutOffFilter = (int)(mapLog(value, 0, 127, 0.1, 255)); //cut off
      println("Cutoff filter is " + cutOffFilter);
      break;
  
    case 16: //atck
      times[0] = mapLog(value, 0, 127, 10, 3500);
      println("AttackTime is " + times[0]);
      break;
    case 17: //dcy
      times[1] = mapLog(value, 0, 127, 10, 4000);
      println("DecayTime is " + times[1]);
      break; 
  
    case 18: //sus
      ampSus = map(value, 0, 127, 0, 100);
      times[2] = -1;
      break;
  
    case 19: //rel
      times[3] = mapLog(value, 0, 127, 20, 4500);
      println("ReleaseTime is " + times[3]);
      break;
  
    case 20:
      if (value < 64) {
        EGTimes[0] = mapLog(value, 0, 127, 1, 1400);
      } else {
        EGTimes[0] = mapLog(value, 0, 127, 1, 3500);
      }
      break;
  
    case 21:
      EGTimes[1] = mapLog(value, 0, 127, 1, 3000);
      break;
  
    case 22:
      EGAmpSus = map(value, 0, 127, 0, 100);
      EGTimes[2] = -1;
      break;
  
    case 23:
      EGTimes[3] = mapLog(value, 0, 127, 1, 4500);
      break;
    
    case 29: //Hi pass delay
      hiPassDly = map(value, 0, 127, 0, 255);
      break;
      
    case 30:
      timeDly = map(value, 0, 127, 0, 100);
      break;

    case 31: 
      feedbackDly = map(value, 0, 127, 0, 1000);
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
      println(EGInt);
      break;
  
    case 82:
      if (value == 127) poly = true;
      else if (value == 0) poly = false;
      break;
    
    case 88:
      if (value == 64) isActiveDly = true;
      else isActiveDly = false;
      break;
    
    default:
      //nothing
    }
  }
  
  if (bus_name == guitarBusName){
      //Check CC codes of pedalboard
      
  }  
}


//PITCH BEND CONTROL (!= CONTROL CHANGE)  

//https://github.com/sparks/themidibus/blob/master/examples/AdvancedMIDIMessageIO/AdvancedMIDIMessageIO.pde

// Notice all bytes below are converted to integeres using the following system:
// int i = (int)(byte & 0xFF) 
// This properly convertes an unsigned byte (MIDI uses unsigned bytes) to a signed int
// Because java only supports signed bytes, you will get incorrect values if you don't do so

void midiMessage(MidiMessage message, long timestamp, String bus_name) { // You can also use midiMessage(MidiMessage message, long timestamp, String bus_name)
  // Receive a MidiMessage
  // MidiMessage is an abstract class, the actual passed object will be either javax.sound.midi.MetaMessage, javax.sound.midi.ShortMessage, javax.sound.midi.SysexMessage.
  // Check it out here http://java.sun.com/j2se/1.5.0/docs/api/javax/sound/midi/package-summary.html
  //println();
  //println("MidiMessage Data:");
  //println("--------");
  //println("Status Byte/MIDI Command:"+message.getStatus());
  if (bus_name == minilogueBusName) {
    for (int i = 0; i < message.getMessage().length; i++) {    //SHOW MIDI MESSAGES CODE & VALUE
        if((message.getMessage()[i] & 0xFF)!=248) {
      println("Param "+(i+1)+": "+(int)(message.getMessage()[i] & 0xFF)); }
    }
    if (message.getStatus() == 224) { //PITCHBEND! !!!MSB ARE THE SECOND MESSAGE----> we consider only MSB
      pitchBend = map((int)(message.getMessage()[2] & 0xFF), 0, 127, -64, 64);
    }
  }
  
  if (bus_name == guitarBusName) {
    for (int i = 0; i < message.getMessage().length; i++) {    //SHOW MIDI MESSAGES CODE & VALUE
      println("Guitar Param "+(i)+": "+(int)(message.getMessage()[i] & 0xFF));
    }
    /*if (message.getStatus() == 224) { //PITCHBEND! !!!MSB ARE THE SECOND MESSAGE----> we consider only MSB
      pitchBend = map((int)(message.getMessage()[2] & 0xFF), 0, 127, -64, 64);
    }*/
  }
}

private int voiceLimiter() {
  if (poly) return 4;
  return 1;
}
