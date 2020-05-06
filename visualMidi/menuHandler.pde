public void menuInit() {

  mode = 0;
  wBtn = 180;
  hBtn = 60;
  float centerPosition = width/2;
  int offset = (int)(width*0.20);
  final float OMOGENEOUS_COEFF = 1.2;
  xBtnStoreMode = (int) (width*0.20);
  yBtnStoreMode = (int) (height * .15);
  xBtnLoadMode = (int) ( width*0.40);
  yBtnLoadMode = (int) (height * .15);
  xBtnPlayMode = (int) (width*0.60);
  yBtnPlayMode = (int) (height * .15);
  xBtnBackToMenu = (int) (width*0.12);
  yBtnBackToMenu = (int) (height * .075);
  int xBtnDeviceMode = (int) (width*0.80);
  //int xBtnGuitarDeviceMode = (int) (centerPosition  + 3*distanceFactor-offset);

  storeModeBtn = new Button(xBtnStoreMode, yBtnStoreMode, wBtn, hBtn, "Store Mode", color(255), color(0));
  loadModeBtn = new Button(xBtnLoadMode, yBtnLoadMode, wBtn, hBtn, "Load Mode", color(255), color(0));
  playModeBtn = new Button(xBtnPlayMode, yBtnPlayMode, wBtn, hBtn, "Play Mode", color(255), color(0));
  backToMenuBtn = new Button(xBtnBackToMenu, yBtnBackToMenu, wBtn-15, hBtn-5, "Back to Menu", color(255), color(0));
  deviceModeBtn = new Button(xBtnDeviceMode, yBtnPlayMode, wBtn, hBtn, "Change Device", color(255), color(0));
  //programStoreModeBtn = new Button(xBtnGuitarDeviceMode, yBtnPlayMode, wBtn+80, hBtn, "Edit Guitar Programs", color(255), color(0));
  presets = new ArrayList<Preset>();
  loadPresetsFromFile();
  loadButtons = new ArrayList<Button>();
  getColorRandom();
  
}

void mousePressed() {
  println("MOUSE PRESSED!!!!!");
  
  /* Debugging Code
  float a = xBtn1 + wBtn;
  float b = xBtn2 +wBtn;
  float c = xBtn3 +wBtn;
  float d = yBtn1 + hBtn;
  println("Actual mode is: "+ mode +"mouse is pressed in position " + "x: "+mouseX +"y: "+mouseY+"\n");
  println("store button extension from x= " + xBtn1 + "to x=" + a +"from y= "+yBtn1 +"to y= "+ d +"\n");
  println("load button extension from x= " + xBtn2 + "to x=" + b +"from y= "+yBtn2 +"to y= "+ d +"\n");
  println("play button extension from x= " + xBtn3 + "to x=" + c +"from y= "+yBtn3 +"to y= "+ d +"\n");
  */

  if(mode == 0) {

      if (storeModeBtn.isPressed()){
        mode = 1; //store
      }
      else if (loadModeBtn.isPressed()){

        loadPresetsFromFile(); 
        loadMenu = new LoadMenu(presets.size());
        mode = 2; //load
      }
      else if (playModeBtn.isPressed()){
        mode = 3; //play
        loop(); //Mi accerto che torni il loop
      }
      else if(deviceModeBtn.isPressed()) {
        deviceMenu = new DeviceMenu(Arrays.asList(MidiBus.availableInputs()).size());
        guitarMenu = new GuitarMenu(Arrays.asList(MidiBus.availableInputs()).size());
        mode = 4;
      }
      /*else if(programStoreModeBtn.isPressed()){
        loadGuitarProgramsFromFile();
        programStoreMenu = new ProgramStoreMenu(guitarPrograms.size());
        mode = 5;
      }*/

    }

    else if (mode == 1 || mode == 2 || mode ==4 || mode == 5){
      if (backToMenuBtn.isPressed()){
        cleanScreen();
        println("Passo da 1 a 0");
        if (mode == 5){
          programStoreMenu.mousePressedEvent();
        }
        mode = 0;
      }
    }
    if(mode==1 && gettingUserInput){
      msg=INIT_MSG;
    }

    if(mode==2) {
      loadMenu.mousePressedEvent();
    }
    if(mode==4 && deviceMenu!=null) {

      deviceMenu.mousePressedEvent();
      guitarMenu.mousePressedEvent();
    }
    if(mode==5) {
      programStoreMenu.mousePressedEvent();
      
    }
    loop();
}
void deviceMode() {
  noLoop();
  cleanScreen();
  deviceMenu.showMenu();
  guitarMenu.showMenu();
}

void storeMode(){
  cleanScreen();
  int xStoreBtn = width/2;
  int yStoreBtn = (height/2)-150;
  
  doStoreBtn = new Button (xStoreBtn, yStoreBtn, wBtn, hBtn, "Store Preset", color(255), color(0));
  
  gettingUserInput = true;
  background(0);
  textAlign(CENTER, CENTER);
  rectMode(CENTER);
  fill(0);
  text("Store Mode", width/2, height * .05);
  
  backToMenuBtn.showBtn();
  
  doStoreBtn.showBtn();
  
  //prevDraw();
  if(gettingUserInput){
    showInputScanning();
  }
  
  if (doStoreBtn.isPressed()){
    noLoop();
    //println("Calling savePreset");
    savePreset();
  }
}

void loadMode(){
  //prevDraw();
  
  try {
    loadPresets();
  } catch (Exception ex) {}
}

void savePreset(){
  String name = finalMsg;
  Date actualDate = Calendar.getInstance().getTime();
  Preset actualPreset = new Preset(name, actualDate, sustainPedal, modulation, modulationRate, cutOffFilter, times, ampSus, EGAmpSus, times[0], times[1], times[3], poly, EGInt, hiPassDly, timeDly, feedbackDly, isActiveDly, id);
  
  loadPresetsFromFile(); //salvataggio from file to var senza grafica
  addPreset(actualPreset); //Aggiunge preset controllando se overwrite
  try{
    FileWriter fileWriter = new FileWriter(sketchPath("presets.txt"));
    
    for(int i=0; i<presets.size(); i++){
      //println("preset size is " + presets.size() + " now we are in index " + i);
      storePresetToFile(presets.get(i), fileWriter);
      //println("saved preset " + presets.get(i).getPresetName());
    }
    
    fileWriter.close(); 
    println("Closed");
  } catch (IOException e) {
    // exception handling
    println("IO Exception");
  }
  loop();
}

void loadPresets() throws Exception{ 
  noLoop();
  //loadPresetsFromFile(); //<>// //<>// //<>// //<>//
  //Iterator iterator = presets.iterator();
  //loadMenu = new LoadMenu(presets.size());
  loadMenu.showMenu();
  //drawMenuPresets();
}

int getGtrParamBtnIndex(ArrayList<GuitarParamButton> buttons){
  for(int i=0; i<buttons.size(); i++){
    if(buttons.get(i).isPressed()){return buttons.get(i).getIndex();}
  }
  return -1;
}

int getBtnIndex(ArrayList<Button> buttons){
  for(int i=0; i<buttons.size(); i++){
    if(buttons.get(i).isPressed()){return buttons.get(i).getIndex();}
  }
  return -1;
}

void activatePreset(int index){
  //println("$$$$$$$$$$$$$ Index: "+ index);
  int ind = getIndexOfPreset(index);
  //println("$$$$$$$$$$$$$ Ind: "+ ind);
  if(ind!=-1){
  Preset activePreset = presets.get(ind);
  //println("@@@@@@@@@@@@@@CALLED PRESET: " + activePreset.getPresetName());
  cutOffFilter = activePreset.getCutoffFil();
  times[0] = activePreset.getAttack();
  times[1] = activePreset.getDecay();
  times[2] = -1;
  times[3] = activePreset.getRelease();
  EGTimes[0] = activePreset.getAtckTimeEG();
  EGTimes[1] = activePreset.getDcyTimeEG();
  EGTimes[2] = -1;
  EGTimes[3] = activePreset.getRelTimeEG();
  modulationRate = activePreset.getModRate();
  modulation = activePreset.getMod();
  sustainPedal = activePreset.getSusPedal();
  ampSus = activePreset.getAmpSus();
  EGAmpSus = activePreset.getSusAmpEG();
  poly = activePreset.getPoly();
  EGInt = activePreset.getIntEG();
  hiPassDly = activePreset.getHiPassDly();
  timeDly = activePreset.getTimeDly();
  feedbackDly = activePreset.getFeedbackDly();
  isActiveDly = activePreset.getIsActiveDly();
  println(activePreset.toString());
  }

  return;
}

int getIndexOfPreset(int id) {
  println("*****presets size: "+ presets.size());
  for(int i = 0; i< presets.size(); i++){
    if(presets.get(i).getId()==id) return i;
     println("i: "+i);
  }
  return -1;
}

void addPreset (Preset presetToAdd){
  //println("ADDING PRESET");
  for(int i=0; i<presets.size(); i++){
    if (presets.get(i).getPresetName().equals(presetToAdd.getPresetName())){
      presets.remove(i);
      presets.add(i, presetToAdd);
      //println("overwriting preset called " + presets.get(i).getPresetName());
      return;
    }  
  }
  presets.add(presetToAdd);
  //println("adding new preset called " + presets.get(presets.size()-1).getPresetName());
  return;
}

void loadPresetsFromFile(){
  //println("LOADING PRESETS FROM FILE");
  File file = new File(sketchPath("presets.txt")); 
    try {
      BufferedReader br = new BufferedReader(new FileReader(file)); 
      Preset newPreset;
      String st;
      
      newPreset = new Preset(); 
      while ((st = br.readLine()) != null) {
        //System.out.println(st);
        //println(st.equals("sustainAmp 0.0"));
        if (st.equals("start")) {
          //println("Starting");
          newPreset = new Preset(); 
        }
        else if ((st.equals("end"))){
            //println("i'm done");
            addPreset(newPreset); //Exception
          }
        else if (st.isEmpty()){}
        else if ((st.substring(0,3)).equals("id ")){newPreset.setId(Integer.parseInt(st.substring(3)));}
        else if ((st.substring(0,5)).equals("name ")){newPreset.setPresetName(st.substring(5));}
        else if ((st.substring(0,5)).equals("poly ")){newPreset.setPoly(Boolean.parseBoolean(st.substring(5)));}
        else if ((st.substring(0,5)).equals("date ")){newPreset.setCreationDate(new SimpleDateFormat("EEE MMM dd HH:mm:ss Z yyyy",  Locale.ENGLISH).parse(st.substring(5)));}
        else if ((st.substring(0,7)).equals("EG int ")){newPreset.setIntEG(Float.parseFloat(st.substring(7)));} 
        else if ((st.substring(0,10)).equals("decayTime ")){newPreset.setDecay(Float.parseFloat(st.substring(10)));}
        else if ((st.substring(0,11)).equals("modulation ")){newPreset.setMod(Float.parseFloat(st.substring(11)));}
        else if ((st.substring(0,11)).equals("attackTime ")){newPreset.setAttack(Float.parseFloat(st.substring(11)));}
        else if ((st.substring(0,11)).equals("sustainAmp ")){newPreset.setAmpSus(Float.parseFloat(st.substring(11)));}
        else if ((st.substring(0,11)).equals("time delay ")){newPreset.setTimeDly(Float.parseFloat(st.substring(11)));}
        else if ((st.substring(0,12)).equals("releaseTime ")){newPreset.setRelease(Float.parseFloat(st.substring(12)));}
        else if ((st.substring(0,13)).equals("sustainPedal ")){newPreset.setSusPedal(Boolean.parseBoolean(st.substring(13)));}
        else if ((st.substring(0,13)).equals("EG decayTime ")){newPreset.setDcyTimeEG(Float.parseFloat(st.substring(13)));}
        else if ((st.substring(0,13)).equals("cutoffFilter ")){newPreset.setCutoffFil(Float.parseFloat(st.substring(13)));}
        else if ((st.substring(0,13)).equals("hipass delay ")){newPreset.setHiPassDly(Float.parseFloat(st.substring(13)));}
        else if ((st.substring(0,14)).equals("EG attackTime ")){newPreset.setAtckTimeEG(Float.parseFloat(st.substring(14)));}
        else if ((st.substring(0,14)).equals("EG sustainAmp ")){newPreset.setSusAmpEG(Float.parseFloat(st.substring(14)));}
        else if ((st.substring(0,15)).equals("EG releaseTime ")){newPreset.setRelTimeEG(Float.parseFloat(st.substring(15)));}
        else if ((st.substring(0,15)).equals("modulationRate ")){newPreset.setModRate(Float.parseFloat(st.substring(15)));}
        else if ((st.substring(0,15)).equals("feedback delay ")){newPreset.setFeedbackDly(Float.parseFloat(st.substring(15)));}
        else if ((st.substring(0,15)).equals("isActive delay ")){newPreset.setIsActiveDly(Boolean.parseBoolean(st.substring(15)));}
        else {System.out.println("Substring is " + st + " Error");}
      }
      br.close();
    } catch (Exception e) {
    // exception handling
      println(e);
  }
}
/*DEPRECATED*/
void drawMenuPresets(){
  int aListSize = presets.size();
  //println("alistSize: "+ aListSize);
  int xBox, yBox, wBox, hBox, leftMarginNames, upperMarginNames, hLine, xLoadBtn, yLoadBtn, wLoadBtn, hLoadBtn;
  //println("aListSize is " + aListSize);
  xBox = width/2;
  yBox = 200;
  wBox = 450;
  hBox = aListSize*60;
  leftMarginNames = 20;
  upperMarginNames = 30;
  hLine = 30;
  xLoadBtn = xBox+wBox-100;
  yLoadBtn = (yBox);
  wLoadBtn = 80;
  hLoadBtn = 60;
  
  background(0);
  fill(255);
  text("Load Mode", width/2, height * .06); //titolo
  fill(255);
  
  backToMenuBtn.showBtn();
  
  fill(255);
  rect(xBox, yBox, wBox, hBox); //box contenente i preset da salvare

  for(int i=0; i<aListSize; i++){
    Button newBtn = new Button(xLoadBtn, (yLoadBtn + (i*hLine)+10), wLoadBtn, hLoadBtn, "Load");
    newBtn.setIndex(i);
    loadButtons.add(newBtn);
    newBtn.showBtn();
    
    fill(0);
    text((presets.get(i).getPresetName() /*+ "\t  " + presets.get(i).getCreationDate()*/), xBox, (yBox + (i*hLine)+10));

  }/*
  if(mousePressed){
    println("!!!!!!!!!!!!!!!PRESSED ON LOAD!!!!!!!");
    if(loadBtnClicked(loadButtons)!= -1){
      activatePreset(loadBtnClicked(loadButtons));
    }  
  }*/
  //while (iterator.hasNext()){}
    //println(iterator.next().toString());
  //}
}

void storePresetToFile (Preset actualPreset, FileWriter fileWriter){
  try{
    fileWriter.write("start\n");
    fileWriter.write("name " + actualPreset.getPresetName() + "\n");
    fileWriter.write("date " + actualPreset.getCreationDate() +"\n");
    fileWriter.write("sustainPedal " + actualPreset.getSusPedal() + "\n");
    fileWriter.write("modulation " + actualPreset.getMod() + "\n");
    fileWriter.write("modulationRate " + actualPreset.getModRate() + "\n");
    fileWriter.write("cutoffFilter " + actualPreset.getCutoffFil() + "\n");
    fileWriter.write("attackTime " + actualPreset.getAttack() + "\n");
    fileWriter.write("decayTime " + actualPreset.getDecay() + "\n");
    fileWriter.write("sustainAmp " + actualPreset.getAmpSus() + "\n");
    fileWriter.write("releaseTime " + actualPreset.getRelease() + "\n");
    fileWriter.write("EG attackTime " + actualPreset.getAtckTimeEG() + "\n");
    fileWriter.write("EG decayTime " + actualPreset.getDcyTimeEG() + "\n");
    fileWriter.write("EG sustainAmp " + actualPreset.getSusAmpEG() + "\n");
    fileWriter.write("EG releaseTime " + actualPreset.getRelTimeEG() + "\n");
    fileWriter.write("EG int " + actualPreset.getIntEG() + "\n");
    fileWriter.write("poly " + actualPreset.getPoly() + "\n");
    fileWriter.write("hipass delay " + actualPreset.getHiPassDly() + "\n");
    fileWriter.write("time delay " + actualPreset.getTimeDly() + "\n");
    fileWriter.write("feedback delay " + actualPreset.getFeedbackDly() + "\n");
    fileWriter.write("isActive delay " + actualPreset.getIsActiveDly() + "\n");
    fileWriter.write("id "+actualPreset.getId() +"\n");
    fileWriter.write("end\n");
  } catch (IOException e) {
      // exception handling
      println("IO Exception");
    }
}

void showInputScanning(){
  fill(0,230,25);
  text(msg, width/2, height/2);
  
  fill(0,250,0);
  text("Mouse click to reset message, Return to set the name, Click \"Store\" to Store", width/2, (height/2)+80);
}

void scanInput(){
  if ( (key>='a' && key<='z') ||
    (key>='A' && key<='Z') ||
    (key>='0' && key<='9') 
    ) {
    msg+=key;
  }
  if (key == ENTER){
    finalMsg = msg;
    msg = "Got it!";
    gettingUserInput = false;
    println("Final Message is " +finalMsg + ".");
  }
}

void keyPressed(){
  if (gettingUserInput){
    if (msg.equals(INIT_MSG)) {
      msg="";
    }
    scanInput();
  }
}

void programStoreMode(){
  cleanScreen();
  noLoop();
  programStoreMenu.showMenu();
}
