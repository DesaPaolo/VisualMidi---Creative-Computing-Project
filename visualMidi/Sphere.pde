/*Graphical representation of the Note class. 
 It's like the View class... Contains Whatever is needed to represent graphically the notes*/

class Sphere {
  
  private PVector position;
  private float alfa = 0.0;

  Sphere(float x, float y, float z) {
    this.position = new PVector(x, y, z);
  }

  //This function computes the graphical result, considering all the parameters (lfo, cutoff, pitch bend etc...)
  public void drawSphere(Ramp ramp) {
    
    noStroke();
    //ADSR parameter
    nearness = 1;//ramp.rampValue; //map ??
    
    fill(255);
    
    this.lfoEffect();
    
    float positionY = (this.position.y - pitchBend) + modulation * sin(alfa);
    float positionX = this.position.x;
    float positionZ = this.position.z * nearness; 
    
    //pitchbend
    float stretchingScale;
    stretchingScale = map(abs(pitchBend), 0, 64, 1, 2 );
    
    float radius = mapLog(cutOffFilter, 0, 255, 5, 45);

    pushMatrix();
    translate(positionX, positionY, positionZ);
    scale(1 , stretchingScale, 1); 
    sphere(radius);
    popMatrix();
    
  }

  /*
  void animateNoteOn() {
   Ani.to(position, duration, "x", this.position.x, easings[index]);
   Ani.to(position, duration, "y", this.position.y, easings[index]);
   }
   
   void animateNoteOff() {
   Ani.to(position, duration, "x", this.position.x, easings[index]);
   Ani.to(position, duration, "y", this.position.y, easings[index]);
   }*/

  private void lfoEffect() {
    alfa += 0.1 * modulationRate;
  }
}