/**/
class Note {

  Circle circle;
  private int pitch;
  private int velocity;

  Note(int pitch, int velocity) {
    this.pitch = pitch;
    this.velocity = velocity;
    float x = map(this.pitch, 21, 108, -900, width + 750);
    float y = map(this.pitch, 21, 108, height + 500, -400);
    color c = color(255,0,0);
    float transparency = map (this.velocity, 0, 127, 0, 255);
    this.circle = new Circle(20+cutOffFilter, c,transparency, x, y);
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
    lfoEffect(this);
    pitchSlideEffect(this);
    cutOffEffect(this);
    this.circle.drawCircle();
  }
     
}
 
