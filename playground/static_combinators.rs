use std::marker::PhantomData;
use std::fmt;

trait Combinator<X> {
    type Result;
}

type Ap<X, Y> = <X as Combinator<Y>>::Result;
type Ap3<X, Y, Z> = Ap<Ap<X, Y>, Z>;
type Ap4<W, X, Y, Z> = Ap<Ap<Ap<W, X>, Y>, Z>;

impl<X> Combinator<X> for () {  // there's probably a combinator that does this
    type Result = ();
}


struct S;  // Sxyz = xz(yz)
struct Sx<X> { _x: PhantomData<X> }
struct Sxy<X, Y> { _x: PhantomData<X>, _y: PhantomData<Y>}

impl<X> Combinator<X> for S {
    type Result = Sx<X>;
}

impl<X, Y> Combinator<Y> for Sx<X> {
    type Result = Sxy<X, Y>;
}

impl<X, Y, Z> Combinator<Z> for Sxy<X, Y>
    where X: Combinator<Z>,
          Y: Combinator<Z>,
          Ap<X, Z>: Combinator<Ap<Y, Z>>
{
    type Result = Ap<Ap<X, Z>, Ap<Y, Z>>;
}


struct K;  // Kxy = x
struct Kx<X> { _x: PhantomData<X> }

impl<X> Combinator<X> for K {
    type Result = Kx<X>;
}

impl<X, Y> Combinator<Y> for Kx<X> {
    type Result = X;
}


type I = Ap3<S, K, ()>;  // Ix = x

type T = K;         // Txy = x
type F = Ap<S, K>;  // Fxy = y


struct TMsg;
struct FMsg;

impl fmt::Display for TMsg {
    fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
        write!(f, "True")
    }
}

impl fmt::Display for FMsg {
    fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
        write!(f, "False")
    }
}

type Msg<X> = Ap3<X, TMsg, FMsg>;


type R = Ap3<S, Ap<K, Ap<S, I>>, K>;  // Rxy = yx


fn main() {
    println!("Msg<T>: {}, Msg<F>: {};", Msg::<T>{}, Msg::<F>{});
}

