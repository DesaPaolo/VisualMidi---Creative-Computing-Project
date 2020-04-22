// A class to describe a group of Particles //<>//
// An ArrayList is used to manage the list of Particles 

class ParticleSystem {

  ArrayList<Particle> particles;
  PVector origin = new PVector();
  float lifespan;

  ParticleSystem(PVector position, Sphere sphere) {
    println("#######Created a particle##########");

    origin.x = position.x;
    origin.y = position.y;
    //origin.z = position.z;
    println("px: " + position.x + "py:" + position.y + "pz: " + position.z);
    println("sph pos:" + sphere.position+"sph radius: "+sphere.radius);

    particles = new ArrayList<Particle>();
    lifespan = feedbackDly;
    println("lifespan is " + lifespan);
  }

  void addParticle() {
    if(this.lifespan > 0 ){
      //println("Carmelo piantala con 'sti bonghi " + lifespan);
      particles.add(new Particle(origin));
      lifespan -= f1();
    }
  }

  float f1() {

    if(maximumFeed()){
      return 0;
    }
    return 1;
  }

  boolean maximumFeed() {
    return (feedbackDly>=maximumFeedBack-5);
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
    return lifespan>0;
  };

}


// A simple Particle class

class Particle {
  PVector position;
  PVector velocity;
  PVector acceleration;
  float lifespan;

  Particle(PVector l) {
    acceleration = new PVector(0, 0.01*(maximumDelayTime-timeDly));
    velocity = new PVector(random(-1, 1), random(-2, 0));
    position = l.copy();
    lifespan = 255-hiPassDly;
  }

  void run() {
    update();
    display();
  }

  // Method to update position
  void update() {
    velocity.add(acceleration);
    position.add(velocity);
    lifespan -= 1.0;
  }

  // Method to display
  void display() {
    stroke(0, lifespan);
    fill(255, hiPassDly, hiPassDly, lifespan);
    ellipse(position.x, position.y, 8, 8);
    //println("Drawing the ellipse");
  }

  // Is the particle still useful?
  boolean isDead() {
    if (lifespan < 0.0) {
      return true;
    } else {
      return false;
    }
  }
}
