class LoadMenu extends Menu{


    public LoadMenu(int size) {

        super("Load Menu", size, "Load");
        createButtons(xBox+150,yBox,"Load");

    }

    public void mousePressedEvent() {

        if(mousePressed){
            println("PREMO IL MOUSE, RE CECCONI");

            if(getBtnIndex(menuButtons)!= -1){

                activatePreset(getBtnIndex(menuButtons));
                changeButtonColor();

            }  

        }

    }

    public void showMenu() {

        fill(255);
        text(title, width/2, height * .06); 
        fill(255);
        
        backToMenuBtn.showBtn();
        
        fill(255);
        rect(xBox, yBox, wBox, hBox);
        
        for(int i = 0; i< menuButtons.size();i-=-1){
            
            menuButtons.get(i).showBtn();        
            fill(0);
            text((presets.get(i).getPresetName()), xBox-90, ((yBox-hBox/2) + marginTop + (i*hLine)));

        }

    }


}