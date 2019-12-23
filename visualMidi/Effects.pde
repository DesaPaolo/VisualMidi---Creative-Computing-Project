/*Methods that apply the effects of each midi message received from the minilogue*/

private float alfa = 0.0; //---->init modulation rate value

/*Cutoff Effect*/
public void cutOffEffect(Note note) {
  note.circle.changeSize(20+cutOffFilter);
}

/*Pitch Slide Effect*/
public void pitchSlideEffect(Note note) {
  //float verticalDiameter = 20 + abs(pitchBend) + cutOffFilter;
  //note.circle.changeSize(20, verticalDiameter); 
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
