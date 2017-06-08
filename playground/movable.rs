#![allow(dead_code)]

trait Movable
{
    fn mov (self) -> Self;
}

impl<T> Movable for T
{
    fn mov(self) -> Self { self }
}



fn main() 
{
    let x = Box::new(5);
    //x.mov();
    println!("{}", *x);
}
