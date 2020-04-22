public class GuitarProgram {
    private String overdrive;
    private String amp;
    private String eq;
    private String modulation;
    private String reverb;

    public GuitarProgram(String overdrive, String amp, String eq, String modulation, String reverb) {
        if(overdrive.equals("none") || overdrive.equals("boost") || 
            overdrive.equals("overdrive") || overdrive.equals("distortion") || overdrive.equals("fuzz")){
                this.overdrive = overdrive;
        } else {this.overdrive = "none";}
        
        if(amp.equals("clean") || amp.equals("crunch") || amp.equals("hiGain")){
            this.amp = amp;
        } else {this.amp = "clean";}

        if(eq.equals("warm") || eq.equals("normal") || eq.equals("bright")){
            this.eq = eq;
        } else {this.eq = "normal";}

        if(modulation.equals("none") || modulation.equals("chorus") || 
            modulation.equals("phaser") || modulation.equals("flanger")){
                this.modulation = modulation;
        } else {this.modulation = "none";}

        if(reverb.equals("small") || reverb.equals("medium") || reverb.equals("large")){
            this.reverb = reverb;
        }  else {this.reverb = "medium";}
    }

    public GuitarProgram() {
        this.overdrive = "none";
        this.amp = "clean";
        this.eq = "normal";
        this.modulation = "none";
        this.reverb = "medium";
    }

    public String getOverdrive() {
        return overdrive;
    }

    public void setOverdrive(String overdrive) {
        if(overdrive.equals("none") || overdrive.equals("boost") || 
            overdrive.equals("overdrive") || overdrive.equals("distortion") || overdrive.equals("fuzz")){
                this.overdrive = overdrive;
        } else {this.overdrive = "none";}
    }

    public String getAmp() {
        return amp;
    }

    public void setAmp(String amp) {
        if(amp.equals("clean") || amp.equals("crunch") || amp.equals("hiGain")){
            this.amp = amp;
        } else {this.amp = "clean";}
    }

    public String getEq() {
        return eq;
    }

    public void setEq(String eq) {
        if(eq.equals("warm") || eq.equals("normal") || eq.equals("bright")){
            this.eq = eq;
        } else {this.eq = "normal";}
    }

    public String getModulation() {
        return modulation;
    }

    public void setModulation(String modulation) {
        if(modulation.equals("none") || modulation.equals("chorus") || 
            modulation.equals("phaser") || modulation.equals("flanger")){
                this.modulation = modulation;
        } else {this.modulation = "none";}
    }

    public String getReverb() {
        return reverb;
    }

    public void setReverb(String reverb) {
        if(reverb.equals("small") || reverb.equals("medium") || reverb.equals("large")){
            this.reverb = reverb;
        }  else {this.reverb = "medium";}
    }

    @Override
    public String toString() {
        return "GuitarProgram [amp=" + amp + ", eq=" + eq + ", modulation=" + modulation + ", overdrive=" + overdrive
                + ", reverb=" + reverb + "]";
    }
    }

