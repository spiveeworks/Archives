
/**
 * Write a description of class TowerData here.
 * 
 * @author (your name) 
 * @version (a version number or a date)
 */
public class TowerData
{
    // instance variables - replace the example below with your own
    public int x, start, end;
    public Sphere[] data;

    /**
     * Constructor for objects of class TowerData
     */
    public TowerData(Sphere data_c[], int x_c, int start_c, int end_c)
    {
        data = data_c;
        x = x_c;
        start = start_c;
        end = end_c;
    }

}
