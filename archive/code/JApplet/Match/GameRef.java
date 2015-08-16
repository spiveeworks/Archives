class GameRef
{
    int x, y;
    GameRef(int x_c, int y_c)
    {
        x = x_c;
        y = y_c;
    }
    GameRef(int x_pos, int y_pos, int x_space, int y_space)
    {
        x = x_pos / x_space;
        y = y_pos / y_space;
    }
}