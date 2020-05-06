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

    public Menu(String title, int numberOfElements, String label) {

        this.numberOfElements = numberOfElements;
        this.hBox = numberOfElements*60;
        this.title = title;

    }

    public abstract void mousePressedEvent();
    public abstract void showMenu();

    public void createButtons(int xBtn, int yBtn, String label) {

        for(int i = 0; i < this.numberOfElements; i++) {

            Button newBtn = new Button(xBtn, ((yBtn-hBox/2) + marginTop + (i*hLine)), wBtn, hBtn, label);
            newBtn.setIndex(i);
            menuButtons.add(newBtn);

        }
    }
    
    
    public void changeButtonColor() {

        for(int i = 0; i < menuButtons.size(); i++ ){
            menuButtons.get(i).setBackgroundColor(color(255,255,255));
        }
        
        println("BTNINDEX: "+getBtnIndex(menuButtons));
        menuButtons.get(getBtnIndex(menuButtons)).setBackgroundColor(color(255,0,0));
        println("BACK COLOR: "+ hex(menuButtons.get(getBtnIndex(menuButtons)).getBackColor()));
        println("BACK COLOR OF FIRST: "+ hex(menuButtons.get(0).getBackColor()));

    }

}