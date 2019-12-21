/*This class is used to apply the effects of each midi message received from the minilogue*/

private float alfa = 0.0; //---->init modulation rate value
private float y;

  /*Cutoff Effect*/
  public void cutoffEffect(Note note) {
    float orizontalDiameter = 20 + cutOffFilter;
  }
  
  /*Pitch Slide Effect*/
  public void pitchSlideEffect(Note note) {
    
    //float y = (prevNote.position.y - pitchBend) + modulation * sin(alfa);
    float verticalDiameter = 20 + abs(pitchBend) + cutOffFilter;
    //opacity = map (prevNote.velocity, 0, 127, 100, 255);
    
  }
  
   /*LFO Effect*/
  public void lfoEffect(Note note) {
    alfa += 0.1 * modulationRate; //lfo phase
    
  }
   
  public void monoNoteOnEffect(Note note){        
    note.circle.animateNoteOn();
  }
          
          
  public void monoNoteOffEffect(Note note) {
    note.circle.animateNoteOff();
  }     
  
  /*public void applyAllEffects(Note note) {
    monoNoteOffEffect(note);
     
  }
  */
