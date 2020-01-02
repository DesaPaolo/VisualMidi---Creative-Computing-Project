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



MidiBus launchPad;
MidiBus minilogue;
MidiBus loopMIDI;
int instrumentType; //polyphonic or monophonic

ArrayList<Note> tempNotes;
ArrayList<Preset> presets = new ArrayList<Preset>();;
boolean sustainPedal = false;
ArrayList<Note> sustainedNotes;

float pitchBend = 0;
float modulation = 0;
float alfa = 0.0; //---->init modulation rate value
float modulationRate = 0;
Note prevNote;
float cutOffFilter = 0;
float ampAtck;
float ampDcy;
float ampSus;
float ampRel;
float opacity;



/*Antonino variables*/
Ramp ramp;
float attackTimeMs;
float decayTimeMs;
float releaseTimeMs;
int step;
int vel;
float startingTime;
int[] velValues;
int prevNoteVelocity = 115;
int susValue = 80;
boolean isPressed = false;
/*End Antonino variables*/





//Ani graphics 
float duration = 0.1; //this variable could be modulate by MIDI Portamento parameter
PVector target;
Easing[] easings = { 
  Ani.LINEAR, Ani.EXPO_IN,
};
int index = 0; // 0 -> linear glide, 1 -> exp glide
