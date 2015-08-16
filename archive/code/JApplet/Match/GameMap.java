
/**
 * Write a description of class GameMap here.
 * 
 * @author (your name) 
 * @version (a version number or a date)
 */
public class GameMap
{
    // instance variables - replace the example below with your own
    public Sphere graph[][];

    /**
     * Constructor for objects of class GameMap
     */
    public GameMap(int width, int height)
    {
        graph = new Sphere[width][height];
    }
    /*
    public PrintableSphere getSphere (int x_ref, int y_ref, int x_offset, int y_offset)
    {
        int x_co = x_offset + x_ref * x_space;
        int y_co = y_offset + y_ref * y_space;
        return new PrintableSphere (graph[x_ref][y_ref], x_co, y_co);
    }
     */   


    public void SwapTiles (GameRef L, GameRef R)
    {
        Sphere pass = graph[L.x][L.y];
        graph[L.x][L.y] = graph[R.x][R.y];
        graph[R.x][R.y] = pass;
    }
    
    public Sphere Replace (Sphere write, GameRef read)
    {
        Sphere out = graph[read.x][read.y];
        graph[read.x][read.y] = write;
        return out;
    }
    
    public boolean AreMatch (int x1, int y1, int x2, int y2)
    {
        return graph[x1][y1].species == graph[x2][y2].species;
    }
    
    public Sphere get (GameRef co)
    {
        return graph[co.x][co.y];
    }
    public void set (GameRef co, Sphere obj)
    {
        graph[co.x][co.y] = obj;
    }
    
    public boolean IsInRange (GameRef tile)
    {
        return (tile.x >= 0 && tile.x < graph[0].length) && (tile.y >= 0 && tile.y < graph.length);
    }
    
    public void CrushSpheres (Sphere drop[], int x_ref, int y_ref) {
        if (drop.length == 0)
            return; //purely to avoid running the following line for no reason.
        System.arraycopy(graph[x_ref], 0, graph[x_ref], drop.length, y_ref - drop.length);
        System.arraycopy(drop, 0, graph[x_ref], 0, drop.length);
    }
    
    public CrushQueue KillRuns () {
        CrushQueue list = new CrushQueue(graph.length, graph[0].length);
        for (int x = 1; x < 4; x++)
            for (int y = 1; y < 4;  y++)
            {
                boolean hor_found = graph[x-1][y].species == graph[x][y].species && graph[x][y].species == graph[x+1][y].species;
                if (hor_found)
                    list.Tag(x - 1, y, 3, 1);
                
                boolean ver_found = graph[x][y-1].species == graph[x][y].species && graph[x][y].species == graph[x][y+1].species;
                if (ver_found)
                    list.Tag(x, y - 1, 1, 3);
            }
        return list;
    }
}
