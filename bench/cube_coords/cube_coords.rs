#![feature(test)]

extern crate test;

fn indices_vec_with_iterator() -> Vec<[i32; 3]> {
    let mut result = Vec::with_capacity(27);
    for (x, y, z) in (0..27).map(|x| (x % 3, (x / 3) % 3, (x / 9) % 3)) {
        result.push([x, y, z]);
    }
    result
}

fn indices_array_with_iterator() -> [[i32; 3]; 27] {
    let mut cs = (0..27).map(|x| [x % 3, (x / 3) % 3, (x / 9) % 3]);
    [
        cs.next().unwrap(),
        cs.next().unwrap(),
        cs.next().unwrap(),
        cs.next().unwrap(),
        cs.next().unwrap(),
        cs.next().unwrap(),
        cs.next().unwrap(),
        cs.next().unwrap(),
        cs.next().unwrap(),
        cs.next().unwrap(),
        cs.next().unwrap(),
        cs.next().unwrap(),
        cs.next().unwrap(),
        cs.next().unwrap(),
        cs.next().unwrap(),
        cs.next().unwrap(),
        cs.next().unwrap(),
        cs.next().unwrap(),
        cs.next().unwrap(),
        cs.next().unwrap(),
        cs.next().unwrap(),
        cs.next().unwrap(),
        cs.next().unwrap(),
        cs.next().unwrap(),
        cs.next().unwrap(),
        cs.next().unwrap(),
        cs.next().unwrap(),
    ]
}

fn indices_array_with_iterator_and_loop() -> [[i32; 3]; 27] {
    let mut array = [[0; 3]; 27];
    let mut cs = (0..27).map(|x| [x % 3, (x / 3) % 3, (x / 9) % 3]);
    for i in 0..27 {
        array[i] = cs.next().unwrap();
    }
    array
}

fn indices_vec_explicit() -> Vec<[i32; 3]> {
    let b_slice: Box<[[i32; 3]]> = Box::new(indices_array_explicit());
    b_slice.into_vec()
}

fn indices_array_explicit() -> [[i32; 3]; 27] {
    [
        [0, 0, 0],
        [1, 0, 0],
        [2, 0, 0],
        [0, 1, 0],
        [1, 1, 0],
        [2, 1, 0],
        [0, 2, 0],
        [1, 2, 0],
        [2, 2, 0],
        [0, 0, 1],
        [1, 0, 1],
        [2, 0, 1],
        [0, 1, 1],
        [1, 1, 1],
        [2, 1, 1],
        [0, 2, 1],
        [1, 2, 1],
        [2, 2, 1],
        [0, 0, 2],
        [1, 0, 2],
        [2, 0, 2],
        [0, 1, 2],
        [1, 1, 2],
        [2, 1, 2],
        [0, 2, 2],
        [1, 2, 2],
        [2, 2, 2],
    ]
}

#[test]
fn vecs_equal() {
    assert_eq!(indices_vec_with_iterator(), indices_vec_explicit());
}

#[test]
fn arrays_equal() {
    assert_eq!(indices_array_with_iterator(), indices_array_explicit());
    assert_eq!(indices_array_with_iterator_and_loop(), indices_array_explicit());
}

use test::Bencher;

#[bench]
fn vec_iterated(b: &mut Bencher) {
    b.iter(|| indices_vec_with_iterator());
}

#[bench]
fn vec_explicit(b: &mut Bencher) {
    b.iter(|| indices_vec_explicit());
}


#[bench]
fn array_iterated(b: &mut Bencher) {
    b.iter(|| indices_array_with_iterator());
}

#[bench]
fn array_iterated_loop(b: &mut Bencher) {
    b.iter(|| indices_array_with_iterator_and_loop());
}

#[bench]
fn array_explicit(b: &mut Bencher) {
    b.iter(|| indices_array_explicit());
}



