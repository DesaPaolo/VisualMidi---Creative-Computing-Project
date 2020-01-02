class Preset {
  
  private String name;
  private boolean susPedal;
  private Date creationDate;
  private float mod;
  private float modRate;
  private float cutoffFil;
  private float atckTime;
  private float dcyTime;
  private float susAmp;
  private float relTime;

  Preset (String name, Date creationDate, boolean susPedal, float mod, float modRate, float cutoffFil, float[] envTimes, float ampSus){
    this.name = name;
    this.susPedal = susPedal;
    this.creationDate = creationDate;
    this.mod = mod;
    this.modRate = modRate;
    this.cutoffFil = cutoffFil;
    this.atckTime = envTimes[0];
    this.dcyTime = envTimes[1];
    this.relTime = envTimes[2];
    this.susAmp = ampSus;
  }
  
  Preset(){
    this.name = "Name";
    this.susPedal = false;
    this.creationDate = Calendar.getInstance().getTime();
    this.mod = 0;
    this.modRate = 0;
    this.cutoffFil = 0;
    this.atckTime = 0;
    this.dcyTime = 0;
    this.relTime = 0;
    this.susAmp = 0;
  }
  
  public void setPresetName(String name){
    this.name = name;
  }
  
  public void setSusPedal(boolean susPedal){
    this.susPedal = susPedal;
  }
  public void setCreationDate(Date creationDate){
    this.creationDate = creationDate;
  }
  public void setMod(float modulation){
    this.mod = modulation;
  }
  public void setModRate(float modulationRate){
    this.modRate = modulationRate;
  }
  public void setCutoffFil(float cutoffFil){
    this.cutoffFil = cutoffFil;
  }
  public void setAttack(float attackTime){
    this.atckTime = attackTime;
  }
  public void setDecay(float dcyTime){
    this.dcyTime = dcyTime;
  }
  public void setRelease(float releaseTime){
    this.relTime = releaseTime;
  }
  public void setAmpSus(float ampSus){
  this.susAmp = ampSus;
  }
  
  public String getPresetName(){
    return this.name;
  }
  
  public boolean getSusPedal(){
    return this.susPedal;
  }
  public Date getCreationDate(){
    return this.creationDate;
  }
  public float getMod(){
    return this.mod;
  }
  public float getModRate(){
    return this.modRate;
  }
  public float getCutoffFil(){
    return this.cutoffFil;
  }
  public float getAttack(){
    return this.atckTime;
  }
  public float getDecay(){
    return this.dcyTime;
  }
  public float getRelease(){
    return this.relTime;
  }
  public float getAmpSus(){
    return this.susAmp;
  }
  
  public String toString(){ //Override
    String name = "Preset Name: " + this.name + "\n";
    String susPedal = "susPedal is pressed: " + Boolean.toString(this.susPedal) + "\n";
    String date = "Created on: " + this.creationDate + "\n"; 
    String modulation = "Modulation: " + this.mod + "\n"; 
    String modulationRate = "Modulation Rate: " + this.modRate + "\n"; 
    String cutoffFil = "Cutoff Filter: " + this.cutoffFil + "\n"; 
    String susAmp = "Sustain Amp: " + this.susAmp + "\n"; 
    String atckTime = "Attack Time (ms): " + this.atckTime + "\n"; 
    String dcyTime = "Decay Time (ms): " + this.dcyTime + "\n"; 
    String relTime = "Release Time (ms): " + this.relTime + "\n"; 
    
    
    return name + date + susPedal + modulation + modulationRate + cutoffFil + atckTime + dcyTime + relTime + susAmp;
    
  }

}
