class GuitarMenu extends Menu{

    public GuitarMenu(int size) {

        super("Guitar Device Menu", size, "Change");
        xBox = 1000;
        yBox = 300;
        wBox = 350;

        xBtn = xBox+150;
        yBtn = yBox;
        wBtn = 80;
        hBtn = 50;

    }

    public void mousePressedEvent() {

        if(mousePressed){
            println("getBtnIndex: "+getBtnIndex(menuButtons));

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
        text(title, 1000, height * .06); 
        fill(255);
        
        backToMenuBtn.showBtn();
        
        fill(255);
        rect(xBox, yBox, wBox, hBox);

        for(int i = 0; i < menuButtons.size();i-=-1){
            
            menuButtons.get(i).showBtn();        
            fill(0);
            text((Arrays.asList(MidiBus.availableInputs()).get(i)), xBox - 90, ((yBox-hBox/2) + marginTop + (i*hLine)));

        }

    }

















}