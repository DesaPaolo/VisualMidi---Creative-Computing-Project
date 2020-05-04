import controlP5.*;
import processing.sound.*;
import interfascia.*;

GUIController c;
IFButton b1, b2, b3, b4, b5;

void setup() {

  //translate(width/2,height/2);
  startscreen = loadImage("korg.jpg");
  size(1200, 1000, P3D);
  background(0);
  imageMode(CENTER);
  textSize(24);

  midiInit();
  adsrInit();
  menuInit();

  initializeStarField();
  poly = true;

  //c = new GUIController (this);
  textSize(24);
  //b1 = new IFButton ("Store Mode", 30, 20, 80, 30);
  //b2 = new IFButton ("Load Mode", 130, 20, 80, 30);
  //b3 = new IFButton("Change Device", 230, 20, 80, 30);
  //b4 = new IFButton("Play Mode", 330, 20, 80, 30);
  //b5 = new IFButton("BRUSCHi", 430, 20, 80, 30); 

  //b1.addActionListener(this);
  //b2.addActionListener(this);
  //b3.addActionListener(this);
 // b4.addActionListener(this);
  //b5.addActionListener(this);
  //c.add (b1);
  //c.add (b2);
  //c.add (b3);
  //c.add (b4);
  //c.add (b5);

}

void drawMode0() {
  rectMode(CENTER);
  textAlign(CENTER, CENTER);
  image(startscreen,width/2, height/2);
  text("Welcome to Korg Minilogue's Visual MIDI", 100, 10);    
  storeModeBtn.showBtn();
  loadModeBtn.showBtn();
  playModeBtn.showBtn();
  deviceModeBtn.showBtn();
  //programStoreModeBtn.showBtn();
}

void cleanScreen() {
  noStroke();
  rectMode(CENTER);
  fill(0);  
  rect(width/2, height/2, width, height);
}

void draw() {
  cursor();
  cleanScreen();
  textSize(24);
  //deviceMenu.showMenu();
  if (mode == 0) { //menu
    drawMode0();
    noLoop();
  } else if (mode == 1) { //store
    storeMode();
  } else if (mode == 2) { //load
    loadMode();
  } else if (mode == 3) { //play
    noCursor();
      if (keyPressed) {
        if (key == 'e') {
          cleanScreen();
          mode=0;
        }
      }
      else {
        playDraw();
      }
  } else if (mode == 4) {
    deviceMode();
  } else if (mode == 5) {
    programStoreMode();
  }
}

void playDraw() {
  //background
  if (EGInt < 8 && EGInt > -6) { // se EGInt è nel range dello 0% 
    fill((cutOffFilter/100) * 255);
    /*fill(0);*/
  } else {
    fill((filterRampValueBackground/100) * 255);
  }
  rect(width/2, height/2, width, height);
  lights();
  //fill(255);  
  textAlign(CENTER, CENTER);
  rectMode(CENTER);
  //text("Play Mode", (width/2), (height*0.2));
  //backToMenuBtn.showBtn();

  //Chiama update della view per ogni nota. Da aggiungere differenza tra monofonia e polifonia e limite 
  //massimo di voci a 4, per rispecchiare sempre l'audio output del minilogue.
  if (!tempNotes.isEmpty()) {
    for (int i=0; i<tempNotes.size(); i++ ) { 

      tempNotes.get(i).filterRamp.trigger();
      tempNotes.get(i).ramp.trigger();
      tempNotes.get(i).update();
    }
  } else {
    //tempNotes vuoto
  }

  if (!tempPs.isEmpty()) {
    for (int i=0; i<tempPs.size(); i++ ) { 
      tempPs.get(i).update();
    }
  } else {
    //tempPs vuoto
  }
  println(tempPs.size());
  applyAmp();
  applyOverdrive();
  applyReverb();
  starField.draw();

} 

void initializeStarField() {
  starField = new StarField(1000);
}
