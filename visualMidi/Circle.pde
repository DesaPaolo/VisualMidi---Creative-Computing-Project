/*Graphical representation of the Note class. 
It's like the View class... Contains Whatever is needed to represent graphically the notes*/

class Circle {
  
  private float horizontalDiameter;
  private float verticalDiameter;
  private color innerColor;
  private PVector position;
  private float transparency;
  private float alfa = 0.0;
  
  Circle(float diameter, color innerColor, float transparency, float x, float y) {
    this.horizontalDiameter = diameter;
    this.verticalDiameter = diameter;
    this.innerColor = innerColor;
    this.position = new PVector(x, y);
    this.transparency = transparency;
  }

  public void changeSize(float diameter) {
    this.horizontalDiameter = diameter;
    this.verticalDiameter = diameter;
  }
  
  public void changeSize(float diameterX, float diameterY) {
    this.horizontalDiameter = diameterX;
    this.verticalDiameter = diameterY;
  }
  
  //This function computes the graphical result, considering all the parameters (lfo, cutoff, pitch bend etc...)
  public void drawCircle() {
    noStroke();
    fill(innerColor, 15+transparency);
    this.lfoEffect();
    float verticalDiameter = this.verticalDiameter + abs(pitchBend) + cutOffFilter;
    float horizontalDiameter = this.horizontalDiameter +cutOffFilter;
    float positionY = (this.position.y - pitchBend) + modulation*sin(alfa);
    float positionX = this.position.x;
    ellipse(positionX, positionY, horizontalDiameter, verticalDiameter);  
  }
  
  void animateNoteOn() {
    Ani.to(position, duration, "x", this.position.x, easings[index]);
    Ani.to(position, duration, "y", this.position.y, easings[index]);
  }
  
  void animateNoteOff() {
    Ani.to(position, duration, "x", this.position.x, easings[index]);
    Ani.to(position, duration, "y", this.position.y, easings[index]);
  }
  
  public void setColor(color c) {
    this.innerColor = c;
  } 
  
  private void lfoEffect() {
    alfa += 0.1 * modulationRate;
  }
  
  
}
