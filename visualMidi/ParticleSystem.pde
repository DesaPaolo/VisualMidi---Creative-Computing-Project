ArrayList<ParticleSystem> tempPs = new ArrayList<ParticleSystem>(); //<>//

class ParticleSystem {

  ArrayList<Particle> particles;
  PVector origin = new PVector();
  float psLifespan;
  int timeDlyCont; // rateo

  public ParticleSystem(PVector position) {
    println("#######Created a Particle System##########");
    this.particles = new ArrayList<Particle>();
    this.origin = position.copy();
    this.psLifespan = feedbackDly;
    this.timeDlyCont = round(timeDly);
    //println("psLifespan is " + psLifespan);
    tempPs.add(this);
  }


  public void addParticle(float radius) {
    if (this.timeDlyCont == round(timeDly)) {  
      if (this.psLifespan > 0) {
        this.particles.add(new Particle(this.origin, radius));
      }
      this.timeDlyCont = 0;
    }
    this.timeDlyCont++;
  }

  private float psLifespanDrop() {
    if (this.isMaxFeedbackDly()) {
      return 0;
    }
    return 1;
  }

  private boolean isMaxFeedbackDly() {
    return (feedbackDly >= maxFeedbackDly-5);
  }
  
  public void update() {
    if(this.isAlive()) {
      this.run();
      this.psLifespan -= this.psLifespanDrop();
    } else {
      println("MORTO");
      removePsByOrigin(this.origin);
    }
  }
  
  private void run() {
    for (int i = this.particles.size()-1; i >= 0; i--) {
      if (this.particles.get(i).isDead()) {
        this.particles.remove(i);
      } else {
        this.particles.get(i).run();
      }
    }
  }

  public boolean isAlive() {
    return (this.psLifespan > 0 || !(this.particles.isEmpty()));
  }
   
  public PVector getOrigin() {
    return this.origin; 
  }
  
}

// A simple Particle class

class Particle {

  PVector position;
  PVector velocity;
  PVector acceleration;
  float radius;
  float lifespan;
  color c = color(100, 100, 250);

  Particle(PVector position_, float radius_) {
    this.acceleration = new PVector(0, 0);//0.01*(maxDlyTime-timeDly)
    float vx = randomGaussian()*0.3;
    float vy = randomGaussian()*0.3 - 1.0;
    this.velocity = new PVector(vx, vy);
    this.position = position_.copy();
    this.radius = radius_;
    this.lifespan = 100;
    this.c = getColorRandom();
  }

  public void run() {
    update(); 
    display();
  }

  // Method to update position
  private void update() {
    this.velocity.add(this.acceleration);
    this.position.add(this.velocity);
    this.lifespan -= 1.0;
  }

  // Method to display
  private void display() {

    fill(this.c, map(this.lifespan, 0, 100, 0, 255 ));
    //if (EGInt < 8 && EGInt > -6) { // se EGInt è nel range dello 0% 
    //  fill((255 - (cutOffFilter/100) * 255), map(this.lifespan, 0, 100, 0, 255 ));
    //} else {
    //  fill((255 - (filterRampValueBackground/100) * 255), map(this.lifespan, 0, 100, 0, 255 ));
    //}

    ellipse(this.position.x, this.position.y, this.radius * 2, this.radius * 2);
  }

  boolean isDead() {
    return this.lifespan < 0.0 ;
  }
  
}
