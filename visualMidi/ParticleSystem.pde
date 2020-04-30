// A class to describe a group of Particles //<>//
// An ArrayList is used to manage the list of Particles 

class ParticleSystem {

  ArrayList<Particle> particles;
  PVector origin = new PVector();
  float psLifespan;
  int timeDlyCont; // rateo

  ParticleSystem(PVector position) {
    println("#######Created a Particle System##########");
    
    particles = new ArrayList<Particle>();

    origin = position.copy();
    //println("px: " + position.x + "py:" + position.y + "pz: " + position.z);
    //println("sph pos:" + sphere.position+"sph radius: "+sphere.radius);

    psLifespan = feedbackDly;
    timeDlyCont = 0;
    println("psLifespan is " + psLifespan);
  }

  void addParticle(float radius) {
    if(timeDlyCont == round(timeDly)){  
      if (this.psLifespan > 0 ) {
        particles.add(new Particle(origin,radius));
        psLifespan -= psLifespanDrop();
      }
      timeDlyCont = 0;
    }
    timeDlyCont++;
  }

  float psLifespanDrop() {
    if (isMaxFeedbackDly()) {
      return 0;
    }
    return 1;
  }

  boolean isMaxFeedbackDly() {
    return (feedbackDly >= maxFeedbackDly-5);
  }

  void run() {
    for (int i = particles.size()-1; i >= 0; i--) {
      Particle p = particles.get(i);
      p.run();
      if (p.isDead()) {
        particles.remove(i);
      }
    }
  }

  public boolean isAlive() {
    return psLifespan > 0;
  }
}

// A simple Particle class

class Particle {

  PVector position;
  PVector velocity;
  PVector acceleration;
  float radius;
  float lifespan;

  Particle(PVector position_, float radius_) {
    acceleration = new PVector(0,0);//0.01*(maxDlyTime-timeDly)
    float vx = randomGaussian()*0.3;
    float vy = randomGaussian()*0.3 - 1.0;
    velocity = new PVector(vx, vy);
    position = position_.copy();
    radius = radius_;
    lifespan = 100;
  }

  void run() {
    update(); 
    display();
  }

  // Method to update position
  void update() {
    this.velocity.add(acceleration);
    this.position.add(velocity);
    this.lifespan -= 1.0;
  }

  // Method to display
  void display() {
    
    if (EGInt < 8 && EGInt > -6) { // se EGInt è nel range dello 0% 
    fill((255 - (cutOffFilter/100) * 255), map(this.lifespan, 0, 100, 0, 255 ));
  } else {
    fill((255 - (filterRampValueBackground/100) * 255) , map(this.lifespan, 0, 100, 0, 255 ));
  }
  
  ellipse(this.position.x, this.position.y, this.radius * 2, this.radius * 2);
  //println("Drawing the ellipse");
    
  }

  // Is the particle still useful?
  boolean isDead() {
    if (this.lifespan < 0.0) {
      return true;
    } else {
      return false;
    }
  }
}
