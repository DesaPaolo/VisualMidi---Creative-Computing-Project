class StarField{

    private int size;
    private Star[] stars;

    public StarField(int size){

        this.size = size;
        stars = new Star[size];
        for (int i = 0; i < size; i++) {
           stars[i] = new Star();
        }
    }

    public void draw() {

        translate(width/2, height/2);
        for (int i = 0; i < this.size; i++) {
           stars[i].update();
           stars[i].show();
        }
        translate(0,0);

    }

    public void setSpeed(int speed) {
        for (int i = 0; i < size; i++) {
            stars[i].setSpeed(speed);
        }
    }

}