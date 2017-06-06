

data Tree a = Tree a [Tree a]

pathTree (x : xs@(x':xs')) = Tree x [pathTree xs]
pathTree [x] = Tree x []

pathTree :: [a] -> [Tree a] -- Never a two length list, nor have any descendants' child lists
pathTree = foldr singleTree []
  where singleTree x ts = [Tree x ts]

treeAppend :: [a] -> [Tree a] -> [Tree a]
treeAppend [] trees = trees
treeAppend xs [] = pathTree xs
treeAppend xs@(x:xs') (t@(Tree y tys):ts)
  | x == y = Tree y (treeAppend xs' tys) : ts
  | otherwise = t : treeAppend xs ts

makeTree :: [[a]] -> [Tree a]
makeTree = foldr treeAppend []


