
import java.awt.*;
import java.awt.image.*;
import java.awt.event.*;
import javax.swing.*;
import java.util.*;

/**
 * Class Interface - write a description of the class here
 * 
 * @author (your name) 
 * @version (a version number)
 */
public class Body extends JApplet implements MouseListener, ActionListener
{
    private GameInstance game;
    private GameBoard board, debug_panel;
    private TowerAnimator towers;
    
    private GameRef Ltile;
    
    public Button doCheck, drop, cull_all;
    public javax.swing.Timer timer;
    
    public int debug = 555;
    

    /**
     * Called by the browser or applet viewer to inform this JApplet that it
     * has been loaded into the system. It is always called before the first 
     * time that the start method is called.
     */
    public void init()
    {
        // this is a workaround for a security conflict with some browsers
        // including some versions of Netscape & Internet Explorer which do 
        // not allow access to the AWT system event queue which JApplets do 
        // on startup to check access. May not be necessary with your browser. 
        JRootPane rootPane = this.getRootPane();    
        rootPane.putClientProperty("defeatSystemEventQueueCheck", Boolean.TRUE);

        game = new GameInstance();
        board = new GameBoard(getGraphicsConfiguration(), 5, 5);
        debug_panel = new GameBoard(getGraphicsConfiguration(), 5, 5);
        towers = new TowerAnimator();
        
        setLayout (new FlowLayout());
        
        doCheck = new Button ("check");
        add(doCheck);
        doCheck.addActionListener(this);
        drop = new Button ("drop");
        add(drop);
        drop.addActionListener(this);
        cull_all = new Button ("cull dem");
        add(cull_all);
        cull_all.addActionListener(this);
        
        timer = new javax.swing.Timer(50, this);
        timer.start();
        timer.addActionListener(this);
        
        addMouseListener(this);
        
        
        
    }

    public void updateGame() {
        game.Detect();
        TowerData data[] = game.Crush();
        Tower new_towers[] = board.DoBatchConstruct(data, getGraphicsConfiguration(), towers.time);
        towers.batchAdd(new_towers);
    }
    
    public void actionPerformed (ActionEvent e) {
        if (e.getSource() == doCheck)
        {
            game.Detect();
            repaint();
            
        }
        else if (e.getSource() == drop)
        {
            TowerData data[] = game.Crush();
            Tower new_towers[] = board.DoBatchConstruct(data, getGraphicsConfiguration(), towers.time);
            towers.batchAdd(new_towers);
            repaint();
        }
        else if (e.getSource() == cull_all)
        {
            // These operations simply deal with each of the fields that contain the game, one at a time.
            Tower closed[]; //Will contain the Tower objects that are ready to be printed in their final location
            closed = towers.StepAndCull(1); //push forward one step, and then check which towers have landed
            board.PaintLandedTower(closed); //use array overload
            for (int i = 0; i < closed.length; i++)
                game.FinishDrop(closed[i].column, closed[i].length);//marks changes made by all towers
            repaint();
        }
        
        else if (e.getSource() == timer)
        {
            // These operations simply deal with each of the fields that contain the game, one at a time.
            Tower closed[]; //Will contain the Tower objects that are ready to be printed in their final location
            closed = towers.StepAndCull(1); //push forward one step, and then check which towers have landed
            board.PaintLandedTower(closed); //use array overload
            for (int i = 0; i < closed.length; i++)
                game.FinishDrop(closed[i].column, closed[i].length);//marks changes made by all towers
            repaint();
            
        }
        
    }
    
    public void start() {}
    public void stop() {}

    public void paint(Graphics g)
    {
        Image buffer = createImage(500, 500);
        Graphics buffer_g = buffer.getGraphics();
        
        buffer_g.setColor(Color.white);
        g.clearRect(0, 0, 500, 100);
        
        for (int i = 0; i < 5; i++)
            for (int j = 0; j < 5; j++)
        {
            board.PaintTile(game.map.graph[i][j].species, i, j);
            debug_panel.PaintTile(game.state.DebugSpecies(i, j), i, j);
        }
        
        buffer_g.drawImage(board.board, 0, 0, this);
        
        Iterator<Tower> it = towers.objects.iterator();
        while (it.hasNext())
        {
            Tower tower = it.next();
            tower.Paint(buffer_g, towers.time);
        }
        
        //g.drawImage(board.board, 10, 100, this);
        g.drawImage(buffer, 10, 100, this);
        g.drawImage(debug_panel.board, 310, 100, this);
        
        g.setColor(Color.black);
        g.drawString("Sample Applet", 20, 20);
        g.setColor(Color.blue);
        g.drawString("created by BlueJ", 20, 40);
        g.setColor(Color.red);
        g.drawString("Towers: " + towers.objects.size(), 20, 60);
        g.drawString("" + debug, 20, 80);
    }
    
    public void mousePressed(MouseEvent e)
    {
        Ltile = board.PosToRef( e.getX(), e.getY(), 10, 100);
    }
    
    public void mouseReleased(MouseEvent e)
    {

        GameRef Rtile = board.PosToRef( e.getX(), e.getY(), 10, 100);
        
        if (game.map.IsInRange(Ltile) && game.map.IsInRange(Rtile))
        {
            game.Swap(Ltile, Rtile);
        }
        updateGame();
        repaint();
    }
    
    public void mouseExited(MouseEvent e) {}
    public void mouseEntered(MouseEvent e) {}
    public void mouseClicked(MouseEvent e) 
    {
        GameRef Rtile = board.PosToRef( e.getX(), e.getY(), 10, 100);
        game.map.graph[Rtile.x][Rtile.y] = new Sphere(0);
        repaint();
    }

    public void destroy() {}

    public void update(Graphics g){paint(g);}

    /**
     * Returns information about this applet. 
     * An applet should override this method to return a String containing 
     * information about the author, version, and copyright of the JApplet.
     *
     * @return a String representation of information about this JApplet
     */
    public String getAppletInfo()
    {
        // provide information about the applet
        return "Title:   \nAuthor:   \nA simple applet example description. ";
    }
}
