class Button {
  private int xPos;
  private int yPos;
  private int wid;
  private int hei;
  private String txt;
  private color backgroundColor;
  private color textColor;
  private int index = -1;

  public Button(int xPos, int yPos, int wid, int hei, String txt){
    this.xPos = xPos;
    this.yPos = yPos;
    this.wid = wid;
    this.hei = hei;
    this.txt = txt;
    this.backgroundColor = color(255);
    this.textColor = color(0);
  }
  
  public Button(int xPos, int yPos, int wid, int hei, String txt, color backgroundColor, color textColor){
    this.xPos = xPos;
    this.yPos = yPos;
    this.wid = wid;
    this.hei = hei;
    this.txt = txt;
    this.backgroundColor = backgroundColor;
    this.textColor = textColor;
  }
  
  public void showBtn(){
    fill(backgroundColor);
    rect(xPos, yPos, wid, hei);
    fill(textColor);
    text(txt, xPos, yPos);
  }
  
  public boolean isPressed(){
    if (mousePressed) {
      return ((xPos-wid/2 <= mouseX && mouseX <= xPos+wid/2) && 
      (yPos-hei/2 <=mouseY && mouseY <= yPos+hei/2)); 
    }
    else return false;
  }

  public int getIndex() {
    return this.index;
  }
  
  public void setIndex(int index){
    this.index = index;
  }

  public void setBackgroundColor(color col) {
    this.backgroundColor=col;
    this.showBtn();
  }







}
