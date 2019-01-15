module CoCo where

-- e.g. Neutral IO = IO (), Neutral Maybe = Maybe ()
type Neutral m = m ()
-- taking in a function is like returning a result but less strong
newtype CoCo b a = CoCo ((a -> b) -> b)

cps :: Monad m => m a -> CoCo (m ()) a
cps mx = CoCo (\ccx -> mx >>= ccx)



joinP :: CoCo m (CoCo m a) -> CoCo m a
joinP (CoCo pp) = CoCo (\ccx -> pp (\(CoCo p) -> p (\x -> ccx x)))

instance Functor (CoCo m) where
    fmap f (CoCo p) = CoCo (\ccy -> p (ccy . f))

instance Applicative (CoCo m) where
    pure x = CoCo (\ccx -> ccx x)
    mf <*> mx = do
        f <- mf
        fmap f mx

instance Monad (CoCo m) where
    mx >>= f = joinP (fmap f mx)


-- we could implement Category on CoCo a b = CoCo ((a -> b) -> b) right?
