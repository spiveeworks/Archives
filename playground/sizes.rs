
use std::mem;

struct UDrop (u64);

impl Drop for UDrop
{
    fn drop(&mut self)
    {
        println!("Dropped! Value = {}", self.0);
    }
}

fn main() 
{
    println!("Size of Ref: {}", mem::size_of::<&i32>());
    println!("Size of Nullable Ref: {}", mem::size_of::<Option<&i32>>());
    println!("Size of Box: {}", mem::size_of::<Box<i32>>());
    println!("Size of Nullable Box: {}", mem::size_of::<Option<Box<i32>>>());
    println!("Size of Vec: {}", mem::size_of::<Vec<i32>>());
    println!("Size of Nullable Vec: {}", mem::size_of::<Option<Vec<i32>>>());
    println!("Size of Boxed Slice: {}", mem::size_of::<Box<[i32]>>());
    println!("Size of Nullable Boxed Slice: {}", mem::size_of::<Option<Box<[i32]>>>());
    let my_box = Box::new(UDrop(0));
    let read_box: u64 = unsafe {mem::transmute_copy(&my_box)};
    println!("Binary representation of box: {:0x}", read_box);
}

