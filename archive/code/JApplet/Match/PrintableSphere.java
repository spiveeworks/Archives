import java.awt.*;
import java.awt.image.*;

/**
 * Write a description of class PrintableSphere here.
 * 
 * @author (your name) 
 * @version (a version number or a date)
 */
public class PrintableSphere extends Sphere
{
    int x, y;

    public PrintableSphere (Sphere base, int x_c, int y_c)
    {
        super(base);
        MoveTo(x_c, y_c);
    }
    
    public void MoveTo (int x_c, int y_c)
    {
        x = x_c;
        y = y_c;
    }

    public void paint(Graphics g, TileInfo info, ImageObserver ob)
    {
        g.drawImage(info.image[species], x, y, ob);
    }
}
