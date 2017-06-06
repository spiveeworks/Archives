extern crate core;

use std::cell::Cell;
use core::ptr;

enum ThunkEnum<F, T>
    where F: FnOnce() -> T
{
    Swap,
    Waiting (F),
    Done (T),
}

impl<F, T> ThunkData<F, T>
    where F: FnOnce() -> T
{
    fn is_done (&self) -> bool
    {
        match *self
        {
            ThunkData::Done(..) => true,
            _ => false,
        }
    }
    
    fn into_inner (self) -> T
    {
        match self
        {
            ThunkData::Done(data) => data,
            ThunkData::Waiting(func) => func(),
        }
    }

    fn into_done (self) -> ThunkEnum
      {ThunkEnum::Done(self.into_inner())}
    
    fn expect_mut (&mut self, msg: &'static str) -> &mut T
    {
        match *self
        {
            ThunkData::Done(ref mut data_ref) => data_ref,
            _ => panic!(msg),
        }
    }

    fn evaluate (&mut self)
    {
        let mut other = mem::replace(self, ThunkEnum::Swap);
        *self = other.into_done();
    }
}

struct Thunk<F, T>
    where F: FnOnce() -> T
{
    cell: Cell<ThunkData<F, T>>
}

impl<F, T> Thunk<F, T>
    where F: FnOnce() -> T
{
    fn new (f: F) -> Thunk<F, T>
      {Thunk {cell: Cell::new(ThunkData::Waiting(f))} }
    
    unsafe fn evaluate(&self)
    {
        let thunk = self.cell.as_ptr();
        let data = ptr::read(thunk).into_inner();
        ptr::write(thunk, ThunkData::Done(data));
    }
    
    unsafe fn get(&self) -> &mut T
    {
        if !deref_cell(&self.cell).is_done()
          {self.evaluate();}
        (*self.cell.as_ptr()).expect_mut("Invalid Thunk Library")
    }
}

fn deref_cell<T> (cell: &Cell<T>) -> &T 
{
    unsafe
      {&*cell.as_ptr()}
}




fn main() {
    let x = Box::new(5 as i32);
    let f = move || (*x) * 5;
    let y = Thunk::new(f);
    unsafe
      {println!("{}", y.get());}
}
