
-------------------
-- New List Impl --
-------------------

data List a = Nil | Cons a (List a)

showNoParen :: Show a => List a -> String
showNoParen Nil = ""
showNoParen (Cons x Nil) = show x
showNoParen (Cons x xs) = show x ++ " " ++ showNoParen xs

instance Show a => Show (List a) where
    show xs = "(" ++ showNoParen xs ++ ")"

myFoldr :: (a -> r -> r) -> r -> List a -> r
myFoldr f acc Nil = acc
myFoldr f acc (Cons x xs) = f x (myFoldr f acc xs)

-------------------
-- Monad Helpers --
-------------------

lift :: Monad m => (a -> b) -> m a -> m b
lift f mx =
  do
    x <- mx
    return (f x)

lift2 :: Monad m => (a -> b -> c) -> m a -> m b -> m c
lift2 f mx my =
  do
    x <- mx
    lift (f x) my

class Skip f where
    skip :: f a

mFilter :: (Monad m, Skip m) => Bool -> m ()
mFilter False = skip
mFilter True = return ()

-----------------
-- List Method --
-----------------

append :: List a -> List a -> List a
append Nil ys = ys
append (Cons x xs) ys = Cons x (append xs ys)

flatMap :: (a -> List b) -> List a -> List b
flatMap f Nil = Nil
flatMap f (Cons x xs) = append (f x) (flatMap f xs)

instance Monad List where
    mx >>= f = flatMap f mx

instance Functor List where
    fmap = lift

instance Applicative List where
    pure x = Cons x Nil
    liftA2 = lift2

countUp :: Integer -> List Integer
countUp n = Cons n (countUp (n + 1))

positives :: List Integer
positives = countUp 1

myTake :: Integer -> List Integer -> List Integer
myTake n Nil = Nil
myTake n (Cons x xs) = if n < 1 then Nil else Cons x (myTake (n - 1) xs)

instance Skip List where
    skip = Nil

sillyList :: List Integer
sillyList =
  do
    x <- positives
    y <- myTake x positives
    mFilter ((x + y) `rem` 2 == 0)
    return (x * y)

-----------------------
-- Transducer Method --
-----------------------

type Transducer r a b = (b -> r -> r) -> a -> r -> r

-- Simple demonstration of what transducers even are
applyTransducer :: Transducer (List b) a b -> List a -> List b
applyTransducer tr = myFoldr (tr Cons) Nil

applyTransducer1 :: Transducer (List b) a b -> a -> List b
applyTransducer1 tr x = tr Cons x Nil

trFlatMap :: (a -> List b) -> Transducer r a b
trFlatMap f br x acc = myFoldr br acc (f x)

trProdFlatMap :: (a -> List b) -> Transducer r a (a, b)
trProdFlatMap f abr x acc = myFoldr (\y -> abr (x, y)) acc (f x)

trFilter :: (a -> Bool) -> Transducer r a a
trFilter pred ar x acc = if pred x then ar x acc else acc

trMap :: (a -> b) -> Transducer r a b
trMap f br x acc = br (f x) acc

sillyTr1 :: Transducer r Integer (Integer, Integer)
sillyTr1 = trProdFlatMap (\x -> myTake x positives)

sillyTr2 :: Transducer r (Integer, Integer) (Integer, Integer)
sillyTr2 = trFilter (\(x, y) -> (x + y) `rem` 2 == 0)

sillyTr3 :: Transducer r (Integer, Integer) Integer
sillyTr3 = trMap (\(x, y) -> x * y)

sillyTr :: Transducer r Integer Integer
sillyTr = sillyTr1 . sillyTr2 . sillyTr3

sillyList2 :: List Integer
sillyList2 = applyTransducer sillyTr positives

------------------------------
-- Transduced Stream Method --
------------------------------

type Stream s a = s -> (a, s)

streamTake :: Integer -> Stream s a -> s -> List a
streamTake n step state | n < 1 = Nil
streamTake n step state         = let (x, state') = step state in Cons x (streamTake (n - 1) step state')

streamMap :: (a -> b) -> Stream s a -> Stream s b
streamMap f step state = let (x, state') = step state in (f x, state')

countStream :: Stream Integer Integer
countStream n = (n, n + 1)

fibbStream :: Stream (Integer, Integer) Integer
fibbStream (x, y) = (x, (y, x + y))

transduceStream :: Transducer (List b) a b -> Stream s a -> Stream s (List b)
transduceStream tr = streamMap (applyTransducer1 tr)

flattenStream :: Stream s (List a) -> Stream (List a, s) a
flattenStream step (Cons x xs, state) = (x, (xs, state))
flattenStream step (Nil, state) = flattenStream step (step state)

enumerate :: Stream s a -> s -> List a
enumerate step state = let (x, state') = step state in Cons x (enumerate step state')

sillyStream :: Stream (List Integer, Integer) Integer
sillyStream = flattenStream . transduceStream sillyTr $ countStream

sillyList3 :: List Integer
sillyList3 = enumerate sillyStream (Nil, 1)

----------
-- Main --
----------

main = print (myTake 10 sillyList, myTake 10 sillyList2, myTake 10 sillyList3)

