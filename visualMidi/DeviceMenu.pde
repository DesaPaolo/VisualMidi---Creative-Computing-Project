class DeviceMenu extends Menu{

    public DeviceMenu(int size) {

        super("Device Menu", size, "Change");

        xBox = 400;
        yBox = 300;
        wBox = 350;

        xBtn = xBox+50;
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
        text(title, 200, height * .06); 
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