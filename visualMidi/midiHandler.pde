private ArrayList<Note> tempNotes;
private boolean alreadyInTempChord;

public void midiInit() {

  println("MIDI INIT");
  MidiBus.list();
  minilogue = new MidiBus(this);// Connect to one of the devices
  minilogueBusName = minilogue.getBusName();
  guitar = new MidiBus(this);// Connect to one of the devices
  //for (String device : MidiBus.availableOutputs()){ //Assuming to send MIDI messages to all the devices, to avoid creating new menu
    guitar.addOutput("CoreMIDI4J - USB Uno MIDI Interface");
  //}
  println("Output size: ", guitar.attachedOutputs().length);
  guitarBusName = guitar.getBusName();
  tempNotes = new ArrayList<Note>();
  alreadyInTempChord = false;

  /*Init ArrayList of kemper stomps*/
  for (int i=0; i<4; i++){
    kemperStomps.add(new KemperStomp(50+i));
  }
  initScanKemper(); //Scan the kemper parameters at the beginning by sending SysEx requests
  
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
      parseSysEx((SysexMessage)message);
    }

    if((int)(message.getMessage()[0] & 0xFF)==192){
      println("Calling Program" + ((int)(message.getMessage()[1] & 0xFF)));
      //activateProgram((int)(message.getMessage()[1] & 0xFF));
    }
    
  }
}

private int voiceLimiter() {
  if (poly) return 4;
  return 1;
}

public void parseSysEx(SysexMessage sysEx){

  int page = ((int)sysEx.getData()[7]);
  int ctrl = ((int)sysEx.getData()[8]);
  int msbVal = ((int)sysEx.getData()[9]);
  int lsbVal = ((int)sysEx.getData()[10]);
  ArrayList<String> strArr = new ArrayList<String>();

  /*Stampa messaggio SysEx*/
  print("SYSTEM ");
  for(int i=0; i<sysEx.getData().length; i++){
    strArr.add(String.format("%02x", sysEx.getData()[i]));
    print(strArr.get(i) + " ");
  }
  println("");
  /*Fine stampa messaggio*/

  /*Start PArsing*/
  if (strArr.get(0).equals("00") && strArr.get(1).equals("20") && strArr.get(2).equals("33")){//KPA signature
    println("Manufacturer: Kemper");
    
    if (strArr.get(5).equals("01")){ //Function Code for single parameter change
      //Parsing OD
      if(page==50 || page==51 || page==52 || page==53){//Stomp A-D
        println("Stomp single change");
        
        if (ctrl==0){
          println("Get Stomp Type");
          getStompByAddress(page).setType(getOdTypeByIntResponse(lsbVal));
        }
        if (ctrl==3){
          println("Get Stomp ON/OFF");
          getStompByAddress(page).setOn(1==lsbVal);
        }
      }
    /*End of Parsing*/

    /*Final Print*/
      println("Page: " + String.format("%d ", sysEx.getData()[7]));
      println("MSB Value: " + (msbVal*128+lsbVal));
      println(getStompByAddress(page).toString()); //Controllo Stomp nel model
      gtrOverdrive = getOdStompsResult(); //Assign global value overdrive
    } 
    /*End Single parameter change*/
    
    /*Multi Parameter Change*/
    else if (strArr.get(5).equals("06")){
      println("Function: Request Multi Parameter");
    }
  }
}

public KemperStomp getStompByAddress(int address){
  for (int i=0; i<kemperStomps.size(); i++){
    if (kemperStomps.get(i).getAddress() == address){
      return kemperStomps.get(i);
    }
  }
  return new KemperStomp(56);
}

public String getOdStompsResult(){
  //Return the type (string) of the most contributing Overdrive effect in the Stomp section
  String max = "none";
  HashMap<String,Integer> hm = new HashMap<String,Integer>();
  hm.put("none", 0);
  hm.put("boost", 1);
  hm.put("overdrive", 2);
  hm.put("distortion", 3);
  hm.put("fuzz", 4);
  for (KemperStomp actStomp : kemperStomps){
    if ((hm.get(actStomp.getType()) > hm.get(max))&&(actStomp.isOn())){
      max = actStomp.getType();
    }
  }
  println(max);
  return max;
}

public String getOdTypeByIntResponse(int lsbVal){
  switch (lsbVal){
    case 33: //Hex 21 -> Green OD
      return "overdrive";
    case 34: //Hex 22 -> Plus DS
      return "distortion";
    case 35: //Hex 23 -> One DS
      return "distortion";
    case 36: //Hex 24 -> Muffin
      return "fuzz";
    case 37: //Hex 25 -> Mouse
      return "fuzz";
    case 38: //Hex 26 -> Fuzz
      return "fuzz";
    case 39: //Hex 27 -> Metal
      return "distortion";
    case 113: //Hex 71 -> Treble Booster
      return "boost";
    case 114: //Hex 72 -> Lead Booster
      return "boost";
    case 115: //Hex 73 -> Pure Booster
      return "boost";
    default: 
      return "none";
  }
}

public void initScanKemper(){ //Send all the SysExs for all the Kemper Parameters I care
  guitar.sendMessage(
    new byte[] {
      (byte)0xF0, 
      (byte)0x00, (byte)0x20, (byte)0x33, 
      (byte)0x00, (byte)0x00,
      (byte)0x41, (byte)0x00, 
      (byte)0x32, (byte)0x00, 
      (byte)0xF7
    }
  );
  
  /*byte[] stompATypeRequest = hexStringToByteArray("F0 00 20 33 00 00 41 00 32 00 F7");
  guitar.sendMessage(stompATypeRequest);
  byte[] stompAOnRequest = hexStringToByteArray("F0 00 20 33 00 00 41 00 32 03 F7");
  guitar.sendMessage(stompAOnRequest);
  byte[] stompBTypeRequest = hexStringToByteArray("F0 00 20 33 00 00 41 00 33 00 F7");
  guitar.sendMessage(stompBTypeRequest);
  byte[] stompBOnRequest = hexStringToByteArray("F0 00 20 33 00 00 41 00 32 03 F7");
  guitar.sendMessage(stompBOnRequest);
  byte[] stompCTypeRequest hexStringToByteArray("F0 00 20 33 00 00 41 00 34 00 F7");
  guitar.sendMessage(stompCTypeRequest);
  byte[] stompCOnRequest = hexStringToByteArray("F0 00 20 33 00 00 41 00 32 03 F7");
  guitar.sendMessage(stompCOnRequest);
  byte[] stompDTypeRequest = hexStringToByteArray("F0 00 20 33 00 00 41 00 35 00 F7");
  guitar.sendMessage(stompDTypeRequest);
  byte[] stompDOnRequest = hexStringToByteArray("F0 00 20 33 00 00 41 00 32 03 F7");
  guitar.sendMessage(stompDOnRequest);
  byte[] gainAmpRequest = hexStringToByteArray("F0 00 20 33 00 00 41 00 0A 04 F7");
  guitar.sendMessage(gainAmpRequest);
  byte[] eqRequest = hexStringToByteArray("F0 00 20 33 00 00 41 00 0B 07 F7"); //Check only the 'Presence' Parameter
  guitar.sendMessage(eqRequest);
  byte[] modulationOnRequest = hexStringToByteArray("F0 00 20 33 00 00 41 00 3A 03 F7");
  guitar.sendMessage(modulationOnRequest);
  byte[] modulationTypeRequest = hexStringToByteArray("F0 00 20 33 00 00 41 00 3A 00 F7");
  guitar.sendMessage(modulationTypeRequest);
  byte[] reverbTimeRequest = hexStringToByteArray("F0 00 20 33 00 00 41 00 3D 5D F7");
  guitar.sendMessage(reverbTimeRequest);*/
  
  
  println("Scan DOne");
}

public static byte[] hexStringToByteArray(String s) {
    int len = s.length();
    byte[] data = new byte[len / 2];
    for (int i = 0; i < len; i += 2) {
        data[i / 2] = (byte) ((Character.digit(s.charAt(i), 16) << 4)
                             + Character.digit(s.charAt(i+1), 16));
    }
    return data;
}