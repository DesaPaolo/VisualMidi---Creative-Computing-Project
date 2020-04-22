void savePreset(){
  String name;
  Date actualDate = Calendar.getInstance().getTime();
  Preset actualProgram = new GuitarProgram();
  
  loadGuitarProgramsFromFile(); //salvataggio from file to var senza grafica
  addProgram(actualProgram); //Aggiunge preset controllando se overwrite
  try{
    FileWriter fileWriter = new FileWriter(sketchPath("guitar-programs.txt"));
    
    for(int i=0; i<guitarPrograms.size(); i++){
      println("preset size is " + guitarPrograms.size() + " now we are in index " + i);
      storePresetToFile(guitarPrograms.get(i), fileWriter);
      println("saved preset " + presets.get(i).getPresetName());
    }
    
    fileWriter.close(); 
    println("Closed");
  } catch (IOException e) {
    // exception handling
    println("IO Exception");
  }
  loop();
}


void loadGuitarProgramsFromFile(){
  File file = new File(sketchPath("guitar-programs.txt")); 
    try {
      BufferedReader br = new BufferedReader(new FileReader(file)); 
      GuitarProgram newProgram;
      String st;
      
      newPreset = new GuitarProgram(); 
      while ((st = br.readLine()) != null) {
        //System.out.println(st);
        //println(st.equals("sustainAmp 0.0"));
        if (st.equals("start")) {
          //println("Starting");
          newProgram = new GuitarProgram(); 
        }
        else if ((st.equals("end"))){
            //println("i'm done");
            addPreset(newProgram); //Exception
          }
        else if (st.isEmpty()){}
        else if ((st.substring(0,3)).equals("eq ")){newProgram.setEq(st.substring(3));}
        else if ((st.substring(0,4)).equals("amp ")){newProgram.setAmp(st.substring(4));}
        else if ((st.substring(0,5)).equals("name ")){newProgram.setName(st.substring(5));}
        else if ((st.substring(0,7)).equals("reverb ")){newProgram.setReverb(st.substring(7));}
        else if ((st.substring(0,10)).equals("overdrive ")){newProgram.setOverdrive(st.substring(10));}
        else if ((st.substring(0,11)).equals("modulation ")){newProgram.setModulation(st.substring(11));}
        else {System.out.println("Substring is " + st + " Error");}
      }
      br.close();
    } catch (Exception e) {
    // exception handling
      println(e);
  }
}

void storeGuitarProgramToFile (GuitarProgram actualProgram, FileWriter fileWriter){
  try{
    fileWriter.write("start\n");
    fileWriter.write("name " + actualProgram.getName() + "\n");
    fileWriter.write("overdrive " + actualProgram.getOverdrive() +"\n");
    fileWriter.write("amp " + actualProgram.getAmp() + "\n");
    fileWriter.write("eq " + actualProgram.getEq() + "\n");
    fileWriter.write("modulation " + actualProgram.getModulation() + "\n");
    fileWriter.write("reverb " + actualProgram.getReverb() + "\n");
    fileWriter.write("end\n");
  } catch (IOException e) {
      // exception handling
      println("IO Exception");
    }
}

void activatePreset(int index){
  GuitarProgram activeProgram = guitarPrograms.get(index);
  //Qui bisogna assegnare alle variabili globali della grafica, i valori ottenuti dal preset attivo
  println(activePreset.toString());
  
  return;
}

void addPreset (GuitarProgram programToAdd){
  for(int i=0; i<guitarPrograms.size(); i++){
    if (guitarPrograms.get(i).getName().equals(programToAdd.getName())){
      guitarPrograms.remove(i);
      guitarPrograms.add(i, programToAdd);
      println("overwriting program called " + guitarPrograms.get(i).getName());
      return;
    }  
  }
  guitarPrograms.add(programToAdd);
  println("adding new program called " + guitarPrograms.get(guitarPrograms.size()-1).getName());
  return;
}