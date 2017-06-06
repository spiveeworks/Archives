use std::cell::Cell;

struct CellMarker<'a, T: 'a + Clone>
{
    cell: &'a Cell<T>,
    val: T,
}

impl<'a, T: 'a + Clone> Drop for CellMarker<'a, T>
{
    fn drop(&mut self)
    {
        self.cell.set(self.val.clone());
    }
}

fn main() {
    let mut thing = Cell::new(0);
    println!("Val before: {}", thing.get_mut());
    5;
    {CellMarker{cell: &thing, val: 5};}
    println!("Val before: {}", thing.into_inner());
}
