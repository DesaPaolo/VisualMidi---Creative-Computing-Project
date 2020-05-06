/**
Returns a color, using a perlin noise
@param seed seed for the noise
@param brighter if true returns a brighter color
@return a color using perlin noise
*/
public color getColorPerlin(float seed, boolean brighter){

    float r,g,b;

    if(!brighter){
        
        r = (noise(random(1,seed)))*255;
        g = (noise(random(1,seed)))*255;
        b = (noise(random(1,seed)))*255;
        
    }

    else {

        float x = noise(seed);
        r = ((random(x,1)))*255;
        g = ((random(x*0.7,1)))*255;
        b = ((random(x*0.5,1)))*255;

    }

    color c = color( (int)r, (int)g, (int)b );
    //println("Extracted Color: "+"R = "+red(c)+" G = "+green(c)+" B = " + blue(c));
    return c;

}
/**
@return a random color from a pool of colors
*/
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
/**
@return a warm color
*/
public color getColorWarm() {

    color[] pool = new color[5];
    
    pool[0] = color(255, 0, 0);//red
    pool[1] = color(255, 191, 0);//ambra
    pool[2] = color(255, 255, 0);//yellow
    pool[3] = color(255, 165, 0);//orange
    pool[4] = color(255, 155, 45);//orange2

    int randomColorIndex = (int)random(0, 5);
    //println("Extracted Color: "+"R = "+red(pool[randomColorIndex])+" G = "+green(pool[randomColorIndex])+" B = " + blue(pool[randomColorIndex]));
    return pool[randomColorIndex];

}