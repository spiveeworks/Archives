import java.util.*;
import java.awt.*;
/**
 * Write a description of class GameInstance here.
 * 
 * @author (your name) 
 * @version (a version number or a date)
 */
public class GameInstance
{
    public GameMap map;
    public StateMap state;
    public Random rand;
    
    /**
     * Constructor for objects of class GameInstance
     */
    public GameInstance()
    {
        map = new GameMap(5, 5);
        state = new StateMap(5, 5);
        rand = new Random();
        
        for (int i = 0; i < 5; i++)
            for (int j = 0; j < 5; j++)
            {
                map.graph[i][j] = new Sphere(rand);
                state.TagNew(i, j);
            }
        
    }
    
    public void Swap (GameRef cycle[]) 
    {
        Sphere swap = null;
        for (int i = 0; i < cycle.length; i++)
        {
            swap = map.Replace(swap, cycle[i]);
            state.TagNew(cycle[i]);
        }
        map.Replace(swap, cycle[0]);
    }
    public void Swap (GameRef L ,GameRef R) 
    {
        Sphere left = map.get(L), 
              right = map.get(R);
        map.set(L, right);
        map.set(R, left);
        
        state.TagNew(L);
        state.TagNew(R);
    }

    
    public TowerData PullTower (Sphere drop[], int x, int y_depth) {
        map.CrushSpheres (drop, x, y_depth);
        Sphere out[] = new Sphere[y_depth];
        System.arraycopy(map.graph[x], 0, out, 0, y_depth);
        
        state.TagFalling(x, y_depth);
        
        return new TowerData(out, x, y_depth - drop.length, y_depth);
    }
    public TowerData PullTower (int num, int x, int y_depth) {
        return PullTower(Sphere.Generate(num, rand), x, y_depth);
    }
    
    public TowerData[] Crush ()
    {
        TowerData towers[] = new TowerData[12];
        int add = 0;
        for (int x = 0; x < 5; x++)
        {
            //uses special tag-finding methods to parse using another for loop :D
            int y_start = state.RecallMatchStart(x, 0, 5),
                y_end; 
            while (y_start < 5)
            {
                y_end   = state.RecallMatchEnd  (x, y_start, 5);
                
                towers[add++] = PullTower(y_end - y_start, x, y_end);
                y_start = state.RecallMatchStart(x, y_end, 5);
            }
        }
        return Arrays.copyOf(towers, add);
    }
    
    public void FinishDrop (int column, int size)
    {
        state.TagFallen(column, size);
    }
    
    public void Detect ()
    {
        for (int x = 0; x < 5; x++)
            for (int y = 0; y < 5;  y++)
            {
                if (state.HasChanged(x, y))
                    DetectAt(x, y);
            }
    }
    
    private void DetectAt (int x, int y)
    {
        state.RemoveTag(x,y);
        DetectHorizontal(x, y);
        DetectVertical(x, y);
    }
    
    private boolean DetectHorizontal (int x, int y)
    {
        int size = 0;
        int corner = x;
        for (int x2 = x; x2 >= 0 && map.AreMatch (x,y, x2,y); corner = x2--)
            size++;
        for (int x2 = x + 1; x2 < 5 && map.AreMatch (x,y, x2,y); x2++)
            size++;
        if (size >= 3)
        {
            state.TagMatch(corner, y, size, 1);
            return true;
        }
        else
            return false;
    }
    private boolean DetectVertical (int x, int y)
    {
        int size = 0;
        int corner = y;
        for (int y2 = y; y2 >= 0 && map.AreMatch (x,y, x,y2); corner = y2--)
            size++;
        for (int y2 = y + 1; y2 < 5 && map.AreMatch (x,y, x,y2); y2++)
            size++;
        if (size >= 3)
        {
            state.TagMatch(x, corner, 1, size);
            return true;
        }
        else
            return false;
    }
}
