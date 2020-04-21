class LoadMenu extends Menu{


    public LoadMenu(int size) {

        super("Load Menu", size, "Load");

    }

    public void mousePressedEvent() {

        if(mousePressed){
            println("PREMO IL MOUSE, RE CECCONI");

            if(getBtnIndex(menuButtons)!= -1){

                activatePreset(getBtnIndex(menuButtons));
                /*
                fill(255,255,255);
                text("PRESET LOADED !", 120, 120);
                */
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
            text((presets.get(i).getPresetName()), xBox, (yBox + (i*hLine)+10));

        }

    }


}