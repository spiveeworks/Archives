#![allow(dead_code)]

macro_rules! repeat_n
{
    ($x: expr; $n: expr) => (repeat_n!($x; $n; []));
    ($x: expr; 0; [$($xs: expr),*]) => ([$($xs),*]);
    ($x: expr; $n: expr; [$($xs: expr),*]) => 
        (repeat_n!( $x; $n; [$x, $($xs: tt),*]));
}

macro_rules! arr_init
{
    [$($xs: expr),*] => [[$($xs),*]]
}

macro_rules! expr_arr
{
    [$x: expr; $n: expr] => [arr_init![repeat_n!($x; $n)]]
}


fn main() 
{
    println!("{:?}", repeat_n!(5; 1-1; [5]));
}
