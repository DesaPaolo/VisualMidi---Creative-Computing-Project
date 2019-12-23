/*Graphical representation of the Note class. It's like the View class... Contains Whatever is needed to represent graphically the notes*/

class Circle {
  
  private float horizontalDiameter;
  private float verticalDiameter;
  private color innerColor;
  private PVector position;
  //private PVector prevPosition;
  private float transparency;
  
  Circle(float diameter, color innerColor, float transparency, float x, float y) {
    this.horizontalDiameter = diameter;
    this.verticalDiameter = diameter;
    this.innerColor = innerColor;
    this.position = new PVector(x, y);
    //this.prevPosition = position;
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
  
  public void drawCircle() {
    noStroke();
    fill(innerColor, 15+transparency);
    float verticalDiameter = 20 + abs(pitchBend) + cutOffFilter;
    ellipse(this.position.x, (this.position.y -pitchBend)+modulation*sin(alfa), this.horizontalDiameter +cutOffFilter, verticalDiameter);  
  }
  
  public void animateNoteOn() {
    Ani.to(position, duration, "x", this.position.x, easings[index]);
    Ani.to(position, duration, "y", this.position.y, easings[index]);
 
  }
  
  public void animateNoteOff() {
    Ani.to(position, duration, "x", this.position.x, easings[index]);
    Ani.to(position, duration, "y", this.position.y, easings[index]);
  }
  
  public void setColor(color c) {
    this.innerColor = c;
  } 
  
}
