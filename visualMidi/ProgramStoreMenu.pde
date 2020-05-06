/**
 * Deprecated class
 */
public class ProgramStoreMenu extends Menu {

    ArrayList<Button> programBtns = new ArrayList<Button>();
    ArrayList<GuitarParamButton> ampBtns = new ArrayList<GuitarParamButton>();
    ArrayList<GuitarParamButton> eqBtns = new ArrayList<GuitarParamButton>();
    ArrayList<GuitarParamButton> reverbBtns = new ArrayList<GuitarParamButton>();
    ArrayList<GuitarParamButton> overdriveBtns = new ArrayList<GuitarParamButton>();
    ArrayList<GuitarParamButton> modulationBtns = new ArrayList<GuitarParamButton>();
    Button storeBtn = new Button((int)(width/2), (int)(height*0.8), 100, hBtn, "Store");
    int maxSize = 8;
    int labelXPos = (int)(width/2-280);  
    int xPosBtn = (int)(width/2-110);
    int yPosBtn = (int)(height/2+50);

    public ProgramStoreMenu(int size) {

        super("Edit Program", size, "");
        this.createButtons(xPosBtn, yPosBtn);
        super.xBox = 300;
        super.yBox = 350;
        super.wBox = 300;
        super.hLine = 70;
    }

    public void createButtons(int xBtn, int yBtn) {
        super.wBtn = 115;
        overdriveValues = new ArrayList<String>(Arrays.asList("none", "boost", "overdrive", "distortion", "fuzz"));
        ampValues = new ArrayList<String>(Arrays.asList("clean", "crunch", "hiGain"));
        eqValues = new ArrayList<String>(Arrays.asList("warm", "normal", "bright"));
        modulationValues = new ArrayList<String>(Arrays.asList("none", "chorus", "phaser", "flanger"));
        reverbValues = new ArrayList<String>(Arrays.asList("small", "medium", "large"));
        println("Size: " + this.numberOfElements);

        for(int i = 0; i < this.numberOfElements; i++) {

            Button newBtn = new Button(xBtn-400, ((yBtn-hBox/2) + marginTop + (i*70)), wBtn+20, hBtn, ("PC " + (i+1)));
            newBtn.setIndex(i);
            
            programBtns.add(newBtn);
        }
        if(programBtns.size()<maxSize){ 
        Button newBtnToAdd = new Button(xBtn-400, ((yBtn-hBox/2) + marginTop + ((this.numberOfElements)*70)), wBtn+20, hBtn, ("New: PC " + (this.numberOfElements+1)));
        newBtnToAdd.setIndex(this.numberOfElements);
        programBtns.add(newBtnToAdd);
        GuitarProgram newProgram = new GuitarProgram();
        guitarPrograms.add(newProgram);
        }
        activateProgram(currentProgramIndex);
        programBtns.get(currentProgramIndex).setBackgroundColor(color(255, 0, 0));

        for(int i = 0; i < overdriveValues.size(); i++) {

            GuitarParamButton newBtn = new GuitarParamButton((overdriveValues.get(i)), xBtn + (i*120), ((yBtn-hBox/2) + (marginTop)), wBtn, hBtn, (overdriveValues.get(i)));
            if (newBtn.getValue().equals(guitarPrograms.get(currentProgramIndex).getOverdrive())){
                newBtn.setBackgroundColor(color(255, 0, 0));
            }
            newBtn.setIndex(i);
            overdriveBtns.add(newBtn);
        }

        for(int i = 0; i < ampValues.size(); i++) {

            GuitarParamButton newBtn = new GuitarParamButton((ampValues.get(i)), xBtn + (i*120), ((yBtn-hBox/2) + (marginTop+70)), wBtn, hBtn, (ampValues.get(i)));
            if (newBtn.getValue().equals(guitarPrograms.get(currentProgramIndex).getAmp())){
                newBtn.setBackgroundColor(color(255, 0, 0));
            }
            newBtn.setIndex(i);
            ampBtns.add(newBtn);
        }

        for(int i = 0; i < eqValues.size(); i++) {

            GuitarParamButton newBtn = new GuitarParamButton((eqValues.get(i)), xBtn + (i*120), ((yBtn-hBox/2) + marginTop+70*2), wBtn, hBtn, (eqValues.get(i)));
            if (newBtn.getValue().equals(guitarPrograms.get(currentProgramIndex).getEq())){
                newBtn.setBackgroundColor(color(255, 0, 0));
            }
            newBtn.setIndex(i);
            eqBtns.add(newBtn);
        }

        for(int i = 0; i < modulationValues.size(); i++) {

            GuitarParamButton newBtn = new GuitarParamButton((modulationValues.get(i)), xBtn + (i*120), ((yBtn-hBox/2) + marginTop+70*3), wBtn, hBtn, (modulationValues.get(i)));
            if (newBtn.getValue().equals(guitarPrograms.get(currentProgramIndex).getModulation())){
                newBtn.setBackgroundColor(color(255, 0, 0));
            }
            newBtn.setIndex(i);
            modulationBtns.add(newBtn);
        }

        for(int i = 0; i < reverbValues.size(); i++) {

            GuitarParamButton newBtn = new GuitarParamButton((reverbValues.get(i)), xBtn + (i*120), ((yBtn-hBox/2) + marginTop+70*4), wBtn, hBtn, (reverbValues.get(i)));
            if (newBtn.getValue().equals(guitarPrograms.get(currentProgramIndex).getReverb())){
                newBtn.setBackgroundColor(color(255, 0, 0));
            }
            newBtn.setIndex(i);
            reverbBtns.add(newBtn);
        }

    }

    public void mousePressedEvent() {
        if(mousePressed){
            if(getBtnIndex(programBtns)!=-1){
                /*
                  Quando premo uno dei ProgramButtons sulla sx -> activeProgram assegnando il valore alle
                  variabili globali. Perciò quando si mostreranno i {GuitarParamButton extends Button} si
                  controllerà {if guitarParamButton.value == globalValue => background = Red else background = white}
                */
                programBtns.get(currentProgramIndex).setBackgroundColor(color(255));
                activateProgram(getBtnIndex(programBtns));
                programBtns.get(currentProgramIndex).setBackgroundColor(color(255, 0, 0));
                applyModelToGtrBtns(gtrEq, eqBtns);
                applyModelToGtrBtns(gtrReverb, reverbBtns);
                applyModelToGtrBtns(gtrModulation, modulationBtns);
                applyModelToGtrBtns(gtrOverdrive, overdriveBtns);
                applyModelToGtrBtns(gtrAmp, ampBtns);
            }
            else if(getGtrParamBtnIndex(eqBtns)!=-1) {
                gtrEq = eqBtns.get(getGtrParamBtnIndex(eqBtns)).getValue();
                guitarPrograms.get(currentProgramIndex).setEq(gtrEq);
                println("UPDATING EQ VALUE: "+ guitarPrograms.get(currentProgramIndex).getEq());
                applyModelToGtrBtns(gtrEq, eqBtns);
            }
            else if(getGtrParamBtnIndex(reverbBtns)!=-1) {
                gtrReverb = reverbBtns.get(getGtrParamBtnIndex(reverbBtns)).getValue();
                guitarPrograms.get(currentProgramIndex).setReverb(gtrReverb);
                println("UPDATING REVERB VALUE: "+ guitarPrograms.get(currentProgramIndex).getEq());
                applyModelToGtrBtns(gtrReverb, reverbBtns);
            }
            else if(getGtrParamBtnIndex(modulationBtns)!=-1) {
                gtrModulation = modulationBtns.get(getGtrParamBtnIndex(modulationBtns)).getValue();
                guitarPrograms.get(currentProgramIndex).setModulation(gtrModulation);
                println("UPDATING MODULATION VALUE: "+ guitarPrograms.get(currentProgramIndex).getEq());
                applyModelToGtrBtns(gtrModulation, modulationBtns);
            }
            else if(getGtrParamBtnIndex(overdriveBtns)!=-1) {
                gtrOverdrive = overdriveBtns.get(getGtrParamBtnIndex(overdriveBtns)).getValue();
                guitarPrograms.get(currentProgramIndex).setOverdrive(gtrOverdrive);
                println("UPDATING OVERDRIVE VALUE: "+ guitarPrograms.get(currentProgramIndex).getEq());
                applyModelToGtrBtns(gtrOverdrive, overdriveBtns);
            }
            else if(getGtrParamBtnIndex(ampBtns)!=-1) {
                gtrAmp = ampBtns.get(getGtrParamBtnIndex(ampBtns)).getValue();
                println("Null pointer check " + getGtrParamBtnIndex(ampBtns));
                guitarPrograms.get(currentProgramIndex).setAmp(gtrAmp);
                println("UPDATING REVERB VALUE: "+ guitarPrograms.get(currentProgramIndex).getEq());
                applyModelToGtrBtns(gtrAmp, ampBtns);
            }
            else if(storeBtn.isPressed()) {
                println("Store Button pressed");
                if (currentProgramIndex != (guitarPrograms.size()-1) && currentProgramIndex<7){
                    //guitarPrograms.remove(guitarPrograms.size()-1);
                }
                else {
                    programBtns.get(currentProgramIndex).setText("PC " + (currentProgramIndex+1));
                    if(currentProgramIndex<maxSize-1){
                    Button newBtnToAdd = new Button(xPosBtn-400, (programBtns.get(guitarPrograms.size()-1).getYPos()+70), wBtn+20, hBtn, ("New: PC " + (currentProgramIndex+2)));
                    newBtnToAdd.setIndex(currentProgramIndex+1);
                    programBtns.add(newBtnToAdd);
                    GuitarProgram newProgram = new GuitarProgram();
                    guitarPrograms.add(newProgram);
                    }
                }
                /*Bisogna aggiornare anche l'elemento corrente di guitarPrograms*/
                println("###CURRENT GUITAR PROGRAM ON GLOBAL VARIABLE: "+guitarPrograms.get(currentProgramIndex));
                println("Saving current index" + currentProgramIndex);
                guitarPrograms.get(currentProgramIndex).setName("Program " + (currentProgramIndex));
                savePrograms();
                //storeBtn.setBackgroundColor(color(0, 255, 0));
                //storeBtn.setBackgroundColor(color(255));
                
            }
            else if(backToMenuBtn.isPressed()){
                println("Back Pressed, size: " + guitarPrograms.size());
                //loadGuitarProgramsFromFile();
                guitarPrograms.remove(guitarPrograms.size()-1);
                loadGuitarProgramsFromFile();
                println("Removed, size: " + guitarPrograms.size());
            }
        }

    }

    public void showMenu() {

        fill(255);
        text(title, width/2, 60); 
        fill(255);
        
        backToMenuBtn.showBtn();
        
        for(int i = 0; i < programBtns.size(); i++){
            programBtns.get(i).showBtn(); 
        }
        for(int i = 0; i < overdriveBtns.size(); i++){
            overdriveBtns.get(i).showBtn(); 
        }
        for(int i = 0; i < ampBtns.size(); i++){
            ampBtns.get(i).showBtn(); 
        }
        for(int i = 0; i < eqBtns.size(); i++){
            eqBtns.get(i).showBtn(); 
        }
        for(int i = 0; i < modulationBtns.size(); i++){
            modulationBtns.get(i).showBtn(); 
        }
        for(int i = 0; i < reverbBtns.size(); i++){
            reverbBtns.get(i).showBtn(); 
        }
        storeBtn.showBtn();
        fill(255);
        text("Modulation",labelXPos,(((int)(height/2+50)-hBox/2) + marginTop+70*3));
        text("Equalizer",labelXPos,(((int)(height/2+50)-hBox/2) + marginTop+70*2));
        text("Reverb",labelXPos,(((int)(height/2+50)-hBox/2) + marginTop+70*4));
        text("OD/Distortion",labelXPos,(((int)(height/2+50)-hBox/2) + marginTop));
        text("Amplifier",labelXPos,(((int)(height/2+50)-hBox/2) + marginTop+70));
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