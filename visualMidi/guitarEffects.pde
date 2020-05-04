float v = 0.01 ;
int speed = 3;
int radius = 50 ;


public color applyEq() {

    if(gtrEq.equals("warm")) {
        color c1 = getColorWarm();
        return c1;
    }

    else if(gtrEq.equals("normal")) {
        color c1 = getColorPerlin((random(50, 100)), true);
        return c1;
    }

    else if(gtrEq.equals("bright")) {
        color c1 = getColorRandom();
        return c1;
    }
    else {
        return color(255,255,255);
    }

}

public void applyAmp() {

    if(gtrAmp.equals("clean")) {
        starField.setWeight(1);
        starField.setStarTrack(color(20,20,255));
    }
    
    else if(gtrAmp.equals("crunch")) {
        starField.setWeight(5);
        starField.setStarTrack(color(255, 165, 0));
    }
    
    else if(gtrAmp.equals("hiGain")){
        starField.setWeight(10);
        starField.setStarTrack(color(20,20,255));
    }

}

public void applyOverdrive() {

    if(gtrOverdrive.equals("none")) {

        starField.setColor(color(100,100,250));
        starField.setOverdriveFactor(0); 
    }
    
    else if(gtrOverdrive.equals("boost")) {

        starField.setColor(color(255,255,20));
        starField.setOverdriveFactor(20);
    }
    
    else if(gtrOverdrive.equals("overdrive")){
     
        starField.setColor(color(100,100,250));
        starField.setOverdriveFactor(50);
    }

    else if(gtrOverdrive.equals("distortion")) {
  
        starField.setColor(color(255, 20, 20));
        starField.setOverdriveFactor(75);
        
    }

    else if (gtrOverdrive.equals("fuzz")) {

        starField.setColor(color(100, 150, 100));
        starField.setOverdriveFactor(250);

    }

}

public void applyReverb() {

    if (gtrReverb.equals("small")) {
        starField.setOpacity(100);
        starField.setDensity(0);
    }

    else if (gtrReverb.equals("medium")) {
        starField.setOpacity(0);
        starField.showSomeStars(70, 5);
        starField.setDensity(100);
    }

    else if (gtrReverb.equals("large")) {
        starField.setOpacity(0);
        starField.showSomeStars(60, 10);
        starField.setDensity(500);
    }

}

public void applyModulation(Sphere sphere) {

    if (gtrModulation.equals("none")) {
        
    }

    else if (gtrModulation.equals("phaser")) {
        radius = 35;
        speed = 2;
        sphere.setPosition(sphere.getOrigin().x+radius*cos(speed*v),sphere.getOrigin().y + radius*sin(speed*v),sphere.getPosition().z);
    }

    else if (gtrModulation.equals("flanger")) {
        radius = 45;
        speed = 3;
        sphere.setPosition(sphere.getOrigin().x+radius*cos(speed*v),sphere.getOrigin().y + radius*sin(speed*v),sphere.getPosition().z);
    }
    else if (gtrModulation.equals("chorus")) {
        radius = 55;
        speed = 4;
        sphere.setPosition(sphere.getOrigin().x+radius*cos(speed*v),sphere.getOrigin().y + radius*sin(speed*v),sphere.getPosition().z);
    }
    v+=0.02;

}

