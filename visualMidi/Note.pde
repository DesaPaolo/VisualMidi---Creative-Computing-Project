class Note {

  Sphere sphere; //3D
  private int pitch;
  private float velocity;
  boolean toRemove = false;
    
  float[] adsrValues;
  float[] filterAdsrValues;
  Ramp ramp;
  Ramp filterRamp;

  Note(int pitch, int velocity) {
    this.pitch = pitch;
    this.velocity = velocity;
    float x = map(this.pitch, 21, 108, 0, width);
    float y = map(this.pitch, 21, 108, height, 0);
    float z = 1;
    this.velocity = map(this.velocity, 0, 127, 0, 255);
    this.sphere = new Sphere(x, y, z);
    this.adsrValues = new float[3];
    this.filterAdsrValues = new float[3];
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
    this.sphere.drawSphere(this.ramp.rampValue, this.filterRamp.rampValue, this.velocity);
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
    this.ramp = new Ramp(times[0],millis(),0,0,0,this.adsrValues[0],this, false);
    println("AttackValueInAmplitude "+this.adsrValues[0]+ " is reached after " + times[0] + "ms");
    println("SustainValueInAmplitude "+this.adsrValues[1]+ " is reached after " + times[1] + "ms");
    this.filterAdsrValues[0] = EGInt;//is like the cutoff frequency, from 0 to 255
    this.filterAdsrValues[1] = EGInt * ((float)EGAmpSus/100);
    this.filterAdsrValues[2] = cutOffFilter;
    //parto dal cutoff value, arrivo fino all'eg int. Poi mi fermo in sustain nel EG int scalato 
    //per il valore percentuale di sustain, e nel release torno al valore di cutoff
    this.filterRamp = new Ramp(EGTimes[0],millis(),0,0, cutOffFilter, this.filterAdsrValues[0], this, true);


  }
      
}
