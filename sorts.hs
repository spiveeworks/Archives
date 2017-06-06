import Data.List

quicksort :: (Ord a) => [a] -> [a]
quicksort [] = []
quicksort (piv:rem) = quicksort lp ++ [piv] ++ quicksort rp
    where (lp, rp) = partition (<piv) rem


insertsort :: (Ord a) => [a] -> [a]
insertsort xs = xs `into` []
    where [] `into` ys = ys
          (x:xs) `into` ys = xs `into` insert x ys

merge :: (Ord a) => [a] -> [a] -> [a]
merge xs [] = xs
merge [] ys = ys
merge xs@(x:xst) ys@(y:yst) = if x < y then x : merge xst ys else y : merge xs yst

slice :: (Ord a) => [a] -> ([a], [a])
slice [] = ([], [])
slice [x] = ([x], [])
slice (x1:x2:xs) = (x1:left, x2:right)
    where (left, right) = slice xs

mergesort :: (Ord a) => [a] -> [a]
mergesort [] = []
mergesort [x] = [x]
mergesort xs = merge (mergesort left) (mergesort right)
    where (left, right) = slice xs

