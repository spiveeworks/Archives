
use std::mem;

mod hide_waste
{
    pub struct Waste (u32, u32);
    pub struct Ideal (u32);
    
    pub fn waste(a: u32) -> Waste
      {Waste(a,0)}
    
    pub fn ideal(a: u32) -> Ideal
      {Ideal(a)}
    
    pub fn unwaste(a: Waste) -> u32
      {a.0}
    pub fn unideal(a: Ideal) -> u32
      {a.0}
}


fn main ()
{
    println!("Size of Waste: {}", mem::size_of::<hide_waste::Waste>());
    println!("Size of Ideal: {}", mem::size_of::<hide_waste::Ideal>());
}
