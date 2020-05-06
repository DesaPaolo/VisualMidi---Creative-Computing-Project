import controlP5.*;
import processing.sound.*;

void setup() {

  //translate(width/2,height/2);
  startscreen = loadImage("korg.jpg");
  //size(1920, 1080, P3D);
  fullScreen(P3D);
  background(0);
  imageMode(CENTER);
  textSize(24);

  midiInit();
  adsrInit();
  menuInit();

  initializeStarField();
  poly = true;

  textSize(24);

}

void drawMode0() {
  rectMode(CENTER);
  textAlign(CENTER, CENTER);
  image(startscreen,width/2, height*0.60);
  fill(255);
  text("Welcome To Korg Minilogue Visual MIDI", width/2, height*0.05);
  textSize(14);
  text("Developed by: Paolo De Santis, Michele Pilia, Antonino Natoli", width*0.76, height*0.95);     
  textSize(24);  
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
      applyModulation(tempNotes.get(i).sphere);
    }
  }
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
  //println(tempPs.size());
  applyAmp();
  applyOverdrive();
  applyReverb();
  
  starField.draw();

} 

void initializeStarField() {
  starField = new StarField(1000);
}
