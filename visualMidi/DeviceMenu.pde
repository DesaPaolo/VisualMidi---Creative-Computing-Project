class DeviceMenu extends Menu{

      public DeviceMenu(int size) {

        super("Device Menu", size, "Change");

    }

    public void mousePressedEvent() {

        if(mousePressed){

            if(getBtnIndex(menuButtons)!= -1){

                minilogue  = new  MidiBus(this, getBtnIndex(menuButtons), 1);                

            }  

        }

    }

    public void showMenu() {

        
        fill(255);
        rect(xBox, yBox, wBox, hBox);
        fill(0);
        text("a", 100, 100); 
               


        /*
        for(int i = 0; i < menuButtons.size();i-=-1){
            
            menuButtons.get(i).showBtn();        
            fill(0);
            text((Arrays.asList(MidiBus.availableInputs()).get(i)), xBox, (yBox + (i*hLine)+10));

        }*/

    }


}