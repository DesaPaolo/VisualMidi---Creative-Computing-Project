class KemperStomp{
    private boolean isOn;
    private int address;
    private String type;
    private String name;


    public KemperStomp(boolean isOn, int address, String type) {
        this.isOn = isOn;
        this.address = address;
        this.type = type;
        switch(address){
            case 50: 
                this.name = "A";
                break;
            case 51: 
                this.name = "B";
                break;
            case 52: 
                this.name = "C";
                break;
            case 53: 
                this.name = "D";
                break;
            case 56: 
                this.name = "X";
                break;  
        }
    }

    public KemperStomp(int address) {
        this(false, address, "none");
    }

    public boolean isOn() {
        return isOn;
    }

    public void setOn(boolean isOn) {
        this.isOn = isOn;
    }

    public int getAddress() {
        return address;
    }

    public void setAddress(int address) {
        this.address = address;
    }

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getName() {
        return name;
    }


    
    @Override
    public String toString() {
        return "KemperStomp [address=" + address + ", isOn=" + isOn + ", name=" + name + ", type=" + type + "]";
    }



     
    


}