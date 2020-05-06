/**
Menu displaying the saved presets, allows their loading
*/
public class LoadMenu extends Menu{

    /**
    @param size elements on the menu
    */
    public LoadMenu(int size) {

        super("Load Menu", size, "Load");
        createButtons(xBox+150,yBox,"Load");

    }
    /**
    Mouse pressed event
    */
    public void mousePressedEvent() {

        if(mousePressed){
            println("PREMO IL MOUSE, RE CECCONI");

            if(getBtnIndex(menuButtons)!= -1){

                activatePreset(presets.get(getBtnIndex(menuButtons)).getId());
                changeButtonColor();

            }  

        }

    }
    /**
    Updates the view and draws the menu
    */
    public void showMenu() {

        fill(255);
        text(title, width/2, height * .06); 
        fill(255);
        
        backToMenuBtn.showBtn();
        
        fill(255);
        rect(xBox, yBox, wBox, hBox);
        
        for(int i = 0; i< menuButtons.size();i-=-1){
            
            menuButtons.get(i).showBtn();        
            fill(255,10,10);
            text("#", xBox-160, ((yBox-hBox/2) + marginTop -50));
            text("Name", xBox, ((yBox-hBox/2) + marginTop-50 ));
            text("Click", xBox+150, ((yBox-hBox/2) + marginTop-50 ));
            fill(0);
            text((presets.get(i).getPresetName()), xBox, ((yBox-hBox/2) + marginTop + (i*hLine)));
            text((presets.get(i).getId()+1), xBox-160, ((yBox-hBox/2) + marginTop + (i*hLine)));
        }

    }


}