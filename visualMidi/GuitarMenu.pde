public class GuitarMenu extends Menu{

    public GuitarMenu(int size) {
        
        super("Kemper Profiler",size, "Change");
        wBtn=120;
        createButtons((int)(width*0.75)+180, (int)(height*0.40), "Change");
        super.xBox = (int)(width*0.75);
        super.yBox = (int)(height*0.4);
        super.wBox = 500;
    }

    public void mousePressedEvent() {

        if(mousePressed){

            if(getBtnIndex(menuButtons)!= -1){

                if(currentInput==-2){
                  currentInput =  getBtnIndex(menuButtons);
                }

                else {
                    guitar.clearInputs();
                    guitar.clearOutputs();
                    currentInput =  getBtnIndex(menuButtons);

                }

                guitar.addInput(currentInput);
                guitar.addOutput(guitar.attachedInputs()[0]);
                changeButtonColor();

            }  

        }

    }

    public void showMenu() {

        fill(255,0,0);
        text(title, (int)(width*0.75), (int)(height*0.20)); 
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
