class DeviceMenu extends Menu{



    public DeviceMenu(int size) {

        super("Minilogue Device", size, "Change L");
        createButtons(450, 350, "Change L");
        super.xBox = 300;
        super.yBox = 350;
        super.wBox = 500;

    }

    public void mousePressedEvent() {

        if(mousePressed){
            println("GET BTN INDEX MINI PRY !!!!: "+getBtnIndex(menuButtons));

            if(getBtnIndex(menuButtons)!= -1){

                if(currentInput==-2){
                  currentInput =  getBtnIndex(menuButtons);
                }

                else {
                    println("PREVIOUS INPUT: " + currentInput);
                    minilogue.clearInputs();
                    currentInput =  getBtnIndex(menuButtons);
                    println("NEW INPUT: " + currentInput);

                }

                minilogue.addInput(currentInput);
                println("currentInput: "+currentInput);
                println("INPUTS" + Arrays.asList(MidiBus.availableInputs()));
                changeButtonColor();

            }  

        }

    }

    public void showMenu() {

        fill(255);
        text(title, 300, 100); 
        fill(255);
        
        backToMenuBtn.showBtn();
        
        fill(255);
        rect(xBox, yBox, wBox, hBox);


        
        for(int i = 0; i < menuButtons.size();i-=-1){
            
            menuButtons.get(i).showBtn();        
            fill(0);
            text((Arrays.asList(MidiBus.availableInputs()).get(i)), xBox-90 , ((yBox-hBox/2) + marginTop + (i*hLine)));

        }

    }

}