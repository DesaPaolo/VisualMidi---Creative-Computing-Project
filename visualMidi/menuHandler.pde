/*Michele Menu's code*/

public void menuInit() {
  
  mode = 0; //Menu
  xBtn1 = 250; //Store
  yBtn1 = 100;
  xBtn2 = 600; //Load
  yBtn2 = 100;
  xBtn3 = 900; //Back to Menu
  yBtn3 = 100;
  xBtn4 = 100; //Play
  yBtn4 = 50;
  wBtn = 150;
  hBtn = 50;
  
  presets = new ArrayList<Preset>();
  loadButtons = new ArrayList<Rectangle>();
  
}

void mousePressed() {
  if(mode == 0) {
      if (buttonPressed(xBtn1, yBtn1, wBtn, hBtn)){
        mode = 1;
      }
      else if (buttonPressed(xBtn2, yBtn2, wBtn, hBtn)){
        mode = 2;
      }
      else if (buttonPressed(xBtn3, yBtn3, wBtn, hBtn)){
        mode = 3; //play
      }
    }
    else if (mode == 1 || mode == 2 || mode == 3){
      if (buttonPressed(xBtn4, yBtn4, wBtn, hBtn)){
        mode = 0;
      }
    }
    if(mode==1 && gettingUserInput){
      msg=INIT_MSG;
    }
    loop();
}

boolean buttonPressed(int x, int y, int width, int height){
  if (mouseX >= x && mouseX <= x+width && 
      mouseY >= y && mouseY <= y+height){
    return true;
  }
  else return false;
}

void storeMode(){
  
  int xStoreBtn = 500;
  int yStoreBtn = 200;
  gettingUserInput = true;
  background(0);
  text("Store Mode", 500, 100);
  
  fill(255);
  rect(xBtn4, yBtn4, wBtn, hBtn);
  fill(0);
  text("Back to Menu", (xBtn4 + 20), (yBtn4 + 20));
  fill(255);
  rect(xStoreBtn, yStoreBtn, wBtn, hBtn);
  fill(0);
  text("Store Preset", (xStoreBtn + 20), (yStoreBtn + 20));
  //prevDraw();
  if(gettingUserInput){
    showInputScanning();
  }
  
  if (mousePressed && buttonPressed(xStoreBtn, yStoreBtn, wBtn, hBtn)){
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
  Preset actualPreset = new Preset(name, actualDate, sustainPedal, modulation, modulationRate, cutOffFilter, times, ampSus);
  
  loadPresetsFromFile(); //salvataggio from file to var senza grafica
  addPreset(actualPreset); //Aggiunge preset controllando se overwrite
  
  for(int i=0; i<presets.size(); i++){
    storePresetToFile(presets.get(i));
  }
  
}

void loadPresets() throws Exception{ 
  
  loadPresetsFromFile(); //<>// //<>//
  //Iterator iterator = presets.iterator();
  drawMenuPresets();
}

int loadBtnClicked(ArrayList<Rectangle> buttons){
  for(int i=0; i<buttons.size(); i++){
    int x = buttons.get(i).getX();
    int y = buttons.get(i).getY();
    int w = buttons.get(i).getWidth();
    int h = buttons.get(i).getHeight();
    if(buttonPressed(x, y, w, h)){return buttons.get(i).getIndex();}
  }
  return -1;
}

void activatePreset(int index){
  Preset activePreset = presets.get(index);
  cutOffFilter = activePreset.getCutoffFil();
  times[0] = activePreset.getAttack();
  times[1] = activePreset.getDecay();
  times[2] = activePreset.getRelease();
  modulationRate = activePreset.getModRate();
  modulation = activePreset.getMod();
  sustainPedal = activePreset.getSusPedal();
  ampSus = activePreset.getAmpSus();
  
  return;
}

void addPreset (Preset presetToAdd){
  for(int i=0; i<presets.size(); i++){
    if (presets.get(i).getPresetName().equals(presetToAdd.getPresetName())){
      presets.remove(i);
      presets.add(i, presetToAdd);
      println("overwriting preset called " + presets.get(i).getPresetName());
      return;
    }  
  }
  presets.add(presetToAdd);
  println("saving new preset called " + presets.get(presets.size()-1).getPresetName());
  return;
}

void loadPresetsFromFile(){
  File file = new File("presets.txt"); 
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
        else if ((st.substring(0,5)).equals("name ")){newPreset.setPresetName(st.substring(5));}
        else if ((st.substring(0,5)).equals("date ")){newPreset.setCreationDate(new SimpleDateFormat("EEE MMM dd HH:mm:ss Z yyyy",  Locale.ENGLISH).parse(st.substring(5)));} 
        else if ((st.substring(0,10)).equals("decayTime ")){newPreset.setDecay(Float.parseFloat(st.substring(10)));}
        else if ((st.substring(0,11)).equals("modulation ")){newPreset.setMod(Float.parseFloat(st.substring(11)));}
        else if ((st.substring(0,11)).equals("attackTime ")){newPreset.setAttack(Float.parseFloat(st.substring(11)));}
        else if ((st.substring(0,11)).equals("sustainAmp ")){newPreset.setAmpSus(Float.parseFloat(st.substring(11)));}
        else if ((st.substring(0,12)).equals("releaseTime ")){newPreset.setRelease(Float.parseFloat(st.substring(12)));}
        else if ((st.substring(0,13)).equals("sustainPedal ")){newPreset.setSusPedal(Boolean.parseBoolean(st.substring(13)));}
        else if ((st.substring(0,13)).equals("cutoffFilter ")){newPreset.setCutoffFil(Integer.parseInt(st.substring(13)));}
        else if ((st.substring(0,15)).equals("modulationRate ")){newPreset.setModRate(Float.parseFloat(st.substring(15)));}
        else {System.out.println("Substring is " + st + " Error");}
      }
      br.close();
    } catch (Exception e) {
    // exception handling
      println(e);
  }
}

void drawMenuPresets(){
  int aListSize = presets.size();
  int xBox, yBox, wBox, hBox, leftMarginNames, upperMarginNames, hLine, xLoadBtn, yLoadBtn, wLoadBtn, hLoadBtn;
  //println("aListSize is " + aListSize);
  xBtn4 = 100;
  yBtn4 = 50;
  wBtn = 150;
  hBtn = 50;
  xBox = 800;
  yBox = 200;
  wBox = 450;
  hBox = aListSize*50;
  leftMarginNames = 20;
  upperMarginNames = 30;
  hLine = 20;
  xLoadBtn = 1100;
  yLoadBtn = ((yBox+upperMarginNames) - 15);
  wLoadBtn = 80;
  hLoadBtn = 15;
  
  background(0);
  fill(255);
  text("Load Mode", 500, 100);
  fill(255);
  rect(xBtn4, yBtn4, wBtn, hBtn);
  fill(0);
  text("Back to Menu", (xBtn4 + 20), (yBtn4 + 20));
  
  fill(255);
  rect(xBox, yBox, wBox, hBox);
  for(int i=0; i<aListSize; i++){
    fill(0);
    text((presets.get(i).getPresetName() + "\t  " + presets.get(i).getCreationDate()), xBox+leftMarginNames, ((yBox+upperMarginNames) + (i*hLine)));
    fill(0);
    rect(xLoadBtn, (yLoadBtn + (i*hLine)), wLoadBtn, hLoadBtn);
    Rectangle newRect = new Rectangle(xLoadBtn, (yLoadBtn + (i*hLine)), wLoadBtn, hLoadBtn, i);
    loadButtons.add(newRect);
    fill(255);
    text("Load", (xLoadBtn + 20), (yLoadBtn + (i*hLine)+12));
  }
  if(mousePressed){
    if(loadBtnClicked(loadButtons)!= -1){
      activatePreset(loadBtnClicked(loadButtons));
    }  
  }
  //while (iterator.hasNext()){}
    //println(iterator.next().toString());
  //}
}

void storePresetToFile (Preset actualPreset){
  try{
    FileWriter fileWriter = new FileWriter("presets.txt");
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
    fileWriter.write("end\n");
    fileWriter.close(); 
    println("saved preset");
  } catch (IOException e) {
    // exception handling
    println("IO Exception");
  }
}

void showInputScanning(){
  fill(255);
  text(msg, 100, 200);
  
  fill(0,250,0);
  text("Mouse click to reset message, Return to store", 100, 250);
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
