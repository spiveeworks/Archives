
module Misc
( splitUp
) where

decurry :: (a -> b -> c) -> (a, b) -> c
decurry f (x, y) = f x y

--decurry.decurry $ f ((x, y), z) = decurry ()

decurry3 :: (a -> b -> c -> d) -> (a, b, c) -> d
decurry3 f (x, y, z) = f x y z


splitUp n list = go list
    where go [] = []
          go list' = left : go list''
            where (left, list'') = splitAt n list'

exclude :: Integral i => i -> [a] -> [a]
exclude _ [] = []
exclude 0 = tail
exclude n (x:xs) | n > 0 = x : exclude (n-1) xs
