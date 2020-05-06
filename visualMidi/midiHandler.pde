private ArrayList<Note> tempNotes;
private boolean alreadyInTempChord;

public void midiInit() {

  println("MIDI INIT");
  MidiBus.list();
  minilogue = new MidiBus(this);// Connect to one of the devices
  minilogueBusName = minilogue.getBusName();
  guitar = new MidiBus(this);// Connect to one of the devices
  guitar.sendTimestamps(false);
  //for (String device : MidiBus.availableOutputs()){ //Assuming to send MIDI messages to all the devices, to avoid creating new menu
    guitar.addInput("CoreMIDI4J - USB Uno MIDI Interface");
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
      feedbackDly = map(value, 0, 127, 1, maxFeedbackDly);
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
          break;
        case 50:
          initScanKemper();
          break;
        case 51:
          initScanKemper();
          break;
        case 52:
          initScanKemper();
          break;
        case 53:
          initScanKemper();
          break;
        case 54:
          initScanKemper();
          break;
        default:
          break;
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

    if((int)(message.getMessage()[0] & 0xFF)==192){ //Guitar PC
      initScanKemper();
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
        println(getStompByAddress(page).toString()); //Controllo Stomp nel model
        gtrOverdrive = getOdStompsResult(); //Assign global value overdrive
      }
      //Parsing MOD Stomp
      if(page==58){ //MOD Stomp
        if(ctrl==3){ //On Off ctrl
          if(lsbVal==1){ //On
            kemperModOn = true;
            if (kemperModType != "none"){gtrModulation = kemperModType;}
          }
          else {
            kemperModOn = false;
            gtrModulation = "none";
          }
        }
        if(ctrl==0){ //Type ctrl
          kemperModType = getModTypeByIntResponse(lsbVal);
          if(kemperModOn){
            gtrModulation = kemperModType;
          }
        }
      }
      //Parsing Amplifier
      if(page==10){ //Amp ctrl
        if(ctrl==4){ //Gain
          gtrAmp = getAmpTypeByIntResponses(msbVal, lsbVal);
        }
      }
      //Parsing EQ
      if(page==11){ //EQ ctrl
        if(ctrl==7){ //Gain
          gtrEq = getEqTypeByIntResponses(msbVal, lsbVal);
        }
      }
      //Parsing Reverb
      if(page==61){ //Reverb stomp ctrl
        if(ctrl==93){ //Gain
          gtrReverb = getReverbTypeByIntResponses(msbVal, lsbVal);
        }
      }
      
      /*Final Print*/
      print("Overdrive: " + gtrOverdrive);
      print(" Amp: " + gtrAmp);
      print(" Eq: " + gtrEq);
      print(" Modulation: " + gtrModulation);
      print(" Reverb: " + gtrReverb);
      println("");
    } 
    /*End Single parameter change*/
    
    /*Multi Parameter Change*/
    else if (strArr.get(5).equals("06")){
      println("Function: Request Multi Parameter");
      initScanKemper();
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

public String getModTypeByIntResponse(int lsbVal){
  switch (lsbVal){
    case 65: //Hex 41 -> Vintage Chorus CE
      return "chorus";
    case 66: //Hex 42 -> Hyper Chorus
      return "chorus";
    case 67: //Hex 43 -> Air Chorus
      return "chorus";
    case 71: //Hex 47 -> Micro Pitch
      return "chorus";
    case 81: //Hex 51 -> Phaser
      return "phaser";
    case 82: //Hex 52 -> Phaser Vibe
      return "phaser";
    case 83: //Hex 53 -> One-Way Phaser
      return "phaser";
    case 89: //Hex 59 -> Flanger
      return "flanger";
    case 91: //Hex 5B -> One-Way Flanger
      return "flanger";
    default: 
      return "none";
  }
}

public String getAmpTypeByIntResponses(int msbVal, int lsbVal){
  int value = 128*msbVal + lsbVal;
  int discreteVal = Math.round(map(value, 0, 16383, 1, 3));
  String retString = "";
  switch (discreteVal){
    case 1:
      retString = "clean";
      break;
    case 2:
      retString = "crunch";
      break;
    case 3:
      retString = "hiGain";
      break;
    default:
      retString = "clean";
      break;
  }
  println(retString);
  return retString;
}

public String getEqTypeByIntResponses(int msbVal, int lsbVal){
  int value = 128*msbVal + lsbVal;
  int discreteVal = Math.round(map(value, 0, 16383, 1, 3));
  String retString = "";
  switch (discreteVal){
    case 1:
      retString = "warm";
      break;
    case 2:
      retString = "normal";
      break;
    case 3:
      retString = "bright";
      break;
    default:
      retString = "normal";
      break;
  }
  println(retString);
  return retString;
}

public String getReverbTypeByIntResponses(int msbVal, int lsbVal){
  int value = 128*msbVal + lsbVal;
  int discreteVal = Math.round(map(value, 0, 16383, 1, 3));
  String retString = "";
  switch (discreteVal){
    case 1:
      retString = "small";
      break;
    case 2:
      retString = "medium";
      break;
    case 3:
      retString = "large";
      break;
    default:
      retString = "medium";
      break;
  }
  println(retString);
  return retString;
}

public void initScanKemper(){ //Send all the SysExs for all the Kemper Parameters I care
  try { //All the methods of SysexMessage, ShortMessage, etc, require try catch blocks
    SysexMessage stompATypeRequest = new SysexMessage();
    stompATypeRequest.setMessage(
      0xF0, 
      new byte[] {
        (byte)0x00, (byte)0x20, (byte)0x33, 
        (byte)0x00, (byte)0x00,
        (byte)0x41, (byte)0x00, 
        (byte)0x32, (byte)0x00, 
        (byte)0xF7
      },
      10
    );
    guitar.sendMessage(stompATypeRequest);

    SysexMessage stompAOnRequest = new SysexMessage();
    stompAOnRequest.setMessage(
      0xF0, 
      new byte[] {
        (byte)0x00, (byte)0x20, (byte)0x33, 
        (byte)0x00, (byte)0x00,
        (byte)0x41, (byte)0x00, 
        (byte)0x32, (byte)0x03, 
        (byte)0xF7
      },
      10
    );
    guitar.sendMessage(stompAOnRequest);

    SysexMessage stompBTypeRequest = new SysexMessage();
    stompBTypeRequest.setMessage(
      0xF0, 
      new byte[] {
        (byte)0x00, (byte)0x20, (byte)0x33, 
        (byte)0x00, (byte)0x00,
        (byte)0x41, (byte)0x00, 
        (byte)0x33, (byte)0x00, 
        (byte)0xF7
      },
      10
    );
    guitar.sendMessage(stompBTypeRequest);

    SysexMessage stompBOnRequest = new SysexMessage();
    stompBOnRequest.setMessage(
      0xF0, 
      new byte[] {
        (byte)0x00, (byte)0x20, (byte)0x33, 
        (byte)0x00, (byte)0x00,
        (byte)0x41, (byte)0x00, 
        (byte)0x33, (byte)0x03, 
        (byte)0xF7
      },
      10
    );
    guitar.sendMessage(stompBOnRequest);

    SysexMessage stompCTypeRequest = new SysexMessage();
    stompCTypeRequest.setMessage(
      0xF0, 
      new byte[] {
        (byte)0x00, (byte)0x20, (byte)0x33, 
        (byte)0x00, (byte)0x00,
        (byte)0x41, (byte)0x00, 
        (byte)0x34, (byte)0x00, 
        (byte)0xF7
      },
      10
    );
    guitar.sendMessage(stompCTypeRequest);

    SysexMessage stompCOnRequest = new SysexMessage();
    stompCOnRequest.setMessage(
      0xF0, 
      new byte[] {
        (byte)0x00, (byte)0x20, (byte)0x33, 
        (byte)0x00, (byte)0x00,
        (byte)0x41, (byte)0x00, 
        (byte)0x34, (byte)0x03, 
        (byte)0xF7
      },
      10
    );
    guitar.sendMessage(stompCOnRequest);

    SysexMessage stompDTypeRequest = new SysexMessage();
    stompDTypeRequest.setMessage(
      0xF0, 
      new byte[] {
        (byte)0x00, (byte)0x20, (byte)0x33, 
        (byte)0x00, (byte)0x00,
        (byte)0x41, (byte)0x00, 
        (byte)0x35, (byte)0x00, 
        (byte)0xF7
      },
      10
    );
    guitar.sendMessage(stompDTypeRequest);

    SysexMessage stompDOnRequest = new SysexMessage();
    stompDOnRequest.setMessage(
      0xF0, 
      new byte[] {
        (byte)0x00, (byte)0x20, (byte)0x33, 
        (byte)0x00, (byte)0x00,
        (byte)0x41, (byte)0x00, 
        (byte)0x35, (byte)0x03, 
        (byte)0xF7
      },
      10
    );
    guitar.sendMessage(stompDOnRequest);

    SysexMessage gainAmpRequest = new SysexMessage();
    gainAmpRequest.setMessage(
      0xF0, 
      new byte[] {
        (byte)0x00, (byte)0x20, (byte)0x33, 
        (byte)0x00, (byte)0x00,
        (byte)0x41, (byte)0x00, 
        (byte)0x0A, (byte)0x04, 
        (byte)0xF7
      },
      10
    );
    guitar.sendMessage(gainAmpRequest);

    SysexMessage eqRequest = new SysexMessage();
    eqRequest.setMessage(
      0xF0, 
      new byte[] {
        (byte)0x00, (byte)0x20, (byte)0x33, 
        (byte)0x00, (byte)0x00,
        (byte)0x41, (byte)0x00, 
        (byte)0x0B, (byte)0x07, 
        (byte)0xF7
      },
      10
    );
    guitar.sendMessage(eqRequest);

    SysexMessage modulationOnRequest = new SysexMessage();
    modulationOnRequest.setMessage(
      0xF0, 
      new byte[] {
        (byte)0x00, (byte)0x20, (byte)0x33, 
        (byte)0x00, (byte)0x00,
        (byte)0x41, (byte)0x00, 
        (byte)0x3A, (byte)0x03, 
        (byte)0xF7
      },
      10
    );
    guitar.sendMessage(modulationOnRequest);

    SysexMessage modulationTypeRequest = new SysexMessage();
    modulationTypeRequest.setMessage(
      0xF0, 
      new byte[] {
        (byte)0x00, (byte)0x20, (byte)0x33, 
        (byte)0x00, (byte)0x00,
        (byte)0x41, (byte)0x00, 
        (byte)0x3A, (byte)0x00, 
        (byte)0xF7
      },
      10
    );
    guitar.sendMessage(modulationTypeRequest);

    SysexMessage reverbTimeRequest = new SysexMessage();
    reverbTimeRequest.setMessage(
      0xF0, 
      new byte[] {
        (byte)0x00, (byte)0x20, (byte)0x33, 
        (byte)0x00, (byte)0x00,
        (byte)0x41, (byte)0x00, 
        (byte)0x3D, (byte)0x5D, 
        (byte)0xF7
      },
      10
    );
    guitar.sendMessage(reverbTimeRequest);


  } catch(Exception e) {

  }
  
  
  println("Scan DOne");
}
