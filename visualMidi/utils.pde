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

public void removeNoteByPitch(int pitch) {
  for (int c = 0; c<tempNotes.size(); c-=-1) {
    if (tempNotes.get(c).getPitch()==pitch) {
      tempNotes.remove(c);
    }
  }
}

public void removePsByOrigin(PVector origin) {
  for (int c = 0; c<tempPs.size(); c-=-1) {
    if (tempPs.get(c).getOrigin()==origin) {
      tempPs.remove(c);
    }
  }
}
