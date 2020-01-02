int choice;
PImage startscreen;
PFont newFont;
int mode;
int xBtn1, yBtn1, wBtn, hBtn, xBtn2, yBtn2, xBtn3, yBtn3;
float[] times;

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
  mode = 0; //Menu
  xBtn1 = 450;
  yBtn1 = 100;
  xBtn2 = 800;
  yBtn2 = 100;
  xBtn3 = 900;
  yBtn3 = 50;
  wBtn = 150;
  hBtn = 50;
  times = new float [3];
  times[0] = 300;
  times[1] = 200;
  times[2] = 1000; //default values
}

void draw() {
  
  if (mode == 0){ //menu
    image(startscreen, 0, 0);
    text("Welcome to Korg Minilogue's Visual MIDI", 600, 70);
    rect(xBtn1, yBtn1, wBtn, hBtn);
    fill(0);
    text("Store Mode", (xBtn1 + 20), (yBtn1 + 20));
    fill(255);
    rect(xBtn2, yBtn2, wBtn, hBtn);
    fill(0);
    text("Load Mode (Play)", (xBtn2 + 20), (yBtn2 + 20));
    fill(255);
    
  }
  else if (mode == 1){ //store
    storeMode();
  }
  else if (mode == 2){ //play
    loadMode();
  }
  
  
  if (mousePressed){
    if(mode == 0) {
      if (buttonPressed(xBtn1, yBtn1, wBtn, hBtn)){
        mode = 1;
      }
      else if (buttonPressed(xBtn2, yBtn2, wBtn, hBtn)){
        mode = 2;
      }
    }
    else if (mode == 1 || mode == 2){
      if (buttonPressed(xBtn3, yBtn3, wBtn, hBtn)){
        mode = 0;
      }
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

boolean buttonPressed(int x, int y, int width, int height){
  if (mouseX >= x && mouseX <= x+width && 
      mouseY >= y && mouseY <= y+height){
    return true;
  }
  else return false;
}

void storeMode(){
  
  int xStoreBtn = 500;
  int yStoreBtn = 200;
  
  background(0);
  text("Store Mode", 500, 100);
  
  rect(xBtn3, yBtn3, wBtn, hBtn);
  fill(0);
  text("Back to Menu", (xBtn3 + 20), (yBtn3 + 20));
  fill(255);
  rect(xStoreBtn, yStoreBtn, wBtn, hBtn);
  fill(0);
  text("Store Preset", (xStoreBtn + 20), (yStoreBtn + 20));
  fill(255);
  //prevDraw();
  
  if (mousePressed && buttonPressed(xStoreBtn, yStoreBtn, wBtn, hBtn)){
    savePreset();
  }
}

void loadMode(){
  background(0);
  text("Load Mode (Play)", 500, 100);
  
  rect(xBtn3, yBtn3, wBtn, hBtn);
  fill(0);
  text("Back to Menu", (xBtn3 + 20), (yBtn3 + 20));
  fill(255);
  prevDraw();
}



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

void savePreset(){
  String name = "Michele";
  try{
    FileWriter fileWriter = new FileWriter("presets.txt");
    fileWriter.write("name " + name + "\n");
    fileWriter.write("date " + (Calendar.getInstance().getTime()) +"\n");
    fileWriter.write("sustainPedal " + sustainPedal + "\n");
    fileWriter.write("modulation " + modulation + "\n");
    fileWriter.write("modulationRate " + modulationRate + "\n");
    fileWriter.write("cutoffFilter " + cutOffFilter + "\n");
    fileWriter.write("attackTime " + times[0] + "\n");
    fileWriter.write("decayTime " + times[1] + "\n");
    fileWriter.write("sustainAmp " + ampSus + "\n");
    fileWriter.write("releaseTime " + times[2] + "\n");
    fileWriter.close(); 
    println("saved preset");
  } catch (IOException e) {
    // exception handling
    println("IO Exception");
  }


}
