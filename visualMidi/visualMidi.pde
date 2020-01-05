 //<>//
void setup() {

  size(1200, 600, P3D);
  //fullScreen(P3D);
  background(0);
  startscreen = loadImage("korg.jpg");
  image(startscreen, 0, 0);

  midiInit();
  adsrInit();
  menuInit();
  poly = true;
}

void draw() {

  if (mode == 0) { //menu
    image(startscreen, 0, 0);
    text("Welcome to Korg Minilogue's Visual MIDI", 600, 70);
    fill(255);
    rect(xBtn1, yBtn1, wBtn, hBtn);
    fill(0);
    text("Store Mode", (xBtn1 + 20), (yBtn1 + 20));
    fill(255);
    rect(xBtn2, yBtn2, wBtn, hBtn);
    fill(0);
    text("Load Mode", (xBtn2 + 20), (yBtn2 + 20));
    fill(255);
    rect(xBtn3, yBtn3, wBtn, hBtn);
    fill(0);
    text("Play Mode", (xBtn3 + 20), (yBtn3 + 20));

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

  rect(0, 0, width, height);
  lights();

  fill(255);  
  text("Play Mode", 500, 100);
  fill(255);
  rect(xBtn4, yBtn4, wBtn, hBtn);
  fill(0);
  text("Back to Menu", (xBtn4 + 20), (yBtn4 + 20));

  //Chiama update della view per ogni nota. Da aggiungere differenza tra monofonia e polifonia e limite 
  //massimo di voci a 4, per rispecchiare sempre l'audio output del minilogue.
  if (!tempNotes.isEmpty()) {
    for (int i=0; i<tempNotes.size(); i++ ) { 

      tempNotes.get(i).filterRamp.trigger();
      tempNotes.get(i).ramp.trigger();
      tempNotes.get(i).update();
    }
  } else {
    if (!susNotes.isEmpty()) {
      while (!susNotes.isEmpty()) susNotes.remove(0);
    }
  }
} 
