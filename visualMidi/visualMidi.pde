//<>// //<>//

import controlP5.*;
import processing.sound.*;
SoundFile file;
void setup() {
  
  startscreen = loadImage("korg.jpg");
  //size(1920, 1080, P3D);
  size(1280, 800, P3D);
  //fullScreen(P3D);
  background(0);
  imageMode(CENTER);
  textSize(24);

  midiInit();
  adsrInit();
  menuInit();
  file = new SoundFile(this, sketchPath("data/pry.mp3"));
  //file.play();
  initializeStarField();
 //drawDevicesMenu();
  poly = true;
}

void drawMode0() {
  rectMode(CENTER);
  textAlign(CENTER, CENTER);
  image(startscreen, width/2, height * .6);
  text("Welcome to Korg Minilogue's Visual MIDI", 100, 10);    
  storeModeBtn.showBtn();
  loadModeBtn.showBtn();
  playModeBtn.showBtn();
  deviceModeBtn.showBtn();
  programStoreModeBtn.showBtn();
}

void cleanScreen() {
  noStroke();
  rectMode(CENTER);
  fill(0);  
  rect(width/2, height/2, width, height);
}

void draw() {

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
    playDraw();
  }
    else if (mode == 4) {
    deviceMode();
  }
    else if (mode == 5) {
      programStoreMode();
    }

}

void playDraw() {
  //background
  if (EGInt < 8 && EGInt > -6) { // se EGInt è nel range dello 0% 
    fill((cutOffFilter/100) * 255);
    /**/fill(0);
  } else {
    fill((filterRampValueBackground/100) * 255);
  }
  rect(width/2, height/2, width, height);
  lights();
  //fill(255);  
  textAlign(CENTER, CENTER);
  rectMode(CENTER);
  text("Play Mode", (width/2), (height*0.2));
  backToMenuBtn.showBtn();
  starField.draw();
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
} 

void initializeStarField() {
  starField = new StarField(1000);

}