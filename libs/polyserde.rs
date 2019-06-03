#[macro_use]
extern crate serde_derive;

use serde::*;

use bincode::Config;

use std::any::TypeId;
trait TraitImpl where Self: Serialize + for<'de> Deserialize<'de> {
    fn display(self: &Self) -> &'static str;
}

trait Trait {
    fn display(self: &Self) -> &'static str;
    fn serialize_bincode(self: &Self, se: Config) -> bincode::Result<Vec<u8>>;
}

impl<T> Trait for T where T: 'static + TraitImpl {
    fn display(self: &Self) -> &'static str {
        TraitImpl::display(self)
    }
    fn serialize_bincode(self: &Self, se: Config) -> bincode::Result<Vec<u8>> {
        // this is always safe, but may lead to errors if we
        // serialize and deserialize on different builds
        let ty: u64 = unsafe { std::mem::transmute(TypeId::of::<Self>()) };
        se.serialize(&(ty, self))
    }
}

#[derive(Serialize, Deserialize)]
struct A;
#[derive(Serialize, Deserialize)]
struct B;

impl TraitImpl for A {
    fn display(self: &Self) -> &'static str {
        return "A";
    }
}

impl TraitImpl for B {
    fn display(self: &Self) -> &'static str {
        return "B";
    }
}

macro_rules! deserialize_helper {
    { $id: ident, $reader: ident => $($T: ty)|* } => { $(
        if $id == TypeId::of::<$T>() {
            let val: $T = bincode::deserialize_from($reader)?;
            return Ok(Box::new(val))
        }
    )*}
}

fn deserialize_box_from<'a, T>(reader: &'a T) -> bincode::Result<Box<Trait>>
    where &'a T: std::io::Read,
          T: ?Sized
{
    let id_raw: u64 = bincode::deserialize_from(reader)?;
    // this is always safe, but may lead to errors if we
    // serialize and deserialize on different builds
    let id: TypeId = unsafe { std::mem::transmute(id_raw) };
    deserialize_helper!{ id, reader => A | B }
    panic!("Tried to deserialize with unknown TypeId: {}", id_raw);
}

#[cfg(test)]
mod test {
    use super::*;

    fn test_polyserde(val: Box<Trait>) {
        let bytes = val.serialize_bincode(bincode::config()).unwrap();
        let new_val = deserialize_box_from(&*bytes).unwrap();
        assert_eq!(val.display(), new_val.display());
    }

    #[test]
    fn main() {
        test_polyserde(Box::new(A));
        test_polyserde(Box::new(B));
    }
}

