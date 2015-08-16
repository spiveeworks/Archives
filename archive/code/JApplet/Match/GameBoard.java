
import java.awt.*;
import java.awt.image.*;


/**
 * Write a description of class GameInterface here.
 * 
 * @author (your name) 
 * @version (a version number or a date)
 */
public class GameBoard
{
    // instance variables - replace the example below with your own

    public TileInfo tile_info;
    public BufferedImage board;
    private Graphics board_g;
    
    public int x_space = 51, y_space = 51;

    /**
     * Constructor for objects of class GameInterface
     */
    public GameBoard(GraphicsConfiguration config, int map_wid, int map_hei)
    {
        tile_info = new TileInfo(config, 50, 50);
        board = config.createCompatibleImage(map_wid * x_space, map_hei * y_space);
        board_g = board.getGraphics();
    }

        
    public GameRef PosToRef (int x_pos, int y_pos)
    {
        return new GameRef(x_pos, y_pos, x_space, y_space);
    }
    public GameRef PosToRef (int x_pos, int y_pos, int x_offset, int y_offset)
    {
        return PosToRef (x_pos - x_offset, y_pos - y_offset);
    }
    
    public void PaintTile (int species, int x_ref, int y_ref)
    {
        board_g.drawImage(tile_info.image[species], x_ref * x_space, y_ref * y_space, null);
    }
    
    public void PaintLandedTower (Tower to_paint)
    {
        to_paint.Paint(board_g);
    }
    public void PaintLandedTower (Tower to_paint[])
    {
        for (int i = 0; i < to_paint.length; i++)
            to_paint[i].Paint(board_g);
    }
    
    
    public Tower[] DoBatchConstruct(TowerData base[], GraphicsConfiguration config, int time)
    {
        return Tower.BatchConstruct(base, tile_info.image, config, x_space, y_space, time);
    }
}
