private Ramp attack;
private Ramp decay;
private Ramp release;

private float attackTimeMs;
private float decayTimeMs;
private float releaseTimeMs;


private float startingTime;

void setup()
{
  
 size (1920,1080);
 background(0);
 
 attack = new Ramp();
 attackTimeMs = 3000;
 decayTimeMs = 2000;
 releaseTimeMs = 4000;
 
}

void draw()
{
 
  noStroke();
  fill(0);
  rect(0,0,width,height);
  fill (255);
  attack.trigger();
  stroke(120);
  //line (0, height, width * attack.rampValue, height - (height * attack.rampValue));
  ellipse(1920/2, 1080/2, 50, 50);
}

void mousePressed() {
  attack = new Ramp(/*duration = */attackTimeMs, /*start time = */millis(), /*ramp range = */0);
  startingTime = millis();
}


/*When attack finishes this function is called and generates the decay ramp. It's
also called when sustain finishes this*/

private void nextRamp() {
  
}
