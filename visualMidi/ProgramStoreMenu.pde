class ProgramStoreMenu extends Menu {

    ArrayList<Button> programBtns = new ArrayList<Button>();
    ArrayList<Button> valueBtns = new ArrayList<Button>();
    Button storeBtn = new Button(300, 500, wBtn, hBtn, "Store");
    ArrayList<Button> storeBtns = new ArrayList<Button>(); 
    storeBtns.add(storeBtn);

    public ProgramStoreMenu(int size) {

        super("Edit Program", size, "");
        this.createButtons(450, 350);
        super.xBox = 300;
        super.yBox = 350;
        super.wBox = 500;
    }

    public void createButtons(int xBtn, int yBtn) {

        for(int i = 0; i < this.numberOfElements; i++) {

            Button newBtn = new Button(xBtn, ((yBtn-hBox/2) + marginTop + (i*hLine)), wBtn, hBtn, ("PC " + (i+1)));
            newBtn.setIndex(i);
            programBtns.add(newBtn);
        }
        Button newBtn = new Button(xBtn, ((yBtn-hBox/2) + marginTop + (i*hLine)), wBtn, hBtn, ("PC " + (this.numberOfElements+1)));
        newBtn.setIndex(this.numberOfElements);
        programBtns.add(newBtn);
    }

    public void mousePressedEvent() {
        if(mousePressed){
            if(getBtnIndex(programBtns)!=-1){
                /*
                  Quando premo uno dei ProgramButtons sulla sx -> activeProgram assegnando il valore alle
                  variabili globali. Perciò quando si mostreranno i {GuitarParamButton extends Button} si
                  controllerà {if guitarParamButton.value == globalValue => background = Red else background = white}
                */
            }
            else if(getBtnIndex(valueBtns)!=-1) {
                /* 
                  Quando premo un GuitarParamButton => arrayList.globalValue = guitarParamButton.value
                */
            }
            else if(getBtnIndex(programBtns)!=-1) {
                /*
                  Faccio la store nel file di testo
                */
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