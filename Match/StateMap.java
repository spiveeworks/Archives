
/**
 * Write a description of class StateMap here.
 * 
 * @author (your name) 
 * @version (a version number or a date)
 */
public class StateMap
{
    // instance variables - replace the example below with your own
    public enum State 
    {
        EMPTY, DONE, CHECKED, CHANGED, WAITING, MATCHED;
    }
    State map[][];

    public StateMap(int w, int h)
    {
        map = new State[w][h];
        for (int x = 0; x < w; x++)
            for (int y = 0; y < h; y++)
                map[x][y] = State.EMPTY;
    }
    
    public void TagNew (int x, int y)
    {
        map[x][y] = State.CHANGED;
    }
    public void TagNew (GameRef co)
    {
        map[co.x][co.y] = State.CHANGED;
    }
    
    public void TagFalling (int x, int y0)
    {
        for (int y = y0 - 1; y >= 0; y--)
            map[x][y] = State.WAITING;
    }
    
    public void TagFallen (int x, int size)
    {
        State map_col[] = map[x];
        int top = 0;
        while (top < 5 && map_col[top] == State.WAITING)
            top++;
        for (int y = top - size; y < top; y++)
            map_col[y] = State.CHANGED;
    }
    
    public void TagMatch (int left, int top, int width, int height)
    {
        for (int x = left; x < left + width; x++)
            for (int y = top; y < top + height; y++)
                map[x][y] = State.MATCHED;
    }
    
    public void RemoveTag (int x, int y)
    {
        map[x][y] = State.CHECKED;
    }
    
    public int RecallMatchStart (int x, int offset, int past_end)
    {
        for (int y = offset; y < past_end; y++)
            if (map[x][y] == State.MATCHED) return y;
        return past_end;
    }
    //exactly the same except tests for the first non-marked tile.
    public int RecallMatchEnd (int x, int offset, int past_end)
    {
        for (int y = offset; y < past_end; y++)
            if (map[x][y] != State.MATCHED) return y;
        return past_end;
    }
    
    public boolean HasChanged (int x, int y)
    {
        return map[x][y] == State.CHANGED;
    }

    
    public int DebugSpecies (int x, int y)
    {
        switch (map[x][y])
        {
            case EMPTY: 
                return 0;//Red
            case DONE: 
                return 1;//Green
            case CHECKED: 
                return 2;//Blue
            case CHANGED: 
                return 3;//Yellow
            case WAITING: 
                return 4;//Magenta
            case MATCHED: 
                return 5;//Cyan
        }
        return 6; //???
    }
}
