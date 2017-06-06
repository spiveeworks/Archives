import java.awt.*;
import java.applet.*;
import java.awt.event.*;
import javax.swing.Timer;


public class hanoi extends Applet implements ActionListener {
    Dimension dim;
    Image offscreen;
    Graphics bufferg;
    
    TextField disc_input;
    Button begin, iterate, faster;
    Timer timer;
    
    TowerData data;
    DiscAnimator move;
    
     public void init()  
     { 
        offscreen = createImage(400, 400); 
        bufferg = offscreen.getGraphics();
          
        disc_input = new TextField (3);
        begin = new Button ("Build Tower!");
        iterate = new Button ("Next Move.");
        faster = new Button ("Skip");
        
        data = new TowerData ();
        move = new DiscAnimator ();
        generate(3);
        
        timer = new Timer(20, this);
        timer.start();
        
        add(disc_input);
        add(begin);
        add(iterate);
        add(faster);

        begin.addActionListener(this);
        iterate.addActionListener(this);
        faster.addActionListener(this);
        timer.addActionListener(this);
    }
    
    private void generate (int num) {
        data.restart(num);
        data.GetNextMove(move);
    }
    
    public void actionPerformed (ActionEvent e) {
        
        if (e.getSource() == begin)
            generate (Integer.parseInt(disc_input.getText()));
        else if (e.getSource() == iterate && move.phase == 0)
            move.phase = 1;
        else if (e.getSource() == timer && move.phase != 0)
        {
            move.StepForward();
            if (move.phase == 0)
                data.GetNextMove(move);
        }
        else if (e.getSource() == faster)
        {
            move.skip();
            data.GetNextMove(move);
        }

        repaint();
    }
    
    public void paint(Graphics g) {
        bufferg.clearRect(0,0,400,400); 
        bufferg.setColor (Color.black);
        bufferg.drawString ("This is taking " + data.total_moves + " moves.", 20, 120);
        data.PrintSelf(bufferg);
        move.PrintSelf(bufferg);
        g.drawImage(offscreen, 0, 0, this);
    }
    /*
    public void update(Graphics g) {
        paint(g);
    }
    */
    
}
