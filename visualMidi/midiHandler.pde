private ArrayList<Note> tempNotes;
private boolean alreadyInTempChord;

public void midiInit() {

  println("MIDI INIT");
  MidiBus.list();
  minilogue = new MidiBus(this, 1, 1);// Connect to one of the devices
  minilogueBusName = minilogue.getBusName();

  minilogue = new MidiBus(this);// Connect to one of the devices
  guitar = new MidiBus(this);// Connect to one of the devices
  guitarBusName = guitar.getBusName();
  tempNotes = new ArrayList<Note>();
  alreadyInTempChord = false;
}

//NOTE ON
void noteOn(int channel, int pitch, int velocity) {

  println("Note ON");

  Note newNote = new Note(pitch, velocity);
  
  int i;
  for ( i = 0; i<tempNotes.size(); i++) {
    if (tempNotes.get(i).getPitch() == newNote.pitch) {
      alreadyInTempChord = true;
      break;
    }
  }

  //Assuming there is no sustain pedal

  if (voiceLimiter() - tempNotes.size()>0) {
    if(alreadyInTempChord){
      tempNotes.get(i).noteOnEffect(); // reset adrs
      alreadyInTempChord =false;
    } else {
      newNote.noteOnEffect();
      tempNotes.add(newNote);
    }
  } else {
    
    if(alreadyInTempChord) {
      tempNotes.get(i).noteOnEffect(); //reset adsr
      alreadyInTempChord = false;
    } else {
      newNote.noteOnEffect();
      tempNotes.remove(tempNotes.size()-1); // la più recente      
      tempNotes.add(newNote);
    }
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
      modulation = mapLog(value, 0, 127, 0.1, 100);
      break;
  
    case 24:
      modulationRate = mapLog(value, 0, 127, 0.02, 1000); // minilogue "rate" knob
      break;
  
    case 26: //!!!!!!!! MINILOGUE HAS INT VALUE AS MODULATION WHEEL ---> 0-127
      modulation = mapLog(value, 0, 127, 1, 100); // or mapLog?
      break;
  
    case 43:
      if(value == 0 ) cutOffFilter = 0;
      else cutOffFilter = mapLog(value, 0, 127, 1, 100); //cut off
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
      timeDly = mapLog(value, 0, 127, 1, maxDlyTime);
      break;

    case 31: 
      feedbackDly = mapLog(value, 0, 127, 1, maxFeedbackDly);
      //change lifespan if move this knob: realtime feedback knob
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
      println("Guitar CC");
      switch(number){
        case 1: 
          println("Wah");
          starField.setSpeed((int)map(value, 0, 127, 5, 100));
      }

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
    //for (int i = 0; i < message.getMessage().length; i++) {    //SHOW MIDI MESSAGES CODE & VALUE
    //    if((message.getMessage()[i] & 0xFF)!=248) {
    //  //println("Param "+(i+1)+": "+(int)(message.getMessage()[i] & 0xFF)); }
    //}
    if (message.getStatus() == 224) { //PITCHBEND! !!!MSB ARE THE SECOND MESSAGE----> we consider only MSB
      pitchBend = map((int)(message.getMessage()[2] & 0xFF), 0, 127, -64, 64);
    }
    if((int)(message.getMessage()[0] & 0xFF)==192){
      println("Calling Program" + ((int)(message.getMessage()[1] & 0xFF)));
      //println("Calling Program" + ((message.getMessage() & 0xFF)));
      id = ((int)(message.getMessage()[1] & 0xFF));
      activatePreset((int)(message.getMessage()[1] & 0xFF));
    }
  }
  
  if (bus_name == guitarBusName) {
    /*for (int i = 0; i < message.getMessage().length; i++) {    //SHOW MIDI MESSAGES CODE & VALUE
      if((int)(message.getMessage()[i] & 0xFF)!=254){
        println("Guitar Param "+(i)+": "+(int)(message.getMessage()[i] & 0xFF));
      }
    }*/


    if(message instanceof SysexMessage){
      print("SYSTEM ");
      SysexMessage msg = (SysexMessage)message.clone();
      //msg = (SysexMessage)message.clone();
      /*String result = "";
      result = decodeMessage((SysexMessage) message);
      print(result);
      println("");*/
      for(int i=0; i<msg.getData().length; i++){
        print(String.format("%02x ", msg.getData()[i]));
      }
      println("");
    }

    if((int)(message.getMessage()[0] & 0xFF)==192){
      println("Calling Program" + ((int)(message.getMessage()[1] & 0xFF)));
      activateProgram((int)(message.getMessage()[1] & 0xFF));
    }
    
  }
}

private String decodeMessage(SysexMessage message) {
	byte[] abData = message.getData();
	String result = null;
	if (message.getStatus() == SysexMessage.SYSTEM_EXCLUSIVE) 
		result = "Sysex message: F0" + toHex(abData);
	 else if (message.getStatus() == SysexMessage.SPECIAL_SYSTEM_EXCLUSIVE)
		result = "Continued Sysex message F7" + toHex(abData);
	return result;
}

private int voiceLimiter() {
  if (poly) return 4;
  return 1;
}

private String toHex(byte[] data){
  String str = " ";
  for(int i=0; i<data.length; i++){
    str += Integer.toHexString(data[i]);
    str += " ";
  }
  return str;
}