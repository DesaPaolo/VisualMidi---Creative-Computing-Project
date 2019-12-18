void adsrHandling() {
  int fr = 60; //frame rate: 60 fps
  int nFrmAtck; //number of frames during attack
  int nFrmDcy; //number of frames during decay
  int nFrmRel; //number of frames during release
  float ampAtck;
  float ampDcy;
  float ampSus;
  float ampRel;
  int[] atckAlphaList;
  int[] dcyAlphaList;
  int[] relAlphaList;
  int drawCtr = 0; //counter dei frame in draw
  int susAlpha; //valore alpha mappato in base a ampSus

  frameRate(fr); //inside setup
  susAlpha = (int)map(ampSus, 0, 100, 0, 255);
  
  nFrmAtck = (int)ampAtck * fr;
  nFrmDcy = nFrmAtck + ((int) ampDcy* fr);
  nFrmRel = (int)ampRel * fr;
  
  /*Nei successivi cicli for si calcolano i valori dell'opacità mappati sugli indici dei frame corrispettivi alle fasi dell'envelope, con un metodo "simil Matlab"*/
  for (int i=0; i<nFrmAtck; i++){
    atckAlphaList[i] = (int)map(i, 0, nFrmAtck, 0, 255); //or maplog if we want
  }
  for (int i=0; i<nFrmAtck; i++){
    dcyAlphaList[i] = atckAlphaList[i]; //le celle della fase di attacco saranno uguali a quelle dell'attacco
  }
  for (int i=nFrmAtck; i<nFrmDcy; i++){
    dcyAlphaList[i] = (int)map(i, 0, nFrmAtck, 0, 255); //le celle della fase di decay vengono valutate col metodo esposto sopra
  }
  for (int i=0; i<nFrmRel; i++){
    relAlphaList[i] = (int)map(i, 0, nFrmRel, 0, 255); //celle del release
  }
  
  /*INSIDE DRAW*/
  //ogni draw viene effettuata secondo il frame rate stabilito nel setup
  //void draw (){
  if (drawCtr < nFrmDcy){
    fill (255, 0, 0, dcyAlphaList[drawCtr]);
    drawCtr ++;
  }
  else {
    fill(255, 0, 0, susAlpha);
  }
  
}
