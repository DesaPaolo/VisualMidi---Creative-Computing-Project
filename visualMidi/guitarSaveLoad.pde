void savePrograms(){
  String name;
  Date actualDate = Calendar.getInstance().getTime();
  
  try{
    FileWriter fileWriter = new FileWriter(sketchPath("guitar-programs.txt"));
    
    for(int i=0; i<guitarPrograms.size(); i++){
      println("preset size is " + guitarPrograms.size() + " now we are in index " + i);
      storeGuitarProgramToFile(guitarPrograms.get(i), fileWriter);
      println("saved preset " + guitarPrograms.get(i).getName());
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
      
      newProgram = new GuitarProgram(); 
      while ((st = br.readLine()) != null) {
        //System.out.println(st);
        //println(st.equals("sustainAmp 0.0"));
        if (st.equals("start")) {
          //println("Starting");
          newProgram = new GuitarProgram(); 
        }
        else if ((st.equals("end"))){
            //println("i'm done");
            addProgram(newProgram); //Exception
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
    if(!actualProgram.getName().equals("PC NULL")){
    fileWriter.write("start\n");
    fileWriter.write("name " + actualProgram.getName() + "\n");
    fileWriter.write("overdrive " + actualProgram.getOverdrive() +"\n");
    fileWriter.write("amp " + actualProgram.getAmp() + "\n");
    fileWriter.write("eq " + actualProgram.getEq() + "\n");
    fileWriter.write("modulation " + actualProgram.getModulation() + "\n");
    fileWriter.write("reverb " + actualProgram.getReverb() + "\n");
    println("############ACTUAL GUITAR PROGRAM WRITTEN ON FILE: "+actualProgram);
    fileWriter.write("end\n");
    }
  } catch (IOException e) {
      // exception handling
      println("IO Exception");
    }
}

void activateProgram(int index){
  GuitarProgram activeProgram = guitarPrograms.get(index);
  currentProgramIndex = index;
  //Qui bisogna assegnare alle variabili globali della grafica, i valori ottenuti dal preset attivo
  gtrAmp = guitarPrograms.get(index).getAmp();
  gtrOverdrive = guitarPrograms.get(index).getOverdrive();
  gtrEq = guitarPrograms.get(index).getEq();
  gtrReverb = guitarPrograms.get(index).getReverb();
  gtrModulation = guitarPrograms.get(index).getModulation();
  println(activeProgram.toString());
  
  return;
}

void addProgram (GuitarProgram programToAdd){
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