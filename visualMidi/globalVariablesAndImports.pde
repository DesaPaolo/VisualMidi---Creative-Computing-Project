import themidibus.* ;
import java.util.ArrayList;
import javax.sound.midi.*;
import de.looksgood.ani.*;
import de.looksgood.ani.easing.*;
import java.lang.Math;
import java.io.*;
import java.util.*;
import java.lang.*;
import java.text.SimpleDateFormat;  

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
float maximumDelayTime = 100;
float maximumFeedBack = 120;

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
