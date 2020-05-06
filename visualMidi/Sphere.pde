/**
Graphical representation of the Note class
*/

public class Sphere {

  private PVector position;
  private float alfa = 0.0;
  ParticleSystem ps;
  float radius;
  color c = color(255, 255, 255);
  int p = 0;
  private PVector origin;
  Spiral spiral;

  /**
  Class constructor
  @param x x-axis position
  @param y y-axis position
  @param z z-axis position
  */
  Sphere(float x, float y, float z) {
    this.position = new PVector(x, y, z);
    this.origin = this.position.copy();
    this.c = applyEq();
    this.spiral = new Spiral(this.origin.copy(), this.c);
  }

  /**
  This function computes the graphical result, considering all the parameters (lfo, cutoff, pitch bend etc...)
  @param rampValue value of the ADSR amplitude
  @param filterRampValue value of the filter cutorr ramp value
  @param velocity midi velocity of the note associated to the sphere
  */
  public void drawSphere(float rampValue, float filterRampValue, float velocity) {

    float positionY = (this.position.y - pitchBend) + modulation * cos(alfa + PI);
    float positionX = this.position.x;
    float positionZ = this.position.z * ((rampValue/2));
    float stretchingScale; // pitchbend
    filterRampValueBackground = filterRampValue;

    stretchingScale = map(abs(pitchBend), 0, 64, 1, 2 );

    if (EGInt < 8 && EGInt > -6) { // se EGInt è nel range dello 0%  
      radius = map(cutOffFilter, 0, 100, 1, 35);
    } else {
      radius = map(filterRampValue, 0, 100, 1, 35); //!!!!!!
    }

    noStroke();
    
    fill(this.c, rampValue);  
    this.lfoEffect();

    //float radius = map(filterRampValue, 0, 255, 5, 45);

    pushMatrix();
    //rotateX(radians(360*sin(p)));
    //rotateY(cos(p));
    //p+=0.2;
    
    translate(positionX, positionY, positionZ);

    if (pitchBend >=0 ) {
      scale(1, stretchingScale, 1);
    } else {
      scale(stretchingScale, 1, 1);
    }
 
    sphere(radius); //Antonino non sa cosa vuol dire questa riga, ma il resto si -> Paolo risponde: "Lol"
    popMatrix();

    if(!gtrModulation.equals("none")) {
      this.spiral.run();
    }


  }
  /**
  Applies LFO effect to the sphere
  */
  private void lfoEffect() {
    alfa += 0.1 * modulationRate;
  }

  /**
  Change the position of the sphere
  @param x x-axis position
  @param y y-axis position
  @param z z-axis position
  */
  void setPosition(float x, float y, float z) {
    this.position.x = x;
    this.position.y = y;
    this.position.z = z;
    this.spiral.setOrigin(x,y,x);
  }
  /**
  Get the sphere position
  @param x x-axis position
  @param y y-axis position
  @param z z-axis position
  @return the position vector
  */
  PVector getPosition() {
    return this.position.copy();
  }
  /**
  Get the sphere origin
  @return the origin vector
  */
  PVector getOrigin() {
    return this.origin.copy();
  }

}
