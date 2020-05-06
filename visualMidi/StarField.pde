/**
A Star field class
*/
public class StarField{

    private int size;
    private Star[] stars;

    /**
    Class constructor
    @param size number of stars
    */
    public StarField(int size){

        this.size = size;
        stars = new Star[size];
        for (int i = 0; i < size; i++) {
           stars[i] = new Star();
        }
    }

    /**
    Draws the star field
    */
    public void draw() {

        translate(width/2, height/2);
        for (int i = 0; i < this.size; i++) {
           stars[i].update();
           stars[i].show();
        }
        translate(0,0);

    }

    /**
    Change the warp speed
    @param speed new warp speed
    */
    public void setSpeed(int speed) {
        for (int i = 0; i < size; i++) {
            stars[i].setSpeed(speed);
        }
    }
    /**
    Change the stroke weight of the stars, for all the stars
    @param weight new stroke weight
    */
    public void setWeight(float weight) {
        for (int i = 0; i < size; i++) {
            stars[i].setWeight(weight);
        }
    }
    /**
    Change the color of the stars, for all the stars
    @param starColor new color
    */
    public void setColor(color starColor) {
        for (int i = 0; i < size; i++) {
            stars[i].setColor(starColor);
        }
    }
    /**
    Change the star track color, for all the stars
    @param starTrackColor new star track color
    */
    public void setStarTrack(color starTrackColor) {
        for (int i = 0; i < size; i++) {
            stars[i].setStarTrack(starTrackColor);
        }
    }
    /**
    Change the opacity, for all the stars
    @param opacity new opacity
    */
    public void setOpacity(int opacity) {
        for (int i = 0; i < size; i++) {
            stars[i].setOpacity(opacity);
        }
    }

    /**
    Hides the star field
    */
    public void hideStarField(){
        for (int i = 0; i < size; i++) {
            stars[i].setOpacity(0);
        }
    }
    /**
    Shows again the star field
    */
    public void reShowStarField(){
        for (int i = 0; i < size; i++) {
            stars[i].setOpacity(80);
        }
    }
    /**
    Shows only some stars of the star field
    */
    public void showSomeStars(int opacity, int density){
        for (int i = 0; i < size; i+=density) {
            stars[i].setOpacity(opacity);
        }
    }

    /**
    Change the stars density
    @param density new density
    */
    public void setDensity(float density){
        for (int i = 0; i < size; i++) {
            stars[i].setDensity(density);
        }
    }

    /**
    Change the motion perspective of the stars
    @param overdriveFactor value representing the change of perspective
    */
    public void setOverdriveFactor(float overdriveFactor){
        for (int i = 0; i < size; i++) {
            stars[i].setOverdriveFactor(overdriveFactor);
        }
    }

}