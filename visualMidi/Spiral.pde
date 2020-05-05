class Spiral {

    float speed;
    float n;
    float radius;
    PVector position;
    ArrayList<Particle> particles;
    PVector origin;
    color c;
    int sign;
  

    Spiral(PVector position, color c) {
        this.position = position.copy();
        this.origin = position.copy();
        this.particles = new ArrayList<Particle>();
        this.radius = 100;
        this.speed = 2;
        this.n = 0.01;
        this.c = c;
        int[] signs = new int[2];
        signs[0] = 1;
        signs[1] = -1;
        this.sign = signs[(int)random(2)];
    }

    void run() {
        int sign = this.sign;
        this.position.x = this.origin.x+sign*this.radius*cos(this.speed*this.n)+sign*noise(random(1,10));
        this.position.y = this.origin.y+sign*this.radius*sin(this.speed*this.n)+sign*noise(random(1,10));;
        //this.position.x += noise(random(1,10));
        //this.position.y += noise(random(1,10));
        //this.position.x += noise(random(1,10));
        //this.position.y += noise(random(1,10));
        this.addParticle(this.c);
        for (int i = this.particles.size()-1; i >= 0; i--) {
            Particle p = this.particles.get(i);
            p.run();
            if (p.isDead()) {
                this.particles.remove(i);
            }
        }
        this.n+=0.02;

    }

    private void addParticle(color c) {

        this.particles.add(new Particle(this.position, this.c));
    }


    void setOrigin(float xPos, float yPos, float zPos) {

        this.origin.x = xPos;
        this.origin.y = yPos;
        this.origin.z = zPos;
    }

    class Particle {
        PVector position;
        float lifespan;
        float n = 1;
        PVector acceleration;
        PVector velocity;
        float l = 10;
        float zP;
        float pz;
        color c;

        Particle(PVector origin, color c) {
            this.position = origin.copy();
            this.acceleration = new PVector(0, -0.05);
            this.velocity = new PVector(random(-0.02,0.02), random(-0.02,0.02));
            //velocity = new PVector(0.01,0.01,0.01);
            this.lifespan = 100;
            this.c = c;
        }

        void run() {
            update();
            display();
        }

        // Method to update position
        void update() {
            this.velocity.add(this.acceleration);
            this.position.add(this.velocity);
        
            this.lifespan -= 1.0;
        }

        // Method to display
        void display() {
            fill(this.c, 100-this.lifespan);
            //stroke(0,10,255);
            ellipse(this.position.x, this.position.y, 30, 30);
            
            
        
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





}