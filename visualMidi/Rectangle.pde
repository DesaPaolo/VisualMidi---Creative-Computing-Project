/**
A rectangle class
*/
public class Rectangle {
  private int x;
  private int y;
  private int width;
  private int height;
  private int index;

  public Rectangle(int x, int y, int width, int height, int index) {
    this.x = x;
    this.y = y;
    this.width = width;
    this.height = height;
    this.index = index;
  }

  public int getX() {
    return this.x;
  }
  public int getY() {
    return this.y;
  }
  public int getWidth() {
    return this.width;
  }
  public int getHeight() {
    return this.height;
  }
  public int getIndex() {
    return this.index;
  }
}
