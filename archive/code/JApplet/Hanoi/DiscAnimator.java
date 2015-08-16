import java.awt.*;

//import javax.xml.crypto.Data;

public class DiscAnimator {
    static int MOVE_SPEED = 1;
    static int AIR_SPACE = 10;
    
    int discNumber;
    
    int discWidth;
    int discHeight;
    
    int disc_x;
    int disc_y;
    
    int end_x;
    int end_y;
    
    int air_y;
    
    int phase = 0; // ??
    int direction;
    
    
    public void Prepare (TowerData dat, int discNumber_c, int origin, int destination) { // ??
        discNumber = discNumber_c;
        
        discWidth = dat.GetDiscWidth (discNumber); // !!
        discHeight = dat.DISC_HEIGHT;
        
        disc_x = dat.GetTowerX (origin); // !!
        disc_y = dat.GetTowerTopDiscY (origin); // !!
        
        end_x = dat.GetTowerX (destination);
        end_y = dat.GetTowerTopDiscY (destination);
        if (origin != destination) 
            end_y -= dat.DISC_HEIGHT;
        
        air_y = dat.TOWER_TOP - AIR_SPACE;
        
        phase = 0;
        direction = end_x - disc_x;
        direction /= Math.abs(direction); // ??
    }
    
    public void PrintSelf (Graphics p) {
        if (discNumber % 2 == 0) // ??
        {
            p.setColor (Color.red);
        }
        else
        {
            p.setColor (Color.blue);
        }
        
        
        p.fillRect (disc_x - discWidth / 2, disc_y - discHeight / 2, discWidth, discHeight);
    }
    
    public void StepForward () {
        switch (phase) 
        {
        case 1://move up
            disc_y -= MOVE_SPEED;
            if (disc_y <= air_y)
            {
                phase = 2;
            }
            break;
            
        case 2://move across to correct tower
            disc_x += MOVE_SPEED * direction;
            if ((end_x - disc_x) * direction <= 0)
            {
                disc_x = end_x; //just in case
                phase = 3;
            }
            break;
            
        case 3://move back down
            disc_y += MOVE_SPEED;
            if (disc_y >= end_y)
            {
                disc_y = end_y;
                phase = 0; //finished
            }
            break;
            
        }
    }
    
    public void skip () {
        disc_x = end_x;
        disc_y = end_y;
        phase = 0;
    }

}




