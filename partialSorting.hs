import Data.Maybe

data Tree a = Empty | Node a (Tree a) (Tree a) deriving Show

intoRowOrder :: Tree a -> [a]
intoRowOrder t = intoRowOrderHelper [t]

intoRowOrderHelper :: [Tree a] -> [a]
intoRowOrderHelper [] = []
intoRowOrderHelper ts = catMaybes heads ++ intoRowOrderHelper (concat tails)
  where heads = map treeHead $ ts
        tails = map treeTails $ ts

treeHead Empty = Nothing
treeHead (Node x _ _) = Just x

treeTails Empty = []
treeTails (Node _ l r) = [l, r]

fromRowOrder :: [a] -> Tree a
fromRowOrder [] = Empty
fromRowOrder xs = head . fromRowOrderHelper 1 $ xs

fromRowOrderHelper :: Int -> [a] -> [Tree a]
fromRowOrderHelper _ [] = []
fromRowOrderHelper n xs = zipTrees heads (fromRowOrderHelper (2*n) tails)
  where (heads, tails) = splitAt n xs

zipTrees :: [a] -> [Tree a] -> [Tree a]
zipTrees [] _ = []
zipTrees (x:xs) (l:r:rest) = Node x l r : zipTrees xs rest
zipTrees xs rest = zipTrees xs (rest ++ repeat Empty)


heapify Empty = Empty
heapify (Node x l r) = siftDown x (heapify l) (heapify r)

siftDown x Empty xs = siftDown1 x xs
siftDown x xs Empty = siftDown1 x xs
siftDown x l@(Node lh ll lr) r@(Node rh rl rr)
  | x > lh && x > rh = Node x l r
  | lh > rh = Node lh (siftDown x ll lr) r
  | otherwise = Node rh l (siftDown x rl rr)

siftDown1 x Empty = Node x Empty Empty
siftDown1 x t@(Node th tl tr)
  | x > th = Node x t Empty
  | otherwise = Node th (siftDown x tl tr) Empty

deleteMax :: Ord a => Tree a -> Maybe (a, Tree a)
deleteMax Empty = Nothing
deleteMax (Node x Empty Empty) = Just (x, Empty)
deleteMax t = Just (top, siftDown bottom l r)
  where (bottom, Node top l r) = treeLast t

treeLast (Node x Empty Empty) = (x, Empty)
treeLast (Node x l Empty) = (x', Node x l' Empty)
  where (x', l') = treeLast l
treeLast (Node x l r) = (x', Node x l r')
  where (x', r') = treeLast r


applyN n f x = iterate f x !! n

partialHeapSort n = finish . applyN n heapSortStep . start
  where start xs = (heapify $ fromRowOrder xs, [])
        finish (t, xs) = intoRowOrder t ++ xs


heapSortStep :: Ord a => (Tree a, [a]) -> (Tree a, [a])
heapSortStep (Empty, sorted) = (Empty, sorted)
heapSortStep (t, sorted) = (t', x:sorted)
  where Just (x, t') = deleteMax t


split :: [a] -> ([a], [a])
split xs = splitAt (length xs + 1) xs

merge :: Ord a => [a] -> [a] -> [a]
merge (x:xs) (y:ys)
  | x < y = x : merge xs (y:ys)
  | otherwise = y : merge (x:xs) ys

mergeSort :: Ord a => [a] -> [a]
mergeSort [] = []
mergeSort [a] = [a]
mergeSort xs = uncurry merge $ split xs


partition :: Int -> [a] -> ([a], a, [a])


partitionBad :: Int -> [a] -> [a]
partitionBad n xs = l ++ pivot ++ init r ++ [last r]
  where (l, pivot, r) = partition n xs
