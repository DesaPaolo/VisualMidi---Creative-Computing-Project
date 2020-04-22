class GuitarMenu extends Menu{

    public GuitarMenu(int size) {
        /*

        xBtn = 1100;
        yBtn = 350;
        wBtn = 80;
        hBtn = 50;
*/
        super("Guitar Device",size, "Change R");
        createButtons(1150, 350, "Change R");
        super.xBox = 1000;
        super.yBox = 350;
        super.wBox = 500;
    }

    public void mousePressedEvent() {

        if(mousePressed){
            println("GET BTN INDEX GUITAR PRY !!!!: "+getBtnIndex(menuButtons));

            if(getBtnIndex(menuButtons)!= -1){

                if(currentInput==-2){
                  currentInput =  getBtnIndex(menuButtons);
                }

                else {
                    println("PREVIOUS INPUT: " + currentInput);
                    guitar.clearInputs();
                    currentInput =  getBtnIndex(menuButtons);
                    println("NEW INPUT: " + currentInput);

                }

                guitar.addInput(currentInput);
                println("currentInput: "+currentInput);
                println("INPUTS" + Arrays.asList(MidiBus.availableInputs()));
                changeButtonColor();

            }  

        }

    }

    public void showMenu() {

        fill(255);
        text(title, 1000, 100); 
        fill(255);
        
        backToMenuBtn.showBtn();
        
        fill(255);
        rect(xBox, yBox, wBox, hBox);

        for(int i = 0; i < menuButtons.size();i-=-1){
            
            menuButtons.get(i).showBtn();        
            fill(0);
            text((Arrays.asList(MidiBus.availableInputs()).get(i)), xBox-90, ((yBox-hBox/2) + marginTop + (i*hLine)));

        }

    }

















}