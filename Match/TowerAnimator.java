import java.util.*;
import java.awt.Image;
import java.awt.GraphicsConfiguration;
/**
 * Write a description of class TowerAnimator here.
 * 
 * @author (your name) 
 * @version (a version number or a date)
 */
public class TowerAnimator
{
    // instance variables - replace the example below with your own
    public java.util.List<Tower> objects;
    public int time;

    /**
     * Constructor for objects of class TowerAnimator
     */
    public TowerAnimator()
    {
        objects = new LinkedList<Tower>();
        time = 0;
    }

    public void batchAdd (Tower adds[])
    {
        for (int i = 0; i < adds.length; i++)
            objects.add(adds[i]);
    }
    
    public Tower[] StepAndCull (int s)
    {
        time += s;
        
        Tower out[] = new Tower[objects.size()];
        int out_index = 0;
        
        Iterator<Tower> it = objects.iterator();
        while (it.hasNext())
        {
            Tower tower = it.next();
            if (tower.isFinishedWhen(time))
            {
                out[out_index++] = tower;
                it.remove();
            }
        }
        return Arrays.copyOf(out, out_index);
    }
    
    public Tower[] CullAll ()
    {
        Tower out[] = new Tower[objects.size()];
        int out_index = 0;
        
        Iterator<Tower> it = objects.iterator();
        while (it.hasNext())
        {
            Tower tower = it.next();
            it.remove();
            out[out_index++] = tower;
        }
        return out;
    }
    
}
