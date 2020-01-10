//Paolo is the new Pry (sono Antonino)
//Giulia Cosentini ti amo
//Franca Garzotto no

 //<>//


// A class to describe a group of Particles
// An ArrayList is used to manage the list of Particles 

class ParticleSystem {
  ArrayList<Particle> particles;
  PVector origin;
  float lifespan;

  ParticleSystem(PVector position) {
    origin = position.copy();
    particles = new ArrayList<Particle>();
    lifespan = feedbackDly;
  }

  void addParticle() {
    if(this.lifespan > 0 ){
      println("Carmelo piantala con 'sti bonghi " + lifespan);
      particles.add(new Particle(origin));
      lifespan -= 1.0;
    }
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
  
  void drawParticles() {
  addParticle();
  run();
}
}


// A simple Particle class

class Particle {
  PVector position;
  PVector velocity;
  PVector acceleration;
  float lifespan;
  color c = color(255,0, 0);

  Particle(PVector l) {
    acceleration = new PVector(0, 0.1*timeDly/100);
    velocity = new PVector(random(-1, 1), random(-2, 0));
    position = l.copy();
    lifespan = hiPassDly;
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
    fill(c, lifespan);
    translate(position.x, position.y);
    sphere(10);
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
