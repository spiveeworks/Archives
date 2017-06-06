import java.util.Random;

/**
 * Write a description of class CrushQueue here.
 * 
 * @author (your name) 
 * @version (a version number or a date)
 */
public class CrushQueue
{
    private boolean map[][];
    
    public CrushQueue (int width, int height) 
    {
        map = new boolean[width][height];
    }
    
    public void Tag (int left, int top, int width, int height)
    {
        for (int x = left; x < left + width; x++)
            for (int y = top; y < top + height; y++)
                map[x][y] = true;
    }
    

    public void Crush (GameMap obj, Random rand)
    {
        for (int x = 0; x < map.length; x++)
        {
            Sphere obj_col[] = obj.graph[x];
            boolean map_col[] = map[x];
            int y = 0;
            while (y < map_col.length)
            {
                while (y < map_col.length)
                    if (map_col[y])
                        break;
                    else
                        y++;
                int crush_start = y;
                while (y < map_col.length)
                    if (map_col[y])
                        y++;
                    else
                        break;
                Sphere drop[] = Sphere.Generate(y - crush_start, rand);
                obj.CrushSpheres(drop, x, y);
            }
        }
    }
}
