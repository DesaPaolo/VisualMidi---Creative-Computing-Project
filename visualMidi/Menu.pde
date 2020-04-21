abstract class Menu{
    
    String title;
    int numberOfElements;

    int xBox = width/2;
    int yBox = 200;
    int wBox = 450;
    int hBox;

    int xBtn = xBox+wBox-100;
    int yBtn = yBox;
    int wBtn = 80;
    int hBtn = 30;

    int hLine = 30;

    ArrayList<Button> menuButtons = new ArrayList();

    public Menu(String title, int numberOfElements, String label) {

        this.numberOfElements = numberOfElements;
        this.hBox = numberOfElements*60;
        this.title = title;

        for(int i = 0; i < this.numberOfElements; i++) {

            Button newBtn = new Button(xBtn, (yBtn + (i*hLine)+10), wBtn, hBtn, label);
            newBtn.setIndex(i);
            menuButtons.add(newBtn);

        }

    }

    public abstract void mousePressedEvent();
    public abstract void showMenu();

}