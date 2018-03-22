use std::str::FromStr;

/* when this is compiled into ASM in release mode, (as of 2017-10-21)
 * one can clearly see a JNE above the INC opcode, (somewhere)
 * indicating that this explicit annotation of wrapping addition is not
 * optimized into x.wrapping_add(1)
 */

fn main() {
    let mut x_str = String::new();
    std::io::stdin().read_line(&mut x_str).expect("Failed to read input");
    let x: i32 = FromStr::from_str(&*x_str).expect("Bad Input");
    let xplus = if x == i32::max_value() { i32::min_value() } else { x + 1 };
    println!("x before: {}, after: {}", x, xplus);
}
