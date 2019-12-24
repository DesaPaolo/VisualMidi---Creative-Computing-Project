class Note {

  //Circle circle; //2D
  Sphere sphere; //3D
  private int pitch;
  private int velocity;
  Ramp ramp;


  Note(int pitch, int velocity) {
    this.pitch = pitch;
    this.velocity = velocity;
    float x = map(this.pitch, 21, 108, 0, width);
    float y = map(this.pitch, 21, 108, height, 0);
    
    this.sphere = new Sphere(x, y);
  }

  int getPitch() {
    return this.pitch;
  }

  int getVelocity() {
    return this.velocity;
  }

  void setVelocity(int newVelocity) {
    this.velocity = newVelocity;
  }
  
  //Update the view, after the model has changed
  public void update() {
    this.sphere.drawSphere(this.ramp);
  }
  public void noteOnEffect() {
    //this.circle.animateNoteOn();
  }
  
  public void noteOffEffect() {
    //this.circle.animateNoteOff();    
  }
  
  public void initAdsrRamp(float duration, float startTime, int rampRange, int stepId, float startValue, float endValue) {
    this.ramp = new Ramp(duration,startTime,rampRange,stepId,startValue,endValue, this);
    velValues = new float[3];
    velValues[0] = transparency;
    velValues[1] = transparency * ((float)ampSus/100);
  }
      
}
