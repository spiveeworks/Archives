
import java.awt.*;
import java.awt.image.*;


/**
 * Write a description of class TileInfo here.
 * 
 * @author (your name) 
 * @version (a version number or a date)
 */
public class TileInfo
{
    public BufferedImage image[];
    public Color base_color[];

    /**
     * Constructor for objects of class TileInfo
     */
    public TileInfo(GraphicsConfiguration config,int width, int height)
    {
        
        base_color = new Color[8];
        base_color[0] = new Color (255,   0,   0);
        base_color[1] = new Color (  0, 255,   0);
        base_color[2] = new Color (  0,   0, 255);
        base_color[3] = new Color (255, 255,   0);
        base_color[4] = new Color (255,   0, 255);
        base_color[5] = new Color (  0, 255, 255);
        base_color[6] = new Color (255, 128,   0);
        base_color[7] = new Color (128,   0, 255);
        
        image = new BufferedImage[8];
        Graphics g;
        for (int i = 0; i < 8; i++)
        {
            image[i] = config.createCompatibleImage (width, height);
            g = image[i].getGraphics();
            g.setColor(base_color[i]);
            g.fillRect(0, 0, width, height);
        }
    }

}
