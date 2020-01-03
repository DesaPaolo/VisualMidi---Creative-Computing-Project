//Branch refactoring

int choice;
PImage startscreen;
PFont newFont;
int mode;
int xBtn1, yBtn1, wBtn, hBtn, xBtn2, yBtn2, xBtn3, yBtn3, xBtn4, yBtn4;


void setup() {

  size(1920,1800, P3D);
  //fullScreen(P3D);
  background(0);
  startscreen = loadImage("korg.jpg");
  image(startscreen, 0, 0);
  

  MidiBus.list(); // List all our MIDI devices
  minilogue = new MidiBus(this, 1, 3);// Connect to one of the devices
  //instrumentType = 0;
  //sustainedNotes = new ArrayList <Note>();
  //prevNote = new Note(0, 0);
  
  adsrInit();

  //Ani.init(this); // Animation library init 
  
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

  
}

void draw() {
  
  println("mode: " + mode);
 
  if (mode == 0){ //menu
    image(startscreen, 0, 0);
    text("Welcome to Korg Minilogue's Visual MIDI", 600, 70);
    fill(255);
    rect(xBtn1, yBtn1, wBtn, hBtn);
    fill(0);
    text("Store Mode", (xBtn1 + 20), (yBtn1 + 20));
    fill(255);
    rect(xBtn2, yBtn2, wBtn, hBtn);
    fill(0);
    text("Load Mode", (xBtn2 + 20), (yBtn2 + 20));
    fill(255);
    rect(xBtn3, yBtn3, wBtn, hBtn);
    fill(0);
    text("Play Mode", (xBtn3 + 20), (yBtn3 + 20));
    noLoop();
  }
  else if (mode == 1){ //store
    storeMode();
  }
  else if (mode == 2){ //play
    loadMode();
  }
  else if (mode == 3){ //play
    playDraw();
  }
  
 
}

void keyPressed(){
  if (gettingUserInput){
    scanInput();
    showInputScanning();
  }
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

private void removeNote(Note note) {
    note.toRemove = true;
}

void playDraw(){
  
  //background
  fill(cutOffFilter);
  rect(0, 0, width, height);
  lights();
    
  fill(255);  
  text("Play Mode", 500, 100);
  fill(255);
  rect(xBtn4, yBtn4, wBtn, hBtn);
  fill(0);
  text("Back to Menu", (xBtn4 + 20), (yBtn4 + 20));
 
  //Chiama update della view per ogni nota. Da aggiungere differenza tra monofonia e polifonia e limite 
  //massimo di voci a 4, per rispecchiare sempre l'audio output del minilogue.
  if (!tempNotes.isEmpty()) {
    for (int i=0; i<tempNotes.size(); i++ ) { 
      
      tempNotes.get(i).filterRamp.trigger();
      tempNotes.get(i).ramp.trigger();
      tempNotes.get(i).update();
     
    }
  }
 
}

/*Antonino Code*/
/*When attack finishes this function is called and generates the decay ramp. It's also called when sustain finishes this*/
private void nextRamp(Note note) {

  int step = note.ramp.stepId;
  switch(step){
    case 1:
      //println("REACHED DECAY");
      note.ramp = new Ramp(times[step], millis(), 0, step, note.adsrValues[0], note.adsrValues[1], note, false);
      break;
    case 2: 
      //println("REACHED SUSTAIN");
      break; 
    case 3:
      //println("REACHED Release");
      note.ramp = new Ramp(times[step], millis(), 0, step, note.adsrValues[1], 0, note, false);
      break;
  }
  
  if(step<4) {  
    startingTime = millis();
  }
  else if(step==4) {
    removeNote(note);
  }
  
}

public void endedRamp(Note note, boolean filter) {
  if(!filter) {
    note.ramp.stepId++;
    nextRamp(note);    
  }
  else {
    note.filterRamp.stepId++;
    nextFilterRamp(note);
  }

}

public void startReleaseB(Note note) {
  /*crea la rampa di release per la nota*/  
}

private void nextFilterRamp(Note note) {

  int stepz = note.filterRamp.stepId;
  switch(stepz){
    case 1:
      println("FILTER REACHED DECAY");
      note.filterRamp = new Ramp(EGTimes[stepz], millis(), 0, stepz, note.filterAdsrValues[0], note.filterAdsrValues[1], note, true);
      break;
    case 2: 
      println("FILTER REACHED SUSTAIN");
      break; 
    case 3:
      println("FILTER REACHED Release");
      note.filterRamp = new Ramp(EGTimes[stepz], millis(), 0, stepz, note.filterAdsrValues[1], note.filterAdsrValues[2], note, true);
      break;
  }

  
}


/*End Antonino Code*/

/*Michele Menu's code*/

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
  text(msg, 100, 100);
  
  fill(0,250,0);
  text("Mouse click to reset message, Return to store", 100, height*0.8);
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
