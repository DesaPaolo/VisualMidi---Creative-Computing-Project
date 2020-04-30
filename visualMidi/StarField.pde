class StarField{

    private int size;
    private Star[] stars;
    private int warpSpeed;


   public StarField(int size, int warpSpeed){

        this.warpSpeed = warpSpeed;
        this.size = size;
        stars = new Star[size];
        for (int i = 0; i < size; i++) {
           stars[i] = new Star();
           stars[i].setSpeed(warpSpeed);
        }

    }

    public void draw() {

        translate(width/2, height/2);
        for (int i = 0; i < size; i++) {
           stars[i].update();
           stars[i].show();
        }
        translate(0,0);

    }

    public void setSpeed(int speed) {
        this.warpSpeed = speed;
        for (int i = 0; i < size; i++) {
           stars[i].setSpeed(speed);
        }
    }

}