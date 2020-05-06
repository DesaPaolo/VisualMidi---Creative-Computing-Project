public class GuitarParamButton extends Button{
    private String value;


    public GuitarParamButton(String value, int xPos, int yPos, int wid, int hei, String txt){
        super(xPos, yPos, wid, hei, txt);
        this.value = value;
    }

    public void setValue(String value){
        this.value = value;
    }

    public String getValue(){
        return this.value;
    }
    


}