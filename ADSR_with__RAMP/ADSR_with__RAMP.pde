private Ramp ramp;

private float attackTimeMs;
private float decayTimeMs;
private float releaseTimeMs;
private int step;
private float[] times;
private int vel;
private float startingTime;
private int[] velValues;
private int prevNoteVelocity = 115;
private int susValue = 80;

void setup()
{
 size (1920,1080);
 background(0);
 step = 0;
 ramp = new Ramp();
 attackTimeMs = 5000;
 decayTimeMs = 3000;
 releaseTimeMs = 4000;
 times = new float[3];
 times[0] = attackTimeMs;
 times[1] = decayTimeMs;
 times[2] = releaseTimeMs;
 velValues = new int[3];
 velValues[0] = (int)map(prevNoteVelocity, 0, 127, 0, 255);
 velValues[1] = (int)map(susValue, 0, 127, 0, 255);
 velValues[2] = velValues[1];
 
}

void draw() //x*velValues[1] = velValues[0] -> x = velValues[0] / velValues[1]
{
  noStroke();
  fill(0);
  rect(0,0,width,height);
  fill (255,255,255, ramp.rampValue);
  ramp.trigger();
  stroke(120);
  ellipse(1920/2, 1080/2, 100 * ramp.rampValue, 100*ramp.rampValue);
}

void mousePressed() {
  ramp = new Ramp(/*duration = */times[step], /*start time = */millis(), /*ramp range = */0, /*attack step ID is 0*/ step, 0, velValues[0]);
  startingTime = millis();
}


/*When attack finishes this function is called and generates the decay ramp. It's also called when sustain finishes this*/
private void nextRamp() {
  
  switch(step){
    case 1: 
      ramp = new Ramp(times[step], millis(), 0, step, velValues[0], velValues[1]);
      break;
    case 2:
      ramp = new Ramp(times[step], millis(), 0, step, velValues[1], 0);
      break;
  }
  
  if(step<3) {  
    startingTime = millis();
  }
  
}

public void endedRamp() {
  step++;
  //step= step%3;
  nextRamp();
}
