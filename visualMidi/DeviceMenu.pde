public class DeviceMenu extends Menu{



    public DeviceMenu(int size) {

        super("Minilogue", size, "Change");
        wBtn=120;
        createButtons((int)(width*0.25)+180, (int)(height*0.40), "Change");
        super.xBox = (int)(width*0.25);
        super.yBox = (int)(height*0.40);
        super.wBox = 500;

    }

    public void mousePressedEvent() {

        if(mousePressed){

            if(getBtnIndex(menuButtons)!= -1){

                if(currentInput==-2){
                  currentInput =  getBtnIndex(menuButtons);
                }

                else {
                    minilogue.clearInputs();
                    currentInput =  getBtnIndex(menuButtons);

                }

                minilogue.addInput(currentInput);
                changeButtonColor();

            }  

        }

    }

    public void showMenu() {

        fill(255,0,0);
        text(title, (int)(width*0.25), (int)(height*0.20));  
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