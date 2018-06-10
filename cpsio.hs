import Control.Monad
import Control.Applicative

data CPSIO a b = Read (a -> CPSIO a b) | Write b (CPSIO a b) | Terminate

execute :: CPSIO a b -> [a] -> [b]
execute (Read f) (x: xs) = execute (f x) xs
execute (Write y f) xs = y : execute f xs
execute Terminate xs = []

fromList :: [b] -> CPSIO a b
fromList = foldMap return

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
