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
import processing.serial.*;
import uk.co.xfactorylibrarians.coremidi4j.*;

MidiBus minilogue, guitar;
String minilogueBusName, guitarBusName;
//Menu global variables
ArrayList<Preset> presets;
ArrayList<GuitarProgram> guitarPrograms = new ArrayList();
ArrayList<Button> loadButtons;
int choice;
PImage startscreen;
PFont newFont;
int mode;
int xBtnStoreMode, yBtnStoreMode, wBtn, hBtn, xBtnLoadMode, yBtnLoadMode, xBtnPlayMode, yBtnPlayMode, xBtnBackToMenu, yBtnBackToMenu;
Button storeModeBtn, loadModeBtn, playModeBtn, backToMenuBtn, doStoreBtn, deviceModeBtn, programStoreModeBtn;
ArrayList<String> overdriveValues;
ArrayList<String> ampValues;
ArrayList<String> eqValues;
ArrayList<String> modulationValues;
ArrayList<String> reverbValues;
boolean gettingUserInput = false;
final String INIT_MSG="Start typing";
String msg=INIT_MSG;
String finalMsg = "";
ArrayList<Button> deviceButtons = new ArrayList();
LoadMenu loadMenu;
DeviceMenu deviceMenu;
GuitarMenu guitarMenu;
ProgramStoreMenu programStoreMenu;
Object context;
int currentInput=-2;
//MIDI CC
boolean sustainPedal = false;
ArrayList<Note> sustainedNotes;
float pitchBend = 0;
float modulation = 0;
float modulationRate = 0;
float cutOffFilter = 0;
float ampAtck;
float ampDcy;
float ampSus;
float ampRel;
float hiPassDly = 0;
float timeDly = 0;
float feedbackDly = 0;
Boolean isActiveDly = false;
int maxDlyTime = 100;
float maxFeedbackDly = 45;
int id = -1;
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

/*Guitar variables*/
String gtrAmp = "clean";
String gtrOverdrive = "none";
String gtrModulation = "none";
String gtrEq = "normal";
String gtrReverb = "medium";
int currentProgramIndex;
ArrayList<KemperStomp> kemperStomps = new ArrayList<KemperStomp>();

boolean drawBool = false;
StarField starField;
//int warpSpeed = 10;
