/**
Note class, contains the status of the played noted
*/
public class Note {

  Sphere sphere; //3D
  private int pitch;
  private float velocity;
  boolean toRemove = false;

  float[] adsrValues;
  float[] filterAdsrValues;
  Ramp ramp;
  Ramp filterRamp;
  float x, y, z;

  ParticleSystem ps; 
  /**
  Class constructor
  @param pitch pitch of the note
  @param velocity velocity of the note
  */
  Note(int pitch, int velocity) {
    println("#######Created a note##########");
    this.pitch = pitch;
    this.velocity = velocity;
    x = map(this.pitch, 21, 108, 0, width);
    y = map(this.pitch, 21, 108, height, 0);
    z = 1;
    this.velocity = map(this.velocity, 0, 127, 0, 255);
    this.sphere = new Sphere(x, y, z);
    this.adsrValues = new float[3];
    this.filterAdsrValues = new float[4];
  }
  /**
  Get the pitch of the note
  @return the pitch of the note
  */
  int getPitch() {
    return this.pitch;
  }

  /**
  Updates the model and view. Called each frame
  */
  public void update() {

    if (this.toRemove) {
      removeNoteByPitch(this.pitch); 
    } else { 
      if (isActiveDly) {
        this.ps.addParticle(this.sphere.radius);
      }
      this.sphere.drawSphere(this.ramp.rampValue, this.filterRamp.rampValue, this.velocity);
    }
  }
  /**
  Applies note on effect
  */
  public void noteOnEffect() {

    this.initAdsrRamp();

    if (isActiveDly) {
      this.ps = new ParticleSystem(new PVector(x, y, z));
    }
  }
  /**
  Initializes the ADSR ramp
  */
  private void initAdsrRamp() {
    this.adsrValues[0] = 255;
    this.adsrValues[1] = 255 * ((float)ampSus/100);
    this.ramp = new Ramp(times[0], millis(), 0, 0, 0, this.adsrValues[0], this, false);

    this.filterAdsrValues[0] = cutOffFilter;//is like the cutoff frequency, from 0 to 100
    this.filterAdsrValues[1] = min(100, cutOffFilter + EGInt);
    this.filterAdsrValues[2] = min(100, cutOffFilter + EGInt * ((float)EGAmpSus/100));
    this.filterAdsrValues[3] = cutOffFilter;


    //parto dal cutoff value, arrivo fino all'eg int. Poi mi fermo in sustain nel EG int scalato 
    //per il valore percentuale di sustain, e nel release torno al valore di cutoff
    this.filterRamp = new Ramp(EGTimes[0], millis(), 0, 0, this.filterAdsrValues[0], this.filterAdsrValues[1], this, true);
  }
  /**
  Set the pitch of the note
  @param pitch new pitch
  */
  public void setPitch(int pitch) {
    this.pitch = pitch;
    float newX = map(this.pitch, 21, 108, 0, width);
    float newY = map(this.pitch, 21, 108, height, 0);
    this.sphere.setPosition(newX, newY, 1);
  }
}
