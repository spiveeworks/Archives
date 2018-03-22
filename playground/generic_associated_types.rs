#![feature(generic_associated_types)]

trait ContainerFamily {
    type Container<T>: IntoIterator<Item=T>;
}

struct VecFamily;

impl ContainerFamily for VecFamily {
    type Container<T> = Vec<T>;
}

use std::fmt::Display;

fn print_items<T: Display, Fam: ContainerFamily>(items: Fam::Container<T>) {
    for x in items {
        println!("{}", x);
    }
}

fn main() {
    let xs = vec![1,2,3,4,5];
    print_items(xs);
}
