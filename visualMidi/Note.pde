
class Note {

  PVector position;
  PVector prevPosition;
  int pitch;
  int velocity;

  Note(int pitch, int velocity) {
    this.pitch = pitch;
    this.velocity = velocity;
    float x = map(this.pitch, 21, 108, -900, width + 750);
    float y = map(this.pitch, 21, 108, height + 500, -400);
    this.position = new PVector(x, y);
    this.prevPosition = new PVector(x, y);
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


  void show() {
    
    //float transparency;

    if (instrumentType == 1) { //poliphony
    
      //transparency = map (this.velocity, 0, 127, 0, 255);
      float orizontalDiameter = 20 + cutOffFilter;
      float verticalDiameter = 20 + cutOffFilter;
      noStroke();
      fill(255 - cutOffFilter);
      ellipse(this.position.x, this.position.y, orizontalDiameter, verticalDiameter);
      
    }
  }
  
  void animation(String midiMessageType) { //monophony

    if (instrumentType == 0) {
      if (midiMessageType== "noteOn") {

        Ani.to(prevNote.position, duration, "x", this.position.x, easings[index]);
        Ani.to(prevNote.position, duration, "y", this.position.y, easings[index]);

        //println("on. ");
        //println(prevNote.position);
        //println(this.position);
      } else {

        Ani.to(prevNote.position, duration, "x", this.prevPosition.x, easings[index]);
        Ani.to(prevNote.position, duration, "y", this.prevPosition.y, easings[index]);

        //println("off. ");
        //println(prevNote.position);
        //println(this.prevPosition);
      }
    }
  }
}
