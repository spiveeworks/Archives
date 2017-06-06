import java.util.Random;


/**
 * Write a description of class Sphere here.
 * 
 * @author (your name) 
 * @version (a version number or a date)
 */
public class Sphere
{
    
    
    int species;

    public Sphere(Random use)
    {
        randomise(use);
    }
    public Sphere(int species_c)
    {
        species = species_c;
    }
    public Sphere(Sphere self_c)
    {
        species = self_c.species;
    }

    
    public void randomise(Random use)
    {
        species = use.nextInt(8);
    }
    
    public static Sphere[] Generate (int num, Random use)
    {
        Sphere out[] = new Sphere[num];
        for (int i = 0; i < num; i++)
            out[i] = new Sphere(use);
        return out;
    }
}
