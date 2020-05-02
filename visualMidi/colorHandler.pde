public color getColorPerlin(float seed){

    float x = noise(seed);
    float y = x*255;
    return color( (int)y, (int)y, (int)y );

}

public color getColorGaussian(){

    return color(0,0,0);

}

public color getColorRandom(){

    color[] pool = new color[8];
    
    pool[0] = color(255, 0, 0);//red
    pool[1] = color(0, 255, 0);//green
    pool[2] = color(0, 0, 255);//blue
    pool[3] = color(255, 191, 0);//ambra
    pool[4] = color(255, 255, 0);//yellow
    pool[5] = color(255, 165, 0);//orange
    pool[6] = color(128, 0, 128);//purple
    pool[7] = color(255, 255, 255);//white

    int randomColorIndex = (int)random(0, 8);
    //println("Extracted Color: "+"R = "+red(pool[randomColorIndex])+" G = "+green(pool[randomColorIndex])+" B = " + blue(pool[randomColorIndex]));
    return pool[randomColorIndex];

}