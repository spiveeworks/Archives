module RPN (calcRPN) where

import qualified Data.Char as Char

peelNums :: (Integral a, Read a) => [String] -> ([a], [String])
peelNums [] = ([], [])
peelNums xs@(x:xs') = if all Char.isNumber x
                    then let (left, right) = peelNums xs' in (left ++ [read x], right)
                    else ([], xs)

applyOp :: (Integral a) => [a] -> [String] -> ([a], [String])
applyOp nums [] = (nums, [])
applyOp (x:y:nums) (op:ops) = case lookup op opDispatch of Just f -> (f x y : nums, ops)
    where opDispatch = [("+", (+)), ("-", (-)), ("*", (*)), ("/", div), ("%", mod)]

calcRPN :: (Integral a, Read a) => String -> a
calcRPN line = process [] . words $ line
    where process nums [] = head nums
          process nums xs = process nums' xs''
              where (moreNums, xs') = peelNums xs
                    (nums', xs'') = applyOp (moreNums ++ nums) xs'



