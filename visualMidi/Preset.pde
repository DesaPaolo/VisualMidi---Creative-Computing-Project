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
  private float susAmpEG;
  private float atckTimeEG;
  private float dcyTimeEG;
  private float relTimeEG;
  private boolean poly;
  private float intEG;
  private float hiPassDly;
  private float timeDly;
  private float feedbackDly;
  private boolean isActiveDly;
  private int id;

  Preset (String name, Date creationDate, boolean susPedal, float mod, float modRate, float cutoffFil, float[] envTimes, float ampSus,
  float susAmpEG, float atckTimeEG, float dcyTimeEG, float relTimeEG, Boolean poly, float intEG, float hiPassDly, float timeDly, float feedbackDly, boolean isActiveDly, int id) {
    this.name = name;
    this.susPedal = susPedal;
    this.creationDate = creationDate;
    this.mod = mod;
    this.modRate = modRate;
    this.cutoffFil = cutoffFil;
    this.atckTime = envTimes[0];
    this.dcyTime = envTimes[1];
    this.relTime = envTimes[3];
    this.susAmp = ampSus;
    this.susAmpEG = susAmpEG;
    this.atckTimeEG = atckTimeEG;
    this.dcyTimeEG = dcyTimeEG;
    this.relTimeEG = relTimeEG;
    this.poly = poly;
    this.intEG = intEG;
    this.hiPassDly = hiPassDly;
    this.timeDly = timeDly;
    this.feedbackDly = feedbackDly;
    this.isActiveDly = isActiveDly;
    this.id = id;
  }

  Preset() {
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
    this.susAmpEG = 0;
    this.atckTimeEG = 0;
    this.dcyTimeEG = 0;
    this.relTimeEG = 0;
    this.poly = false;
    this.intEG = 0;
    this.hiPassDly = 0;
    this.timeDly = 0;
    this.feedbackDly = 0;
    this.isActiveDly = false;
    this.id=-1;
  }

  public void setPresetName(String name) {
    this.name = name;
  }

  public void setSusPedal(boolean susPedal) {
    this.susPedal = susPedal;
  }
  public void setCreationDate(Date creationDate) {
    this.creationDate = creationDate;
  }
  public void setMod(float modulation) {
    this.mod = modulation;
  }
  public void setModRate(float modulationRate) {
    this.modRate = modulationRate;
  }
  public void setCutoffFil(float cutoffFil) {
    this.cutoffFil = cutoffFil;
  }
  public void setAttack(float attackTime) {
    this.atckTime = attackTime;
  }
  public void setDecay(float dcyTime) {
    this.dcyTime = dcyTime;
  }
  public void setRelease(float releaseTime) {
    this.relTime = releaseTime;
  }
  public void setAmpSus(float ampSus) {
    this.susAmp = ampSus;
  }
  public void setAtckTimeEG(float atckTimeEG) {
    this.atckTimeEG = atckTimeEG;
  }
  public void setDcyTimeEG(float dcyTimeEG) {
    this.dcyTimeEG = dcyTimeEG;
  }
  public void setRelTimeEG(float relTimeEG) {
    this.relTimeEG = relTimeEG;
  }
  public void setSusAmpEG(float susAmpEG) {
    this.susAmpEG = susAmpEG;
  }
  public void setIntEG(float intEG) {
    this.intEG = intEG;
  }
  public void setPoly(boolean poly) {
    this.poly = poly;
  }
  public void setHiPassDly(float hiPassDly) {
    this.hiPassDly = hiPassDly;
  }
  public void setTimeDly(float timeDly) {
    this.timeDly = timeDly;
  }
  public void setFeedbackDly(float feedbackDly) {
    this.feedbackDly = feedbackDly;
  }
  public void setIsActiveDly(boolean isActiveDly) {
    this.isActiveDly = isActiveDly;
  }
  public void setId(int id){
    this.id = id;
  }
  

  public String getPresetName() {
    return this.name;
  }

  public boolean getSusPedal() {
    return this.susPedal;
  }
  public Date getCreationDate() {
    return this.creationDate;
  }
  public float getMod() {
    return this.mod;
  }
  public float getModRate() {
    return this.modRate;
  }
  public float getCutoffFil() {
    return this.cutoffFil;
  }
  public float getAttack() {
    return this.atckTime;
  }
  public float getDecay() {
    return this.dcyTime;
  }
  public float getRelease() {
    return this.relTime;
  }
  public float getAmpSus() {
    return this.susAmp;
  }
  public float getAtckTimeEG() {
    return this.atckTimeEG;
  }
  public float getDcyTimeEG() {
    return this.dcyTimeEG;
  }
  public float getRelTimeEG() {
    return this.relTimeEG;
  }
  public float getSusAmpEG() {
    return this.susAmpEG;
  }
  public float getIntEG() {
    return this.intEG;
  }
  public boolean getPoly() {
    return this.poly;
  }
  public float getHiPassDly() {
    return this.hiPassDly;
  }
  public float getTimeDly() {
    return this.timeDly;
  }
  public float getFeedbackDly() {
    return this.feedbackDly;
  }
  public boolean getIsActiveDly() {
    return this.isActiveDly;
  }
  public int getId() {
    return this.id;
  }

  public String toString() { //Override
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
    String atckTimeEG = "EG Attack Time (ms): " + this.relTime + "\n"; 
    String dcyTimeEG = "EG decay Time (ms): " + this.relTime + "\n"; 
    String relTimeEG = "EG release Time (ms): " + this.relTime + "\n"; 
    String susAmpEG = "Amp sus EG: " + this.relTime + "\n"; 
    String poly = "Poly: " + Boolean.toString(this.poly) + "\n"; 
    String intEG = "EG Int: " + this.intEG + "\n"; String delay = "HiPass: " + this.hiPassDly + "\n" + 
                   "Time: " + this.timeDly + "\n" + 
                   "Feedback: " + this.feedbackDly + "\n" +
                   "isActive: " + Boolean.toString(this.isActiveDly) + "\n"; 
    String id = "Id: " + this.id +"\n";


    return id + name + date + susPedal + modulation + modulationRate + cutoffFil + atckTime + dcyTime + relTime + susAmp + atckTimeEG + dcyTimeEG + relTimeEG + 
    susAmpEG + poly + intEG + delay;
  }
}
