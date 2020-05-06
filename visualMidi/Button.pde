/**
 * A clickable button
 */
public class Button {
  private int xPos;
  private int yPos;
  private int wid;
  private int hei;
  private String txt;
  private color backgroundColor;
  private color textColor;
  private int index = -1;
  /**
  * Button class constructor
  @param xPos x-axis position
  @param yPos y-axis position
  @param wid button width
  @param hei button height
  @param txt inner text
  */
  public Button(int xPos, int yPos, int wid, int hei, String txt){
    this.xPos = xPos;
    this.yPos = yPos;
    this.wid = wid;
    this.hei = hei;
    this.txt = txt;
    this.backgroundColor = color(255);
    this.textColor = color(0);
  }
  
  /**
  * Button class constructor 
  @param xPos x-axis position
  @param yPos y-axis position
  @param wid button width
  @param hei button height
  @param txt inner text
  @param backgroundColor background color
  @param textColor text color
  */
  public Button(int xPos, int yPos, int wid, int hei, String txt, color backgroundColor, color textColor){
    this.xPos = xPos;
    this.yPos = yPos;
    this.wid = wid;
    this.hei = hei;
    this.txt = txt;
    this.backgroundColor = backgroundColor;
    this.textColor = textColor;
  }
  /**
  Shows the button
  */
  public void showBtn(){

    fill(backgroundColor);
    //stroke(255,20,20);//causes issues when passing from store to mode 0, remains the borders of the backToMenuBtn and of the storePresetBtn
    rect(xPos, yPos, wid, hei);
    fill(textColor);
    String capitalizedText = txt.substring(0,1).toUpperCase()+txt.substring(1, txt.length());
    text(capitalizedText, xPos, yPos);
  }
  
  /**
  @return true if the button was pressed
  */
  public boolean isPressed(){
    if (mousePressed) {
      return ((xPos-wid/2 <= mouseX && mouseX <= xPos+wid/2) && 
      (yPos-hei/2 <=mouseY && mouseY <= yPos+hei/2)); 
    }
    else return false;
  }

  /**
  @return index of the button inside an aray list
  */
  public int getIndex() {
    return this.index;
  }
  /**
  Sets the index of the button
  @param index index of the button
  */
  public void setIndex(int index){
    this.index = index;
  }
  /**
  Sets the background color of the button
  @param col new color
  */
  public void setBackgroundColor(color col) {
    this.backgroundColor=col;
  }

  /**
  Get the background color of the button
  @return the background color
  */
  public color getBackColor() {
    return this.backgroundColor;
  }
  /**
  Get the inner text of the button
  @return the inner text
  */
  public String getText(){
    return this.txt;
  }

  /**
  Sets the inner text of the button
  @param txt inner text
  */
  public void setText(String txt){
    this.txt = txt;
  }

  /**
  @return y-axis position
  */
  public int getYPos() {
    return yPos;
  }
  /**
  @return x-axis position
  */
  public int getXPos() {
    return xPos;
  }







}
