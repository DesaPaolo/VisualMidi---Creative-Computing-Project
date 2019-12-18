Ramp attack;
float attackTimeMs;

void setup()
{
 size (1920,1080);
 background(0);
 attack = new Ramp();
 attackTimeMs = 3000;
}

void draw()
{
 
  noStroke();
  fill(0);
  rect(0,0,width,height);
  fill (255);
  attack.trigger();
  stroke(120 - (120* attack.rampValue));
  //strokeCap(PROJECT);
  strokeWeight (10 * attack.rampValue);
  line (0, height, width * attack.rampValue, height - (height * attack.rampValue));

}

void mousePressed() {
  //millis() -> numero di ms passati dall'inizio del programma
  //random(20000) -> numero casuale, al massimo 20000
  attack = new Ramp(/*duration = */attackTimeMs, /*start time = */millis(), /*ramp range = */0);
}



class Ramp {
  float rampValue;    // current ramp value -> che useremo per modulare i parametri grafici
  float rampStartMillis; // constructor init millisecond
  float rampDuration; // ramp duration in ms
  boolean run; // ramp trigger state
  int range; // -1 to 1 ( full ramp ) or 0 to 1 ( half ramp)

  Ramp () { 
    rampDuration = 0;
    rampStartMillis = 0; 
    run = false;
    rampValue = 0;
    range = 0;
  } 

  Ramp (float duration, float startTime, int rampRange) {
    rampDuration = duration; // durata della rampa
    rampStartMillis = startTime; // tempo di inizio
    run = true; 
    range = rampRange;  
}
    
void trigger() {
  if (rampValue == 1) { run = false; }
    if (run) {
      rampValue =  lerp(range,1, constrain((millis()-rampStartMillis)/rampDuration, 0, 1)); 
      /*Constrain(): costringe il valore [millis()-rampStartMillis)/rampDuration] 
      a rimanere tra gli ultimi due argomenti che hanno come valori 0 ed 1 in tal caso*/
      
      /*lerp():  calcola un numero tra due numeri specifici: range ed 1 in tal caso
                 il terzo parametro e' la quantita' da interpolare tra i due valori. Se e' 0.5 e' a meta' tra range ed 1*/
      //per generare rampa logaritmica basta usare funzione log con argomento il rampValue.
      // Dunque si puo' trovare anche la funzione esponenziale.
    }   
  }   
}
