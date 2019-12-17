Ramp r1, r2;

void setup()
{
 size (300,300);
 r1 = new Ramp();
 r2 = new Ramp();
}

void draw()
{
 
  noStroke();
  fill (255,20); rect(0,0,width,height);
  fill (120);
  r1.trigger();
  r2.trigger();
  stroke(120 - (120* r1.rampValue));
  strokeCap(PROJECT);
  strokeWeight (10 * r1.rampValue);
  line (0, height, width * r1.rampValue, height - (height * r1.rampValue));

}

void mousePressed() {
  //millis() -> numero di ms passati dall'inizio del programma
  //random(20000) -> numero casuale, al massimo 20000
  r1 = new Ramp(/*duration = */random(20000), /*start time = */millis(), /*ramp range = */0);
}



class Ramp {
  float rampValue;    // current ramp value -> che useremo per modulare i parametri grafici
  float rampStartMillis; // constructor init millisecond
  float rampDuration; // ramp duration in ms
  boolean run; // ramp trigger state
  int range; // -1 to 1 ( full ramp ) or 0 to 1 ( half ramp)
/*
  Ramp () { 
    rampDuration = 0;
    rampStartMillis = 0; 
    run = false;
    rampValue = 0;
    range = 0;
  } 
*/
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
