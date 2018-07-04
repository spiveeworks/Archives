import Control.Monad
import Control.Applicative
import Control.Category
import Prelude(foldr, Semigroup((<>)), Monoid(mempty), Either(Left, Right), reverse)

data CPSIO a b = Read (a -> CPSIO a b) | Write b (CPSIO a b) | Terminate

execute :: CPSIO a b -> [a] -> [b]
execute (Read f) (x: xs) = execute (f x) xs
execute (Write y f) xs = y : execute f xs
execute Terminate xs = []

writeList :: CPSIO a b -> [b]  -> CPSIO a b
writeList = foldr Write

applyFun :: (a -> b) -> CPSIO a b -> CPSIO a b
applyFun f cc = Read (\x -> Write (f x) cc)

fromFun :: (a -> b) -> CPSIO a b
fromFun f = go
  where go = applyFun f go

scanCPS f = go
  where go y = Write y (Read (go . f))

instance Functor (CPSIO a) where
    fmap f = go
      where go (Read g) = Read (go . g)
            go (Write x p) = Write (f x) (go p)
            go Terminate = Terminate

premap :: (a -> b) -> CPSIO b c -> CPSIO a c
premap f = go
  where go (Read g) = Read (go . g . f)
        go (Write x p) = Write x (go p)
        go Terminate = Terminate

instance Applicative (CPSIO a) where
    pure x = Write x Terminate

    Read ff <*> thing = Read (\x -> ff x <*> thing)
    Write f p <*> thing = fmap f thing <|> p <*> thing
    Terminate <*> thing = Terminate

instance Monad (CPSIO a) where
    Read f >>= g = Read (\x -> f x >>= g)
    Write x p >>= g = g x <|> (p >>= g)
    Terminate >>= g = Terminate

instance Alternative (CPSIO a) where
    empty = Terminate

    Read f <|> cc = Read (\x -> f x <|> cc)
    Write x p <|> cc = Write x (p <|> cc)
    Terminate <|> cc = cc

instance MonadPlus (CPSIO a)

instance Semigroup (CPSIO a b) where
    (<>) = (<|>)

instance Monoid (CPSIO a b) where
    mempty = empty

stateful :: ((s, a) -> (s, [b])) -> s -> CPSIO a b
stateful f = go
  where go s = Read (\x -> let (s', ys) = f (s, x) in writeList (go s') ys)

instance Category CPSIO where
    id = fromFun id

    Terminate . _ = Terminate
    Write x p . xy = Write x (p . xy)
    yz . Terminate = Terminate
    Read f . Write x p = f x . p
    yz . Read f = Read (\x -> yz . f x)

tieOutputs :: CPSIO (Either a b) (Either a c) -> CPSIO b c
tieOutputs = tieOutputs_ ([], [])
tieOutputs_ (x:xs, ys) (Read f) = tieOutputs_ (xs, ys) (f (Left x))
tieOutputs_ ([], []) (Read f) = Read (\x -> tieOutputs_ ([], []) (f (Right x)))
tieOutputs_ ([], ys) (Read f) = tieOutputs_ (reverse ys, []) (Read f)
tieOutputs_ (xs, ys) (Write (Left y) p) = tieOutputs_ (xs, y:ys) p
tieOutputs_ (xs, ys) (Write (Right y) p) = Write y (tieOutputs_ (xs, ys) p)
tieOutputs_ _ Terminate = Terminate

data AndOr a b = JustLeft a | JustRight b | Both a b
programPair :: CPSIO a b -> CPSIO a c -> CPSIO a (AndOr b c)
programPair (Write x p1) (Write y p2) = Write (Both x y) (programPair p1 p2)
programPair (Write x p1) p2 = Write (JustLeft x) (programPair p1 p2)
programPair p1 (Write y p2) = Write (JustRight y) (programPair p1 p2)
programPair (Read f) (Read g) = Read (\x -> programPair (f x) (g x))
programPair Terminate _ = Terminate
programPair _ Terminate = Terminate