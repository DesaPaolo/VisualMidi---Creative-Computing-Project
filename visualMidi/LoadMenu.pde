class LoadMenu extends Menu{


    public LoadMenu(int size) {

        super("Load Menu", size, "Load");

    }

    public void mousePressedEvent() {

        if(mousePressed){
            println("PREMO IL MOUSE, RE CECCONI");

            if(loadBtnClicked(menuButtons)!= -1){

                activatePreset(loadBtnClicked(menuButtons));

            }  

        }

    }

    public void showMenu() {

        background(0);
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