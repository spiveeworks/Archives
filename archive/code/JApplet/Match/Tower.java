
import java.awt.*;
import java.awt.image.*;

/**
 * Write a description of class Tower here.
 * 
 * @author (your name) 
 * @version (a version number or a date)
 */
public class Tower
{
    public BufferedImage image;
    public int x;
    public int t0, y0, y_floor;
    
    public int length, column;
    
    static int g = 1;

    public Tower(TowerData base, Image[] info, GraphicsConfiguration config, int x_space, int y_space, int t0_c)
    {
        image = config.createCompatibleImage(x_space, y_space * base.data.length);
        Graphics g = image.getGraphics();
        for (int y = 0; y < base.data.length; y ++)
            g.drawImage(info[base.data[y].species], 0, y * y_space, null);
        
        x = base.x * x_space;
        t0 = t0_c;
        y0 =      base.start * y_space - base.data.length * y_space;
        y_floor =   base.end * y_space - base.data.length * y_space;
        
        length = base.data.length;
        column = base.x;
    }

    public int getPosWhen(int tnow)
    {
        int t = tnow - t0;
        return (y0 + g * t * t / 2);//projectile motion
    }
    
    public boolean isFinishedWhen (int tnow)
    {
        return getPosWhen(tnow) >= y_floor;
    }
    
    /**
     * An example of a method - replace this comment with your own
     * 
     * @param  y   a sample parameter for a method
     * @return     the sum of x and y 
     */
    public void Paint(Graphics g, int t)
    {
        g.drawImage(image, x, getPosWhen(t), null);
    }
    
    public void Paint(Graphics g)
    {
        g.drawImage(image, x, y_floor, null);
    }
    
    public static Tower[] BatchConstruct(TowerData base[], Image[] info, GraphicsConfiguration config, int x_space, int y_space, int t0_c)
    {
        Tower out[] = new Tower [base.length];
        for (int i = 0; i < base.length; i++)
            out[i] = new Tower (base[i], info, config, x_space, y_space, t0_c);
        return out;
    }
}
