//<>// //<>//
void setup() {
  
  startscreen = loadImage("korg.jpg");
  //int a = startscreen.width;
  //int b = startscreen.height;
  //println(a +" ", b);
  //size(1920, 1080, P3D);
  fullScreen(P3D);
  background(0);
  imageMode(CENTER);
  textSize(24);
  
  //translate(250, 250);
  image(startscreen, width/2, height * .6);

  midiInit();
  adsrInit();
  menuInit();
  poly = true;
}
void cleanScreen() {
  rectMode(CENTER);
  fill(0);  
  rect(width/2, height/2, width, height);
}

void draw() {
  cleanScreen();
  textSize(24);
  if (mode == 0) { //menu
    rectMode(CENTER);
    textAlign(CENTER, CENTER);
    image(startscreen, width/2, height * .6);
    text("Welcome to Korg Minilogue's Visual MIDI", 0, 10);
    fill(255);
    rect(xBtn1, yBtn1, wBtn, hBtn);
    fill(0);
    text("Store Mode", (xBtn1), (yBtn1));
    fill(255);
    rect(xBtn2, yBtn2, wBtn, hBtn);
    fill(0);
    text("Load Mode", (xBtn2), (yBtn2));
    fill(255);
    rect(xBtn3, yBtn3, wBtn, hBtn);
    fill(0);
    text("Play Mode", (xBtn3), (yBtn3));

    noLoop();
  } else if (mode == 1) { //store
    storeMode();
  } else if (mode == 2) { //play
    loadMode();
  } else if (mode == 3) { //play
    playDraw();
  }
}

void playDraw() {


  //background
  if (EGInt < 8 && EGInt > -6) { // se EGInt è nel range dello 0%  
    fill(cutOffFilter);
  } else {
    fill(filterRampValueBackground);
  }
  rect(width/2, height/2, width, height);
  lights();

  fill(255);  
  textAlign(CENTER, CENTER);
  rectMode(CENTER);
  text("Play Mode", (xBtn3), (yBtn3));
  //fill(255);
  //rect(xBtn4, yBtn4, wBtn, hBtn);
  fill(0);
  text("Back to Menu", (xBtn4), (yBtn4));

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
