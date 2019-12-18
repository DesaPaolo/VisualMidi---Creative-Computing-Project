//private Ramp attack;
//private Ramp decay;
//private Ramp release;
private Ramp ramp;

private float attackTimeMs;
private float decayTimeMs;
private float releaseTimeMs;
private int step;
private float[] times;


private float startingTime;

void setup()
{
  
 size (1920,1080);
 background(0);
 step = 0;
 ramp = new Ramp();
 attackTimeMs = 3000;
 decayTimeMs = 2000;
 releaseTimeMs = 4000;
 times = new float[3];
 times[0] = attackTimeMs;
 times[1] = decayTimeMs;
 times[2] = releaseTimeMs;

}

void draw()
{
 
  noStroke();
  fill(0);
  rect(0,0,width,height);
  fill (255);
  ramp.trigger();
  stroke(120);
  ellipse(1920/2, 1080/2, 50 * ramp.rampValue, 50*ramp.rampValue);
}

void mousePressed() {
  ramp = new Ramp(/*duration = */times[step], /*start time = */millis(), /*ramp range = */0, /*attack step ID is 0*/ step);
  startingTime = millis();
}


/*When attack finishes this function is called and generates the decay ramp. It's also called when sustain finishes this*/
private void nextRamp() {
  
  if(step<3) {  
    ramp = new Ramp(times[step], millis(), 0, step);
    startingTime = millis();
  }
  
}

public void endedRamp() {
  step++;
  //step= step%3;
  nextRamp();
}
