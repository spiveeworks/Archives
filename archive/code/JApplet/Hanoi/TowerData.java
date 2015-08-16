import java.awt.*;

public class TowerData {
    static int DISC_HEIGHT = 10;
    static int DISC_MIN_WIDTH = 30;
    static int DISC_WIDTH_RATE = 10;
    
    static int TOWER_TOP = 200;
    static int TOWER_BOTTOM = 330;
    
    static int[] TOWER_POS = {100, 200, 300};
    static int TOWER_THICKNESS = 8;
    
    
    int total_discs;
    int total_moves;
    
    int movenum;
    int discNumber;
    int destination;

    int disc_positions[]; // ??
    
    void restart (int total_discs_c) {
        total_discs = total_discs_c;
        disc_positions = new int [total_discs];
        for (int i = 0; i < total_discs; i += 1)
            disc_positions[i] = 0;

        total_moves = (int) Math.pow (2, total_discs) - 1;
        movenum = 0;
    }
    
    public TowerData (int total_discs_c) {
        restart (total_discs_c);
    }
    public TowerData () {
        restart (3);
    }

    public int GetDiscWidth (int discNumber) {
        return DISC_MIN_WIDTH + discNumber * DISC_WIDTH_RATE;
    }

    public int GetTowerX (int i) {
        return TOWER_POS[i];
    }
    
    public int GetTowerTopDiscY (int i) {
        int out = TOWER_BOTTOM + DISC_HEIGHT / 2;
        for (int n = 0; n < total_discs; n += 1)
        {
            if (disc_positions[n] == i)
            {
                out -= DISC_HEIGHT;
            }
        }
        return out;
    }
    
    public boolean TopDiscIsRed (int tower) {
        for (int i = 0; i < total_discs; i++)
            if (disc_positions[i] == tower)
                return (i % 2 == 0);
        return ((tower + total_discs) % 2 == 0);
    }
    
    public int TopDiscNumber (int tower) {
        for (int i = 0; i < total_discs; i++)
            if (disc_positions[i] == tower)
                return i;
        return total_discs;
    }
    
    public int GetNextMove (DiscAnimator use) {
        if (movenum != 0)
            disc_positions[discNumber] = destination;
        
        if (movenum == total_moves)
        {
            use.Prepare(this, 0, 2, 2);
            return total_moves;
        }
            
        movenum++;
        
        discNumber = 0;
        for (int x = movenum; x % 2 == 0; x /= 2)
            discNumber++;
        int origin = disc_positions[discNumber];

        int Lhand = 0;
        int Rhand = 2;
        switch(origin)
        {
            case 0:
                Lhand = 1;
                break;
            case 2:
                Rhand = 1;
                break;
        }
        
        boolean this_is_red = (discNumber % 2 == 0);
        if (TopDiscIsRed(Lhand) == this_is_red || TopDiscNumber(Lhand) < discNumber)
            destination = Rhand;
        else
            destination = Lhand;
        
        use.Prepare(this, discNumber, origin, destination);
        return movenum;
    }

    public void PrintSelf (Graphics g) {
        int sem_thi = TOWER_THICKNESS / 2;
        g.setColor (Color.black);
        for (int i = 0; i < 3; i += 1)
        {
            g.fillRect(TOWER_POS[i] - sem_thi, TOWER_TOP, TOWER_THICKNESS, TOWER_BOTTOM - TOWER_TOP);
        }
        
        
        int d_top[] = {0, 0, 0};
        for (int i = total_discs - 1; i >= 0; i -= 1)
        {
            if (discNumber == i) continue;
            if (i % 2 == 0)
            {
                g.setColor (Color.red);
            }
            else
            {
                g.setColor (Color.blue);
            }
            
            int pos = disc_positions[i];
            int disc_x = TOWER_POS[pos];
            int disc_y = TOWER_BOTTOM - d_top[pos];
            d_top[pos] += DISC_HEIGHT;
            
            int sem_wid = GetDiscWidth(i) / 2;
            int sem_hei = DISC_HEIGHT / 2;
            g.fillRect (disc_x - sem_wid, disc_y - DISC_HEIGHT, sem_wid * 2, DISC_HEIGHT);
        }
        
    }
}
