class Star {

    private float x;
    private float y;
    private float z;
    private float pz;
    private int warpSpeed;
    private color starColor;
    private color starTrackColor;
    private int opacity;
    private float weight;
    private float density;
    private float overdriveFactor=0;

    Star() {
        this.x = random(-width/2, width/2);
        this.y = random(-height/2, height/2);
        this.z = random(width/2);
        this.pz = this.z;
        this.warpSpeed = 10;
        this.starColor = color(100,100,250);
        this.starTrackColor = color(0,0,255);
        this.opacity =70;
        this.weight = 1;
    }

    void update() {
        z-=this.warpSpeed;
        if(this.z < 1){
            this.z = width/2;
            this.x = random(-width/2, width/2);
            this.y = random(-height/2, height/2);
            this.pz = this.z;
        }
    }


    void show() {

        fill(this.starColor, this.opacity);
        noStroke();
        float sx = map(this.x / this.z, 0, 1, 0, width/2 + this.overdriveFactor);
        float sy = map(this.y / this.z, 0, 1, 0, height/2 + this.overdriveFactor);
        float r = map(this.z, 0, width/2, 16, 0);
        ellipse(sx, sy, r, r);
        float px = map(this.x / this.pz, 0, 1, 0, width/2);
        float py = map(this.y / this.pz, 0, 1, 0, height/2);
        this.pz = this.z;
        strokeWeight(this.weight);
        stroke(this.starTrackColor, this.opacity);
        line(px, py, sx, sy);

    }

    public void setSpeed(int speed){
        this.warpSpeed = speed;
    }

    public void setColor(color starColor){
        this.starColor = starColor;
    }

    public void setStarTrack(color starTrackColor){
        this.starTrackColor = starTrackColor;
    }

    public void setOpacity(int opacity){
        this.opacity = opacity;
    }

    public void setWeight(float weight){
        this.weight = weight;
    }

    public void hideStarField(){
        this.opacity=0;
    }

    public void reShowStarField(){
        this.opacity=80;
    }
    
    public void setDensity(float density){
        this.density=density;
    }

    public void setOverdriveFactor(float overdriveFactor){
        this.overdriveFactor=overdriveFactor;
    }

}