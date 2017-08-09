fn main()
{
    pretty_a(&mut String::new(), 4, 0);
}

fn pretty_a(indent: &mut String, mut m: u64, mut n: u64) -> u64
{
    while m > 0
    {
        println!("{}m = {}, n = {}", indent, m, n);
        if n == 0 
        {
            n = 1;
        }
        else 
        {
            indent.push_str("    ");
            n = pretty_a(indent, m, n-1);
            let new_len = indent.len() - 4;
            indent.truncate(new_len);
        }
        m -= 1;
    }
    println!("{}Result: {}", indent, n + 1);
    n + 1
}
