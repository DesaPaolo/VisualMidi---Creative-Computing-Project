class ProgramStoreMenu extends Menu {

    ArrayList<Button> programBtns = new ArrayList<Button>();
    ArrayList<GuitarParamButton> ampBtns = new ArrayList<GuitarParamButton>();
    ArrayList<GuitarParamButton> eqBtns = new ArrayList<GuitarParamButton>();
    ArrayList<GuitarParamButton> reverbBtns = new ArrayList<GuitarParamButton>();
    ArrayList<GuitarParamButton> overdriveBtns = new ArrayList<GuitarParamButton>();
    ArrayList<GuitarParamButton> modulationBtns = new ArrayList<GuitarParamButton>();
    Button storeBtn = new Button(300, 500, wBtn, hBtn, "Store");
    ArrayList<Button> storeBtns = new ArrayList<Button>(); 

    public ProgramStoreMenu(int size) {

        super("Edit Program", size, "");
        storeBtns.add(storeBtn);
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
        Button newBtn = new Button(xBtn, ((yBtn-hBox/2) + marginTop + ((this.numberOfElements)*hLine)), wBtn, hBtn, ("PC " + (this.numberOfElements+1)));
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

                activateProgram(getBtnIndex(programBtns));
                applyModelToGtrBtns(gtrEq, eqBtns);
                applyModelToGtrBtns(gtrReverb, reverbBtns);
                applyModelToGtrBtns(gtrModulation, modulationBtns);
                applyModelToGtrBtns(gtrOverdrive, overdriveBtns);
                applyModelToGtrBtns(gtrAmp, ampBtns);
            }
            else if(getGtrParamBtnIndex(eqBtns)!=-1) {
                gtrEq = eqBtns.get(getGtrParamBtnIndex(eqBtns)).getValue();
                guitarPrograms.get(getGtrParamBtnIndex(eqBtns)).setEq(gtrEq);
                applyModelToGtrBtns(gtrEq, eqBtns);
            }
            else if(getGtrParamBtnIndex(reverbBtns)!=-1) {
                gtrReverb = reverbBtns.get(getGtrParamBtnIndex(reverbBtns)).getValue();
                guitarPrograms.get(getGtrParamBtnIndex(reverbBtns)).setReverb(gtrReverb);
                applyModelToGtrBtns(gtrReverb, reverbBtns);
            }
            else if(getGtrParamBtnIndex(modulationBtns)!=-1) {
                gtrModulation = modulationBtns.get(getGtrParamBtnIndex(modulationBtns)).getValue();
                guitarPrograms.get(getGtrParamBtnIndex(modulationBtns)).setEq(gtrModulation);
                applyModelToGtrBtns(gtrModulation, modulationBtns);
            }
            else if(getGtrParamBtnIndex(overdriveBtns)!=-1) {
                gtrOverdrive = overdriveBtns.get(getGtrParamBtnIndex(overdriveBtns)).getValue();
                guitarPrograms.get(getGtrParamBtnIndex(overdriveBtns)).setEq(gtrOverdrive);
                applyModelToGtrBtns(gtrOverdrive, overdriveBtns);
            }
            else if(getGtrParamBtnIndex(ampBtns)!=-1) {
                gtrAmp = ampBtns.get(getGtrParamBtnIndex(ampBtns)).getValue();
                guitarPrograms.get(getGtrParamBtnIndex(ampBtns)).setEq(gtrAmp);
                applyModelToGtrBtns(gtrAmp, ampBtns);
            }

            else if(getBtnIndex(storeBtns)!=-1) {
                savePrograms();
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

    public void applyModelToGtrBtns (String modelParam, ArrayList<GuitarParamButton> buttonList) {
        for(int i=0; i<buttonList.size(); i++){
            if(buttonList.get(i).getValue().equals(modelParam)){
                buttonList.get(i).setBackgroundColor(color(255, 0, 0));
            } else {
                buttonList.get(i).setBackgroundColor(color(255));
            }
        }
    }

}