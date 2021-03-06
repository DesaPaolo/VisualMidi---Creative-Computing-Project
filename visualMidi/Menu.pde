/**
Abstract menu class. A menu class seen as a list of elements, one above the other. The elements are text and buttons
*/
public abstract class Menu{
    
    String title;
    int numberOfElements;

    int xBox = width/2;
    int yBox = 200;
    int wBox = 450;
    int hBox;

    int xBtn = xBox+150;
    int yBtn = yBox;
    int wBtn = 80;
    int hBtn = 50;

    int hLine = 50;
    int marginTop = 30;

    ArrayList<Button> menuButtons = new ArrayList();
    /**
    @param title title of the menu
    @param numberOfElements number of elements of the menu
    @param label label
    */
    public Menu(String title, int numberOfElements, String label) {

        this.numberOfElements = numberOfElements;
        this.hBox = numberOfElements*60;
        this.title = title;

    }
    /**
    Mouse pressed event
    */
    public abstract void mousePressedEvent();
    /**
    Show the menu view
    */
    public abstract void showMenu();
    /**
    Create some buttons
    @param xBtn x-axis position, further rmodified
    @param yBtn y-axis position, further modified
    */
    public void createButtons(int xBtn, int yBtn, String label) {

        for(int i = 0; i < this.numberOfElements; i++) {

            Button newBtn = new Button(xBtn, ((yBtn-hBox/2) + marginTop + (i*hLine)), wBtn, hBtn, label);
            newBtn.setIndex(i);
            menuButtons.add(newBtn);

        }
    }
    
    /**
    Change buttons color
    */
    public void changeButtonColor() {

        for(int i = 0; i < menuButtons.size(); i++ ){
            menuButtons.get(i).setBackgroundColor(color(255,255,255));
        }
        
        menuButtons.get(getBtnIndex(menuButtons)).setBackgroundColor(color(255,0,0));

    }

}
