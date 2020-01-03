
// LOG MAPPING (SYNTH KNOB)
float mapLog(float value, float start1, float stop1, float start2, float stop2) { // https://forum.processing.org/two/discussion/18417/exponential-map-function
  start2 = log(start2);
  stop2 = log(stop2);

  float outgoing =
    exp(start2 + (stop2 - start2) * ((value - start1) / (stop1 - start1)));

  String badness = null;
  if (outgoing != outgoing) {
    badness = "NaN (not a number)";
  } else if (outgoing == Float.NEGATIVE_INFINITY ||
    outgoing == Float.POSITIVE_INFINITY) {
    badness = "infinity";
  }
  if (badness != null) {
    final String msg =
      String.format("map(%s, %s, %s, %s, %s) called, which returns %s", 
      nf(value), nf(start1), nf(stop1), 
      nf(start2), nf(stop2), badness);
    PGraphics.showWarning(msg);
  }
  return outgoing;
}

// CHANGE INSTRUMENT
void mouseClicked() {
  instrumentType++;
  if (instrumentType>1) {
    instrumentType=0;
  }
  println(instrumentType);
}

public void adsrInit() {
  
  times = new float[4];
  attackTimeMs = 1;
  decayTimeMs = 1000;
  releaseTimeMs = 1;
  times[0] = attackTimeMs;
  times[1] = decayTimeMs;
  times[2] = -1;
  times[3] = releaseTimeMs;
  
  EGTimes = new float[4];
  EGTimes[0] = attackTimeMs;
  EGTimes[1] = decayTimeMs;
  EGTimes[2] = -1;
  EGTimes[3] = releaseTimeMs;
  
}

public void getNoteIndex(int pitch) {
  
    for(int c = 0; c<tempNotes.size(); c-=-1) {
      if(tempNotes.get(c).getPitch()==pitch) {
        tempNotes.get(c).ramp.startRelease(index);
      }      
    }
}

public void removeNoteByPitch(int pitch) {
   for(int c = 0; c<tempNotes.size(); c-=-1) {
      if(tempNotes.get(c).getPitch()==pitch) {
        tempNotes.remove(c);
      }      
    }
}
  
  
  
