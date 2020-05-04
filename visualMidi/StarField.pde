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

    public void setWeight(float weight) {
        for (int i = 0; i < size; i++) {
            stars[i].setWeight(weight);
        }
    }

    public void setColor(color starColor) {
        for (int i = 0; i < size; i++) {
            stars[i].setColor(starColor);
        }
    }

    public void setStarTrack(color starTrackColor) {
        for (int i = 0; i < size; i++) {
            stars[i].setStarTrack(starTrackColor);
        }
    }

    public void setOpacity(int opacity) {
        for (int i = 0; i < size; i++) {
            stars[i].setOpacity(opacity);
        }
    }

    public void hideStarField(){
        for (int i = 0; i < size; i++) {
            stars[i].setOpacity(0);
        }
    }

    public void reShowStarField(){
        for (int i = 0; i < size; i++) {
            stars[i].setOpacity(80);
        }
    }

    public void showSomeStars(int opacity, int density){
        for (int i = 0; i < size; i+=density) {
            stars[i].setOpacity(opacity);
        }
    }

    public void setDensity(float density){
        for (int i = 0; i < size; i++) {
            stars[i].setDensity(density);
        }
    }

    public void setOverdriveFactor(float overdriveFactor){
        for (int i = 0; i < size; i++) {
            stars[i].setOverdriveFactor(overdriveFactor);
        }
    }

}