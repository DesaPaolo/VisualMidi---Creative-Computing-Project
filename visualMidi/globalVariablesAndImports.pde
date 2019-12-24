import themidibus.* ;
import java.util.ArrayList;
import javax.sound.midi.*;
import de.looksgood.ani.*;
import de.looksgood.ani.easing.*;
import java.lang.Math;


//MidiBus launchPad;
MidiBus minilogue;
//MidiBus loopMIDI;

//ArrayList<Note> tempNotes;
boolean sustainPedal = false;
ArrayList<Note> sustainedNotes;

float pitchBend = 0;
float modulation = 0;
float modulationRate = 0;
Note prevNote;
int cutOffFilter = 0;
float ampAtck;
float ampDcy;
float ampSus;
float ampRel;
float opacity;
float transparency = 0;



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





//Ani graphics 
float duration = 0.1; //this variable could be modulate by MIDI Portamento parameter
PVector target;
Easing[] easings = { 
  Ani.LINEAR, Ani.EXPO_IN,
};
int index = 0; // 0 -> linear glide, 1 -> exp glide
