class Star {

    float x;
    float y;
    float z;
    float pz;

    Star() {
        this.x = random(-width/2, width/2);
        this.y = random(-height/2, height/2);
        this.z = random(width/2);
        this.pz = this.z;
    }

    void update() {
        z-=warpSpeed;
        if(this.z < 1){
            this.z = width/2;
            this.x = random(-width/2, width/2);
            this.y = random(-height/2, height/2);
            this.pz = this.z;
        }
    }


    void show() {

        fill(255);
        noStroke();
        float sx = map(this.x / this.z, 0, 1, 0, width/2);
        float sy = map(this.y / this.z, 0, 1, 0, height/2);
        float r = map(this.z, 0, width/2, 16, 0);
        ellipse(sx, sy, r, r);
        float px = map(this.x / this.pz, 0, 1, 0, width/2);
        float py = map(this.y / this.pz, 0, 1, 0, height/2);
        this.pz = this.z;
        stroke(255);
        line(px, py, sx, sy);

    }



}