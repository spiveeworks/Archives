fn pow(x: u64, mut n: u32) -> u64
{
    let mut result = 1;
    while n > 0
    {
        result *= result;
        if n % 2 == 1
        {
            result *= x;
        }
        n >>= 1;
    }
    result
}

fn main()
{
    println!("{}", pow(7,7));
}
