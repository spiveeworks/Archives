
data CPSIO a b = Read (a -> CPSIO a b) | Write b (CPSIO a b) | Terminate

execute :: CPSIO a b -> [a] -> [b]
execute (Read f) (x: xs) = execute (f x) xs
execute (Write y f) xs = y : execute f xs
execute Terminate xs = []

mapOne :: (a -> b) -> CPSIO a b -> CPSIO a b
mapOne f cc = Read (\x -> Write (f x) cc)

mapAll :: (a -> b) -> CPSIO a b
mapAll f = go
  where go = mapOne f go

mapN f cc = go
  where go 0 = cc
        go n = mapOne f (go (n - 1))

scanCPS f = go
  where go y = Write y (Read (go . f))

instance Functor (CPSIO a) where
    fmap f = go
      where go (Read g) = Read (go . g)
            go (Write x p) = Write (f x) (go p)
            go Terminate = Terminate

cpsSeq :: CPSIO a b -> CPSIO a b -> CPSIO a b
Read f `cpsSeq` cc = Read (\x -> f x `cpsSeq` cc)
Write x p `cpsSeq` cc = Write x (p `cpsSeq` cc)
Terminate `cpsSeq` cc = cc

instance Applicative (CPSIO a) where
    pure x = Write x Terminate

    Read ff <*> thing = Read (\x -> ff x <*> thing)
    Write f p <*> thing = fmap f thing `cpsSeq` (p <*> thing)
    Terminate <*> thing = Terminate

cpsJoin :: CPSIO a (CPSIO a b) -> CPSIO a b
cpsJoin (Read f) = Read (cpsJoin . f)
cpsJoin (Write a p) = a `cpsSeq` cpsJoin p
cpsJoin Terminate = Terminate

instance Monad (CPSIO a) where
    return = pure

    mx >>= f = cpsJoin (fmap f mx)

