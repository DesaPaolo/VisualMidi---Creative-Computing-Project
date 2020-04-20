import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import themidibus.*; 
import java.util.ArrayList; 
import javax.sound.midi.*; 
import de.looksgood.ani.*; 
import de.looksgood.ani.easing.*; 
import java.lang.Math; 
import java.io.*; 
import java.util.*; 
import java.lang.*; 
import java.text.SimpleDateFormat; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class visualMidi extends PApplet {

//<>// //<>//
public void setup() {
  
  startscreen = loadImage("korg.jpg");
  //int a = startscreen.width;
  //int b = startscreen.height;
  //println(a +" ", b);
  //size(1920, 1080, P3D);
  
  background(0);
  imageMode(CENTER);
  textSize(24);
  
  //translate(250, 250);
  image(startscreen, width/2, height * .6f);

  midiInit();
  adsrInit();
  menuInit();
  poly = true;
}
public void cleanScreen() {
  noStroke();
  rectMode(CENTER);
  fill(0);  
  rect(width/2, height/2, width, height);
}

public void draw() {
  cleanScreen();
  textSize(24);
  if (mode == 0) { //menu
    rectMode(CENTER);
    textAlign(CENTER, CENTER);
    image(startscreen, width/2, height * .6f);
    text("Welcome to Korg Minilogue's Visual MIDI", 0, 10);
    
    
    storeModeBtn.showBtn();
    loadModeBtn.showBtn();
    playModeBtn.showBtn();

    noLoop();
  } else if (mode == 1) { //store
    storeMode();
  } else if (mode == 2) { //play
    loadMode();
  } else if (mode == 3) { //play
    playDraw();
  }
}

public void playDraw() {


  //background
  if (EGInt < 8 && EGInt > -6) { // se EGInt è nel range dello 0%  
    fill(cutOffFilter);
  } else {
    fill(filterRampValueBackground);
  }
  rect(width/2, height/2, width, height);
  lights();

  //fill(255);  
  textAlign(CENTER, CENTER);
  rectMode(CENTER);
  text("Play Mode", (width/2), (height*0.2f));
  backToMenuBtn.showBtn();

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
class Button {
  private int xPos;
  private int yPos;
  private int wid;
  private int hei;
  private String txt;
  private int backgroundColor;
  private int textColor;
  private int index = -1;

  public Button(int xPos, int yPos, int wid, int hei, String txt){
    this.xPos = xPos;
    this.yPos = yPos;
    this.wid = wid;
    this.hei = hei;
    this.txt = txt;
    this.backgroundColor = color(255);
    this.textColor = color(0);
  }
  
  public Button(int xPos, int yPos, int wid, int hei, String txt, int backgroundColor, int textColor){
    this.xPos = xPos;
    this.yPos = yPos;
    this.wid = wid;
    this.hei = hei;
    this.txt = txt;
    this.backgroundColor = backgroundColor;
    this.textColor = textColor;
  }
  
  public void showBtn(){
    fill(backgroundColor);
    rect(xPos, yPos, wid, hei);
    fill(textColor);
    text(txt, xPos, yPos);
  }
  
  public boolean isPressed(){
    if (mousePressed) {
      return ((xPos-wid/2 <= mouseX && mouseX <= xPos+wid/2) && 
      (yPos-hei/2 <=mouseY && mouseY <= yPos+hei/2)); 
    }
    else return false;
  }

  public int getIndex() {
    return this.index;
  }
  
  public void setIndex(int index){
    this.index = index;
  }







}
class Note {

  Sphere sphere; //3D
  private int pitch;
  private float velocity;
  boolean toRemove = false;

  float[] adsrValues;
  float[] filterAdsrValues;
  Ramp ramp;
  Ramp filterRamp;
  
  
  ParticleSystem ps;

  Note(int pitch, int velocity) {
    this.pitch = pitch;
    this.velocity = velocity;
    float x = map(this.pitch, 21, 108, 0, width);
    float y = map(this.pitch, 21, 108, height, 0);
    float z = 1;
    this.velocity = map(this.velocity, 0, 127, 0, 255);
    this.sphere = new Sphere(x, y, z);
    this.adsrValues = new float[3];
    this.filterAdsrValues = new float[4];
    this.ps = new ParticleSystem(new PVector(x+100, y+100));
  }

  public int getPitch() {
    return this.pitch;
  }

  //Update the view, after the model has changed
  public void update() {
    if (this.toRemove) {
      //releasedNotes--;
      removeNoteByPitch(this.pitch); //tempNotes.remove(ramp.index)
    }
    this.sphere.drawSphere(this.ramp.rampValue, this.filterRamp.rampValue, this.velocity);
    
    if(isActiveDly){
      println("Delay is active: " + isActiveDly);
      this.ps.addParticle();
      this.ps.run();
    }
    
  }

  public void noteOnEffect() {
    
    this.initAdsrRamp();
    
    if(isActiveDly){
      this.sphere.ps = new ParticleSystem(this.sphere.position);
      println("Creo particle system");
    }
    
  }

  private void initAdsrRamp() {
    this.adsrValues[0] = 255;
    this.adsrValues[1] = 255 * ((float)ampSus/100);
    this.ramp = new Ramp(times[0], millis(), 0, 0, 0, this.adsrValues[0], this, false);
    //println("AttackValueInAmplitude "+this.adsrValues[0]+ " is reached after " + times[0] + "ms");
    //println("SustainValueInAmplitude "+this.adsrValues[1]+ " is reached after " + times[1] + "ms");

    this.filterAdsrValues[0] = cutOffFilter;//is like the cutoff frequency, from 0 to 255
    this.filterAdsrValues[1] = min(255, cutOffFilter + (255 * (EGInt/100)));
    this.filterAdsrValues[2] = min(255, cutOffFilter + 255 * (EGInt/100) * ((float)EGAmpSus/100));
    this.filterAdsrValues[3] = cutOffFilter;


    //parto dal cutoff value, arrivo fino all'eg int. Poi mi fermo in sustain nel EG int scalato 
    //per il valore percentuale di sustain, e nel release torno al valore di cutoff
    this.filterRamp = new Ramp(EGTimes[0], millis(), 0, 0, this.filterAdsrValues[0], this.filterAdsrValues[1], this, true);
    //println(EGTimes);
    //println(filterAdsrValues);
  }

  public void setPitch(int pitch) {
    this.pitch = pitch;
    float newX = map(this.pitch, 21, 108, 0, width);
    float newY = map(this.pitch, 21, 108, height, 0);
    this.sphere.setPosition(newX, newY, 1);
  }
}
// A class to describe a group of Particles //<>//
// An ArrayList is used to manage the list of Particles 

class ParticleSystem {
  ArrayList<Particle> particles;
  PVector origin;
  float lifespan;

  ParticleSystem(PVector position) {
    origin = position.copy();
    particles = new ArrayList<Particle>();
    lifespan = feedbackDly;
    println("lifespan is " + lifespan);
  }

  public void addParticle() {
    if(this.lifespan > 0 ){
      println("Carmelo piantala con 'sti bonghi " + lifespan);
      particles.add(new Particle(origin));
      lifespan -= 0.5f;
    }
  }

  public void run() {
    for (int i = particles.size()-1; i >= 0; i--) {
      Particle p = particles.get(i);
      p.run();
      if (p.isDead()) {
        particles.remove(i);
      }
    }
  }
}


// A simple Particle class

class Particle {
  PVector position;
  PVector velocity;
  PVector acceleration;
  float lifespan;

  Particle(PVector l) {
    acceleration = new PVector(0, 0.1f*timeDly/100);
    velocity = new PVector(random(-1, 1), random(-2, 0));
    position = l.copy();
    lifespan = hiPassDly;
  }

  public void run() {
    update();
    display();
  }

  // Method to update position
  public void update() {
    velocity.add(acceleration);
    position.add(velocity);
    lifespan -= 1.0f;
  }

  // Method to display
  public void display() {
    stroke(0, lifespan);
    fill(255, 0, 0, lifespan);
    ellipse(position.x, position.y, 8, 8);
    println("Drawing the ellipse");
  }

  // Is the particle still useful?
  public boolean isDead() {
    if (lifespan < 0.0f) {
      return true;
    } else {
      return false;
    }
  }
}
class Preset {

  private String name;
  private boolean susPedal;
  private Date creationDate;
  private float mod;
  private float modRate;
  private int cutoffFil;
  private float atckTime;
  private float dcyTime;
  private float susAmp;
  private float relTime;
  private float susAmpEG;
  private float atckTimeEG;
  private float dcyTimeEG;
  private float relTimeEG;
  private boolean poly;
  private float intEG;
  private float hiPassDly;
  private float timeDly;
  private float feedbackDly;
  private boolean isActiveDly;

  Preset (String name, Date creationDate, boolean susPedal, float mod, float modRate, int cutoffFil, float[] envTimes, float ampSus,
  float susAmpEG, float atckTimeEG, float dcyTimeEG, float relTimeEG, Boolean poly, float intEG, float hiPassDly, float timeDly, float feedbackDly, boolean isActiveDly) {
    this.name = name;
    this.susPedal = susPedal;
    this.creationDate = creationDate;
    this.mod = mod;
    this.modRate = modRate;
    this.cutoffFil = cutoffFil;
    this.atckTime = envTimes[0];
    this.dcyTime = envTimes[1];
    this.relTime = envTimes[3];
    this.susAmp = ampSus;
    this.susAmpEG = susAmpEG;
    this.atckTimeEG = atckTimeEG;
    this.dcyTimeEG = dcyTimeEG;
    this.relTimeEG = relTimeEG;
    this.poly = poly;
    this.intEG = intEG;
    this.hiPassDly = hiPassDly;
    this.timeDly = timeDly;
    this.feedbackDly = feedbackDly;
    this.isActiveDly = isActiveDly;
  }

  Preset() {
    this.name = "Name";
    this.susPedal = false;
    this.creationDate = Calendar.getInstance().getTime();
    this.mod = 0;
    this.modRate = 0;
    this.cutoffFil = 0;
    this.atckTime = 0;
    this.dcyTime = 0;
    this.relTime = 0;
    this.susAmp = 0;
    this.susAmpEG = 0;
    this.atckTimeEG = 0;
    this.dcyTimeEG = 0;
    this.relTimeEG = 0;
    this.poly = false;
    this.intEG = 0;
    this.hiPassDly = 0;
    this.timeDly = 0;
    this.feedbackDly = 0;
    this.isActiveDly = false;
  }

  public void setPresetName(String name) {
    this.name = name;
  }

  public void setSusPedal(boolean susPedal) {
    this.susPedal = susPedal;
  }
  public void setCreationDate(Date creationDate) {
    this.creationDate = creationDate;
  }
  public void setMod(float modulation) {
    this.mod = modulation;
  }
  public void setModRate(float modulationRate) {
    this.modRate = modulationRate;
  }
  public void setCutoffFil(int cutoffFil) {
    this.cutoffFil = cutoffFil;
  }
  public void setAttack(float attackTime) {
    this.atckTime = attackTime;
  }
  public void setDecay(float dcyTime) {
    this.dcyTime = dcyTime;
  }
  public void setRelease(float releaseTime) {
    this.relTime = releaseTime;
  }
  public void setAmpSus(float ampSus) {
    this.susAmp = ampSus;
  }
  public void setAtckTimeEG(float atckTimeEG) {
    this.atckTimeEG = atckTimeEG;
  }
  public void setDcyTimeEG(float dcyTimeEG) {
    this.dcyTimeEG = dcyTimeEG;
  }
  public void setRelTimeEG(float relTimeEG) {
    this.relTimeEG = relTimeEG;
  }
  public void setSusAmpEG(float susAmpEG) {
    this.susAmpEG = susAmpEG;
  }
  public void setIntEG(float intEG) {
    this.intEG = intEG;
  }
  public void setPoly(boolean poly) {
    this.poly = poly;
  }
  public void setHiPassDly(float hiPassDly) {
    this.hiPassDly = hiPassDly;
  }
  public void setTimeDly(float timeDly) {
    this.timeDly = timeDly;
  }
  public void setFeedbackDly(float feedbackDly) {
    this.feedbackDly = feedbackDly;
  }
  public void setIsActiveDly(boolean isActiveDly) {
    this.isActiveDly = isActiveDly;
  }
  

  public String getPresetName() {
    return this.name;
  }

  public boolean getSusPedal() {
    return this.susPedal;
  }
  public Date getCreationDate() {
    return this.creationDate;
  }
  public float getMod() {
    return this.mod;
  }
  public float getModRate() {
    return this.modRate;
  }
  public int getCutoffFil() {
    return this.cutoffFil;
  }
  public float getAttack() {
    return this.atckTime;
  }
  public float getDecay() {
    return this.dcyTime;
  }
  public float getRelease() {
    return this.relTime;
  }
  public float getAmpSus() {
    return this.susAmp;
  }
  public float getAtckTimeEG() {
    return this.atckTimeEG;
  }
  public float getDcyTimeEG() {
    return this.dcyTimeEG;
  }
  public float getRelTimeEG() {
    return this.relTimeEG;
  }
  public float getSusAmpEG() {
    return this.susAmpEG;
  }
  public float getIntEG() {
    return this.intEG;
  }
  public boolean getPoly() {
    return this.poly;
  }
  public float getHiPassDly() {
    return this.hiPassDly;
  }
  public float getTimeDly() {
    return this.timeDly;
  }
  public float getFeedbackDly() {
    return this.feedbackDly;
  }
  public boolean getIsActiveDly() {
    return this.isActiveDly;
  }

  public String toString() { //Override
    String name = "Preset Name: " + this.name + "\n";
    String susPedal = "susPedal is pressed: " + Boolean.toString(this.susPedal) + "\n";
    String date = "Created on: " + this.creationDate + "\n"; 
    String modulation = "Modulation: " + this.mod + "\n"; 
    String modulationRate = "Modulation Rate: " + this.modRate + "\n"; 
    String cutoffFil = "Cutoff Filter: " + this.cutoffFil + "\n"; 
    String susAmp = "Sustain Amp: " + this.susAmp + "\n"; 
    String atckTime = "Attack Time (ms): " + this.atckTime + "\n"; 
    String dcyTime = "Decay Time (ms): " + this.dcyTime + "\n"; 
    String relTime = "Release Time (ms): " + this.relTime + "\n"; 
    String atckTimeEG = "EG Attack Time (ms): " + this.relTime + "\n"; 
    String dcyTimeEG = "EG decay Time (ms): " + this.relTime + "\n"; 
    String relTimeEG = "EG release Time (ms): " + this.relTime + "\n"; 
    String susAmpEG = "Amp sus EG: " + this.relTime + "\n"; 
    String poly = "Poly: " + Boolean.toString(this.poly) + "\n"; 
    String intEG = "EG Int: " + this.intEG + "\n"; String delay = "HiPass: " + this.hiPassDly + "\n" + 
                   "Time: " + this.timeDly + "\n" + 
                   "Feedback: " + this.feedbackDly + "\n" +
                   "isActive: " + Boolean.toString(this.isActiveDly) + "\n"; 


    return name + date + susPedal + modulation + modulationRate + cutoffFil + atckTime + dcyTime + relTime + susAmp + atckTimeEG + dcyTimeEG + relTimeEG + 
    susAmpEG + poly + intEG + delay;
  }
}
class Ramp {

  float rampValue;    // current ramp value -> che useremo per modulare i parametri grafici
  float rampStartMillis; // constructor init millisecond
  float rampDuration; // ramp duration in ms
  boolean run; // ramp trigger state
  int range; // -1 to 1 ( full ramp ) or 0 to 1 ( half ramp)
  int stepId; //0 -> attack, 1-> decay, 2 -> release
  String stepName;
  float startValue;
  float endValue;
  Note note;

  boolean filter;

  Ramp () { 
    rampDuration = 0;
    rampStartMillis = 0; 
    run = false;
    //rampValue = 0;
    range = 0;
    stepId =-1;
  } 

  Ramp (float duration, float startTime, int rampRange, int stepId, float startValue, float endValue, Note note, boolean filter) {
    rampDuration = duration; // durata della rampa
    rampStartMillis = startTime; // tempo di inizio
    run = true; 
    range = rampRange;  
    this.stepId = stepId;
    this.startValue = startValue;
    this.endValue = endValue;
    this.rampValue = startValue;
    this.note = note;
    this.filter = filter;
    //println("startValue: " + startValue);
    //println("endValue: " + endValue);
  }

  public void trigger() {
    //println("rampValue = " + (int)rampValue);
    //println("endValue = " + (int)endValue);
    // println("Step Id = " + stepId);
    if ((int)rampValue == (int)(endValue) && stepId!=2) { 
      run = false;
      endedRamp(this.note, this.filter);
    }
    if (run) {
      rampValue =  lerp(startValue, endValue, constrain((millis()-rampStartMillis)/rampDuration, 0, 1)); 
      //println("LERPAAAAAAAAAA " + rampValue +"\tfilter is"+filter);
      textSize(32);
      if (stepId==0) {
        stepName = "Attack";
      } else if (stepId==1) {
        stepName = "Decay";
      } else if (stepId ==2) {
        stepName = "Sustain";
      } else if (stepId ==3) {
        stepName = "Release";
      }
      //text("Seconds: " + (int)((millis() - startingTime)/1000) +"\nADSR Step:" +stepName , 1920/3, 1080/3);
    } else {
      //println("a");
    }
  }

  public void startRelease() {
    //endedRamp(/*"inizia release"*/1, note);
    /*chiama funzione startRelease(Note note)*/
    stepId = 2;
    endedRamp(note, this.filter);
  }
}
class Rectangle {
  private int x;
  private int y;
  private int width;
  private int height;
  private int index;

  public Rectangle(int x, int y, int width, int height, int index) {
    this.x = x;
    this.y = y;
    this.width = width;
    this.height = height;
    this.index = index;
  }

  public int getX() {
    return this.x;
  }
  public int getY() {
    return this.y;
  }
  public int getWidth() {
    return this.width;
  }
  public int getHeight() {
    return this.height;
  }
  public int getIndex() {
    return this.index;
  }
}
/*Graphical representation of the Note class. 
 It's like the View class... Contains Whatever is needed to represent graphically the notes*/

class Sphere {

  private PVector position;
  private float alfa = 0.0f;
  ParticleSystem ps;

  Sphere(float x, float y, float z) {
    this.position = new PVector(x, y, z);
  }

  //This function computes the graphical result, considering all the parameters (lfo, cutoff, pitch bend etc...)
  public void drawSphere(float rampValue, float filterRampValue, float velocity) {

    float positionY = (this.position.y - pitchBend) + modulation * sin(alfa);
    float positionX = this.position.x;
    float positionZ = this.position.z * ((rampValue/2));
    float radius;
    float stretchingScale; // pitchbend
    filterRampValueBackground = filterRampValue;

    stretchingScale = map(abs(pitchBend), 0, 64, 1, 2 );

    if (EGInt < 8 && EGInt > -6) { // se EGInt è nel range dello 0%  
      radius = map(cutOffFilter, 0.1f, 255, 5, 45);
    } else {
      radius = map(filterRampValue, 0, 255, 5, 45);
    }

    noStroke();
    fill(255, 255, 255, rampValue);  
    this.lfoEffect();

    //float radius = map(filterRampValue, 0, 255, 5, 45);

    pushMatrix();
    translate(positionX, positionY, positionZ);

    if (pitchBend >=0 ) {
      scale(1, stretchingScale, 1);
    } else {
      scale(stretchingScale, 1, 1);
    }
 
    sphere(radius); //Antonino non sa cosa vuol dire questa riga, ma il resto si
    
    popMatrix();
  }

  private void lfoEffect() {
    alfa += 0.1f * modulationRate;
  }

  public void setPosition(float x, float y, float z) {
    this.position.x = x;
    this.position.y = y;
    this.position.z = z;
  }
}
/*Antonino Code*/
/*When attack finishes this function is called and generates the decay ramp. It's also called when sustain finishes this*/
public void adsrInit() {

  times = new float[4];
  attackTimeMs = 1;
  decayTimeMs = 1000;
  releaseTimeMs = 1;
  times[0] = attackTimeMs;
  times[1] = decayTimeMs;
  times[2] = -1;
  times[3] = releaseTimeMs;

  EGTimes = new float[4];
  EGTimes[0] = attackTimeMs;
  EGTimes[1] = decayTimeMs;
  EGTimes[2] = -1;
  EGTimes[3] = releaseTimeMs;

  ampSus = 100; 
  EGAmpSus = 100;
  cutOffFilter = 255;
  EGInt = 0;
}

private void nextRamp(Note note) {

  int step = note.ramp.stepId;
  switch(step) {
  case 1:
    //println("REACHED DECAY");
    note.ramp = new Ramp(times[step], millis(), 0, step, note.adsrValues[0], note.adsrValues[1], note, false);
    break;
  case 2: 
    //println("REACHED SUSTAIN");
    break; 
  case 3:
    //println("REACHED Release");
    note.ramp = new Ramp(times[step], millis(), 0, step, note.adsrValues[1], 0, note, false);
    break;
  }

  if (step<4) {  
    startingTime = millis();
  } else if (step==4) {
    removeNote(note);
  }
}

private void removeNote(Note note) {
  note.toRemove = true;
}

public void endedRamp(Note note, boolean filter) {
  if (!filter) {
    note.ramp.stepId++;
    nextRamp(note);
  } else {
    note.filterRamp.stepId++;
    nextFilterRamp(note);
  }
}

public void startReleaseB(Note note) {
  /*crea la rampa di release per la nota*/
}

private void nextFilterRamp(Note note) {

  int stepz = note.filterRamp.stepId;
  switch(stepz) {
  case 1:
    println("FILTER REACHED DECAY");
    note.filterRamp = new Ramp(EGTimes[stepz], millis(), 0, stepz, note.filterAdsrValues[1], note.filterAdsrValues[2], note, true);
    break;
  case 2: 
    println("FILTER REACHED SUSTAIN");
    break; 
  case 3:
    println("FILTER REACHED Release 2" + note.filterAdsrValues[2] +" 3" + note.filterAdsrValues[3]);
    note.filterRamp = new Ramp(EGTimes[stepz], millis(), 0, stepz, note.filterAdsrValues[2], note.filterAdsrValues[3], note, true);
    break;
  }
}
/*End Antonino Code*/









  

MidiBus minilogue, guitar;
String minilogueBusName, guitarBusName;

//Menu global variables
ArrayList<Preset> presets;
ArrayList<Button> loadButtons;
int choice;
PImage startscreen;
PFont newFont;
int mode;
int xBtnStoreMode, yBtnStoreMode, wBtn, hBtn, xBtnLoadMode, yBtnLoadMode, xBtnPlayMode, yBtnPlayMode, xBtnBackToMenu, yBtnBackToMenu;
Button storeModeBtn, loadModeBtn, playModeBtn, backToMenuBtn, doStoreBtn;
boolean gettingUserInput = false;
final String INIT_MSG="Start typing";
String msg=INIT_MSG;
String finalMsg = "";



//MIDI CC
boolean sustainPedal = false;
ArrayList<Note> sustainedNotes;
float pitchBend = 0;
float modulation = 0;
float modulationRate = 0;
int cutOffFilter = 0;
float ampAtck;
float ampDcy;
float ampSus;
float ampRel;
float hiPassDly = 0;
float timeDly = 0;
float feedbackDly = 0;
Boolean isActiveDly = false;

//ADSR global variables
/*Antonino variables*/
float attackTimeMs;
float decayTimeMs;
float releaseTimeMs;
//int step;
float[] times;
int vel;
float startingTime;
float[] velValues;
int prevNoteVelocity = 115;
int susValue = 80;
boolean isPressed = false;
/*End Antonino variables*/

int contour;
float EGInt;
int EGIntInteger;
float[] EGTimes;
float EGAmpSus;

float filterRampValueBackground;
boolean poly;

ParticleSystem ps;
boolean drawBool = false;
/*Michele Menu's code*/

public void menuInit() {
  
  mode = 0; //Menu] 
  wBtn = 180;
  hBtn = 60;
  float centerPosition = width/2;
  final float OMOGENEOUS_COEFF = 1.5f;
  float distanceFactor = wBtn * 1.5f * OMOGENEOUS_COEFF;
  xBtnStoreMode = (int) (centerPosition  - distanceFactor );//250; //Store
  yBtnStoreMode = (int) (height * .06f);//100;
  xBtnLoadMode = (int) (centerPosition);//;600; //Load
  yBtnLoadMode = (int) (height * .06f);
  xBtnPlayMode = (int) (centerPosition  + distanceFactor); //Play
  yBtnPlayMode = (int) (height * .06f);
  xBtnBackToMenu = (int) (centerPosition - 1.2f* distanceFactor); // Back to menu
  yBtnBackToMenu = (int) (height * .06f);

  storeModeBtn = new Button(xBtnStoreMode, yBtnStoreMode, wBtn, hBtn, "Store Mode", color(255), color(0));
  loadModeBtn = new Button(xBtnLoadMode, yBtnLoadMode, wBtn, hBtn, "Load Mode", color(255), color(0));
  playModeBtn = new Button(xBtnPlayMode, yBtnPlayMode, wBtn, hBtn, "Play Mode", color(255), color(0));
  backToMenuBtn = new Button(xBtnBackToMenu, yBtnBackToMenu, wBtn, hBtn, "Back to Menu", color(255), color(0));
  
  presets = new ArrayList<Preset>();
  loadButtons = new ArrayList<Button>();
  
}

public void mousePressed() {
  
  /* Debugging Code
  float a = xBtn1 + wBtn;
  float b = xBtn2 +wBtn;
  float c = xBtn3 +wBtn;
  float d = yBtn1 + hBtn;
  println("Actual mode is: "+ mode +"mouse is pressed in position " + "x: "+mouseX +"y: "+mouseY+"\n");
  println("store button extension from x= " + xBtn1 + "to x=" + a +"from y= "+yBtn1 +"to y= "+ d +"\n");
  println("load button extension from x= " + xBtn2 + "to x=" + b +"from y= "+yBtn2 +"to y= "+ d +"\n");
  println("play button extension from x= " + xBtn3 + "to x=" + c +"from y= "+yBtn3 +"to y= "+ d +"\n");
  */

  if(mode == 0) {
      if (storeModeBtn.isPressed()){
        mode = 1; //store
      }
      else if (loadModeBtn.isPressed()){
        mode = 2; //load
      }
      else if (playModeBtn.isPressed()){
        mode = 3; //play
        loop(); //Mi accerto che torni il loop
      }
    }
    else if (mode == 1 || mode == 2 || mode == 3){
      if (backToMenuBtn.isPressed()){
        cleanScreen();
        println("Passo da 1 a 0");
        mode = 0;
      }
    }
    if(mode==1 && gettingUserInput){
      msg=INIT_MSG;
    }
    loop();
}

public void storeMode(){
  cleanScreen();
  int xStoreBtn = width/2;
  int yStoreBtn = (height/2)-150;
  
  doStoreBtn = new Button (xStoreBtn, yStoreBtn, wBtn, hBtn, "Store Preset", color(255), color(0));
  
  gettingUserInput = true;
  background(0);
  textAlign(CENTER, CENTER);
  rectMode(CENTER);
  fill(0);
  text("Store Mode", width/2, height * .05f);
  
  backToMenuBtn.showBtn();
  
  doStoreBtn.showBtn();
  
  //prevDraw();
  if(gettingUserInput){
    showInputScanning();
  }
  
  if (doStoreBtn.isPressed()){
    noLoop();
    println("Calling savePreset");
    savePreset();
  }
}

public void loadMode(){
  //prevDraw();
  
  try {
    loadPresets();
  } catch (Exception ex) {}
}

public void savePreset(){
  String name = finalMsg;
  Date actualDate = Calendar.getInstance().getTime();
  Preset actualPreset = new Preset(name, actualDate, sustainPedal, modulation, modulationRate, cutOffFilter, times, ampSus, EGAmpSus, times[0], times[1], times[3], poly, EGInt, hiPassDly, timeDly, feedbackDly, isActiveDly);
  
  loadPresetsFromFile(); //salvataggio from file to var senza grafica
  addPreset(actualPreset); //Aggiunge preset controllando se overwrite
  try{
    FileWriter fileWriter = new FileWriter("presets.txt");
    
    for(int i=0; i<presets.size(); i++){
      println("preset size is " + presets.size() + " now we are in index " + i);
      storePresetToFile(presets.get(i), fileWriter);
      println("saved preset " + presets.get(i).getPresetName());
    }
    
    fileWriter.close(); 
    println("Closed");
  } catch (IOException e) {
    // exception handling
    println("IO Exception");
  }
  loop();
}

public void loadPresets() throws Exception{ 
  noLoop();
  loadPresetsFromFile(); //<>// //<>// //<>//
  //Iterator iterator = presets.iterator();
  drawMenuPresets();
}

public int loadBtnClicked(ArrayList<Button> buttons){
  for(int i=0; i<buttons.size(); i++){
    if(buttons.get(i).isPressed()){return buttons.get(i).getIndex();}
  }
  return -1;
}

public void activatePreset(int index){
  Preset activePreset = presets.get(index);
  cutOffFilter = activePreset.getCutoffFil();
  times[0] = activePreset.getAttack();
  times[1] = activePreset.getDecay();
  times[2] = -1;
  times[3] = activePreset.getRelease();
  EGTimes[0] = activePreset.getAtckTimeEG();
  EGTimes[1] = activePreset.getDcyTimeEG();
  EGTimes[2] = -1;
  EGTimes[3] = activePreset.getRelTimeEG();
  modulationRate = activePreset.getModRate();
  modulation = activePreset.getMod();
  sustainPedal = activePreset.getSusPedal();
  ampSus = activePreset.getAmpSus();
  EGAmpSus = activePreset.getSusAmpEG();
  poly = activePreset.getPoly();
  EGInt = activePreset.getIntEG();
  hiPassDly = activePreset.getHiPassDly();
  timeDly = activePreset.getTimeDly();
  feedbackDly = activePreset.getFeedbackDly();
  isActiveDly = activePreset.getIsActiveDly();
  println(activePreset.toString());
  
  return;
}

public void addPreset (Preset presetToAdd){
  for(int i=0; i<presets.size(); i++){
    if (presets.get(i).getPresetName().equals(presetToAdd.getPresetName())){
      presets.remove(i);
      presets.add(i, presetToAdd);
      println("overwriting preset called " + presets.get(i).getPresetName());
      return;
    }  
  }
  presets.add(presetToAdd);
  println("adding new preset called " + presets.get(presets.size()-1).getPresetName());
  return;
}

public void loadPresetsFromFile(){
  File file = new File("presets.txt"); 
    try {
      BufferedReader br = new BufferedReader(new FileReader(file)); 
      Preset newPreset;
      String st;
      
      newPreset = new Preset(); 
      while ((st = br.readLine()) != null) {
        //System.out.println(st);
        //println(st.equals("sustainAmp 0.0"));
        if (st.equals("start")) {
          //println("Starting");
          newPreset = new Preset(); 
        }
        else if ((st.equals("end"))){
            //println("i'm done");
            addPreset(newPreset); //Exception
          }
        else if (st.isEmpty()){}
        else if ((st.substring(0,5)).equals("name ")){newPreset.setPresetName(st.substring(5));}
        else if ((st.substring(0,5)).equals("poly ")){newPreset.setPoly(Boolean.parseBoolean(st.substring(5)));}
        else if ((st.substring(0,5)).equals("date ")){newPreset.setCreationDate(new SimpleDateFormat("EEE MMM dd HH:mm:ss Z yyyy",  Locale.ENGLISH).parse(st.substring(5)));}
        else if ((st.substring(0,7)).equals("EG int ")){newPreset.setIntEG(Float.parseFloat(st.substring(7)));} 
        else if ((st.substring(0,10)).equals("decayTime ")){newPreset.setDecay(Float.parseFloat(st.substring(10)));}
        else if ((st.substring(0,11)).equals("modulation ")){newPreset.setMod(Float.parseFloat(st.substring(11)));}
        else if ((st.substring(0,11)).equals("attackTime ")){newPreset.setAttack(Float.parseFloat(st.substring(11)));}
        else if ((st.substring(0,11)).equals("sustainAmp ")){newPreset.setAmpSus(Float.parseFloat(st.substring(11)));}
        else if ((st.substring(0,11)).equals("time delay ")){newPreset.setTimeDly(Float.parseFloat(st.substring(11)));}
        else if ((st.substring(0,12)).equals("releaseTime ")){newPreset.setRelease(Float.parseFloat(st.substring(12)));}
        else if ((st.substring(0,13)).equals("sustainPedal ")){newPreset.setSusPedal(Boolean.parseBoolean(st.substring(13)));}
        else if ((st.substring(0,13)).equals("EG decayTime ")){newPreset.setDcyTimeEG(Float.parseFloat(st.substring(13)));}
        else if ((st.substring(0,13)).equals("cutoffFilter ")){newPreset.setCutoffFil(Integer.parseInt(st.substring(13)));}
        else if ((st.substring(0,13)).equals("hipass delay ")){newPreset.setHiPassDly(Float.parseFloat(st.substring(13)));}
        else if ((st.substring(0,14)).equals("EG attackTime ")){newPreset.setAtckTimeEG(Float.parseFloat(st.substring(14)));}
        else if ((st.substring(0,14)).equals("EG sustainAmp ")){newPreset.setSusAmpEG(Float.parseFloat(st.substring(14)));}
        else if ((st.substring(0,15)).equals("EG releaseTime ")){newPreset.setRelTimeEG(Float.parseFloat(st.substring(15)));}
        else if ((st.substring(0,15)).equals("modulationRate ")){newPreset.setModRate(Float.parseFloat(st.substring(15)));}
        else if ((st.substring(0,15)).equals("feedback delay ")){newPreset.setFeedbackDly(Float.parseFloat(st.substring(15)));}
        else if ((st.substring(0,15)).equals("isActive delay ")){newPreset.setIsActiveDly(Boolean.parseBoolean(st.substring(15)));}
        else {System.out.println("Substring is " + st + " Error");}
      }
      br.close();
    } catch (Exception e) {
    // exception handling
      println(e);
  }
}

public void drawMenuPresets(){
  int aListSize = presets.size();
  int xBox, yBox, wBox, hBox, leftMarginNames, upperMarginNames, hLine, xLoadBtn, yLoadBtn, wLoadBtn, hLoadBtn;
  //println("aListSize is " + aListSize);
  xBox = width/2;
  yBox = 200;
  wBox = 450;
  hBox = aListSize*50;
  leftMarginNames = 20;
  upperMarginNames = 30;
  hLine = 30;
  xLoadBtn = xBox+wBox-100;
  yLoadBtn = ((yBox+upperMarginNames));
  wLoadBtn = 80;
  hLoadBtn = 40;
  
  background(0);
  fill(255);
  text("Load Mode", width/2, height * .06f); //titolo
  fill(255);
  
  backToMenuBtn.showBtn();
  
  fill(255);
  rect(xBox, yBox, wBox, hBox); //box contenente i preset da salvare

  for(int i=0; i<aListSize; i++){
    Button newBtn = new Button(xLoadBtn, (yLoadBtn + (i*hLine)), wLoadBtn, hLoadBtn, "Load", color(255), color(0));
    newBtn.setIndex(i);
    loadButtons.add(newBtn);
    newBtn.showBtn();
    
    fill(0);
    text((presets.get(i).getPresetName() + "\t  " + presets.get(i).getCreationDate()), xBox, (yBox + (i*hLine)));
    fill(255);
    rect(xLoadBtn, (yLoadBtn + (i*hLine)), wLoadBtn, hLoadBtn);
 
  }
  if(mousePressed){
    if(loadBtnClicked(loadButtons)!= -1){
      activatePreset(loadBtnClicked(loadButtons));
    }  
  }
  //while (iterator.hasNext()){}
    //println(iterator.next().toString());
  //}
}

public void storePresetToFile (Preset actualPreset, FileWriter fileWriter){
  try{
    fileWriter.write("start\n");
    fileWriter.write("name " + actualPreset.getPresetName() + "\n");
    fileWriter.write("date " + actualPreset.getCreationDate() +"\n");
    fileWriter.write("sustainPedal " + actualPreset.getSusPedal() + "\n");
    fileWriter.write("modulation " + actualPreset.getMod() + "\n");
    fileWriter.write("modulationRate " + actualPreset.getModRate() + "\n");
    fileWriter.write("cutoffFilter " + actualPreset.getCutoffFil() + "\n");
    fileWriter.write("attackTime " + actualPreset.getAttack() + "\n");
    fileWriter.write("decayTime " + actualPreset.getDecay() + "\n");
    fileWriter.write("sustainAmp " + actualPreset.getAmpSus() + "\n");
    fileWriter.write("releaseTime " + actualPreset.getRelease() + "\n");
    fileWriter.write("EG attackTime " + actualPreset.getAtckTimeEG() + "\n");
    fileWriter.write("EG decayTime " + actualPreset.getDcyTimeEG() + "\n");
    fileWriter.write("EG sustainAmp " + actualPreset.getSusAmpEG() + "\n");
    fileWriter.write("EG releaseTime " + actualPreset.getRelTimeEG() + "\n");
    fileWriter.write("EG int " + actualPreset.getIntEG() + "\n");
    fileWriter.write("poly " + actualPreset.getPoly() + "\n");
    fileWriter.write("hipass delay " + actualPreset.getHiPassDly() + "\n");
    fileWriter.write("time delay " + actualPreset.getTimeDly() + "\n");
    fileWriter.write("feedback delay " + actualPreset.getFeedbackDly() + "\n");
    fileWriter.write("isActive delay " + actualPreset.getIsActiveDly() + "\n");
    fileWriter.write("end\n");
  } catch (IOException e) {
      // exception handling
      println("IO Exception");
    }
}

public void showInputScanning(){
  fill(0,230,25);
  text(msg, width/2, height/2);
  
  fill(0,250,0);
  text("Mouse click to reset message, Return to set the name, Click \"Store\" to Store", width/2, (height/2)+80);
}

public void scanInput(){
  if ( (key>='a' && key<='z') ||
    (key>='A' && key<='Z') ||
    (key>='0' && key<='9') 
    ) {
    msg+=key;
  }
  if (key == ENTER){
    finalMsg = msg;
    msg = "Got it!";
    gettingUserInput = false;
    println("Final Message is " +finalMsg + ".");
  }
}

public void keyPressed(){
  if (gettingUserInput){
    if (msg.equals(INIT_MSG)) {
      msg="";
    }
    scanInput();
  }
}
private ArrayList<Note> tempNotes;
private boolean alreadyInTempChord;

public void midiInit() {

  MidiBus.list(); // List all our MIDI devices
  minilogue = new MidiBus(this, 4, 1);// Connect to one of the devices
  minilogueBusName = minilogue.getBusName();
  //guitar = new MidiBus(this, 4, 5);// Connect to one of the devices
  //guitarBusName = guitar.getBusName();
  tempNotes = new ArrayList<Note>();
  alreadyInTempChord = false;
}

//NOTE ON
public void noteOn(int channel, int pitch, int velocity) {

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
public void noteOff(int channel, int pitch, int velocity) {

  println("Note OFF");

  for (int i=0; i<tempNotes.size(); i++ ) {
    if (tempNotes.get(i).getPitch() == pitch) {
      tempNotes.get(i).ramp.startRelease(); //per rimuovere la nota dopo la fine del release
      tempNotes.get(i).filterRamp.startRelease();
    }
  }
}


//CONTROL CHANGE
public void controllerChange(int channel, int number, int value, long timestamp, java.lang.String bus_name) {

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
      modulationRate = mapLog(value, 0, 127, 0.1f, 97); // minilogue "rate" knob
      break;
  
    case 26: //!!!!!!!! MINILOGUE HAS INT VALUE AS MODULATION WHEEL ---> 0-127
      modulation = mapLog(value, 0, 127, 1, 100); // or mapLog?
      break;
  
    case 43:
      cutOffFilter = (int)(mapLog(value, 0, 127, 0.1f, 255)); //cut off
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

public void midiMessage(MidiMessage message, long timestamp, String bus_name) { // You can also use midiMessage(MidiMessage message, long timestamp, String bus_name)
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
    if((int)(message.getMessage()[0] & 0xFF)==192){
      if ((int)(message.getMessage()[1] & 0xFF)==0) println("Guitar pres Clean");
      if ((int)(message.getMessage()[1] & 0xFF)==1) println("Guitar pres Modulation");
      if ((int)(message.getMessage()[1] & 0xFF)==2) println("Guitar pres Overdrive");
      if ((int)(message.getMessage()[1] & 0xFF)==3) println("Guitar pres Crunch");
      if ((int)(message.getMessage()[1] & 0xFF)==4) println("Guitar pres Lead");
    }
    
  }
}

private int voiceLimiter() {
  if (poly) return 4;
  return 1;
}

// LOG MAPPING (SYNTH KNOB)
public float mapLog(float value, float start1, float stop1, float start2, float stop2) { // https://forum.processing.org/two/discussion/18417/exponential-map-function
  start2 = log(start2);
  stop2 = log(stop2);

  float outgoing =
    exp(start2 + (stop2 - start2) * ((value - start1) / (stop1 - start1)));

  String badness = null;
  if (outgoing != outgoing) {
    badness = "NaN (not a number)";
  } else if (outgoing == Float.NEGATIVE_INFINITY ||
    outgoing == Float.POSITIVE_INFINITY) {
    badness = "infinity";
  }
  if (badness != null) {
    final String msg =
      String.format("map(%s, %s, %s, %s, %s) called, which returns %s", 
      nf(value), nf(start1), nf(stop1), 
      nf(start2), nf(stop2), badness);
    PGraphics.showWarning(msg);
  }
  return outgoing;
}

public void removeNoteByPitch(int pitch) {
  for (int c = 0; c<tempNotes.size(); c-=-1) {
    if (tempNotes.get(c).getPitch()==pitch) {
      tempNotes.remove(c);
    }
  }
}
  public void settings() {  fullScreen(P3D); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "visualMidi" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
