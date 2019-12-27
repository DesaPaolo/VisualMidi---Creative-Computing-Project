class Note {

  Sphere sphere; //3D
  private int pitch;
  private float velocity;
  boolean toRemove = false;
  
  private float velocityValue;
  float[] adsrValues;
  
  Ramp ramp;

  Note(int pitch, int velocity) {
    this.pitch = pitch;
    this.velocity = velocity;
    float x = map(this.pitch, 21, 108, 0, width);
    float y = map(this.pitch, 21, 108, height, 0);
    float z = 1;
    this.velocity = map(this.velocity, 0, 127, 0, 255);
    this.sphere = new Sphere(x, y, z);
    this.adsrValues = new float[3];
  }

  int getPitch() {
    return this.pitch;
  }

  float getVelocity() {
    return this.velocity;
  }

  void setVelocity(float newVelocity) {
    this.velocity = newVelocity;
  }
  
  //Update the view, after the model has changed
  public void update() {
    if(toRemove) tempNotes.remove(ramp.index);
    this.sphere.drawSphere(this.ramp.rampValue, this.velocity);
  }
  public void noteOnEffect() {
    this.initAdsrRamp();
    //this.circle.animateNoteOn();
  }
  
  public void noteOffEffect() {
    //this.circle.animateNoteOff();    
  }
  
  private void initAdsrRamp() {
    this.adsrValues[0] = 255;
    this.adsrValues[1] = 255 * ((float)ampSus/100);
    this.ramp = new Ramp(times[0],millis(),0,0,0,this.adsrValues[0],this);
    println("AttackValueInAmplitude "+this.adsrValues[0]+ " is reached after " + times[0] + "ms");
    println("SustainValueInAmplitude "+this.adsrValues[1]+ " is reached after " + times[1] + "ms");
  }
      
}
