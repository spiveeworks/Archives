module HanoiTools
( HanoiIndex(..)
, multiMove
) where

import Data.List((\\), elemIndex)

type HanoiTower = [Int]
type Hanoi = (HanoiTower, HanoiTower, HanoiTower)
data HanoiIndex = Lft | Mid | Rit deriving(Eq, Show)

newTower :: Int -> Hanoi
newTower x = ([1..x], [], [])

validGame :: Hanoi -> Bool
validGame (lft, mid, rit) = all ascends [lft, mid, rit]
    where ascends [] = True
          ascends [x] = True
          ascends (x0:x1:xs) = x0 < x1 && ascends (x1:xs)

getTile :: HanoiIndex -> Hanoi -> (Int, Hanoi)
getTile Lft (x:xs, ys, zs) = (x, (xs, ys, zs))
getTile Mid (xs, y:ys, zs) = (y, (xs, ys, zs))
getTile Rit (xs, ys, z:zs) = (z, (xs, ys, zs))

placeTile :: HanoiIndex -> Int -> Hanoi -> Hanoi
placeTile Lft x (xs, ys, zs) = (x:xs, ys, zs)
placeTile Mid y (xs, ys, zs) = (xs, y:ys, zs)
placeTile Rit z (xs, ys, zs) = (xs, ys, z:zs)

applyMove :: HanoiIndex -> HanoiIndex -> Hanoi -> Hanoi
applyMove source dest game = placeTile dest tile game'
    where (tile, game') = getTile source game

-- for foldl
applyMove' :: Hanoi -> (HanoiIndex, HanoiIndex) -> Hanoi
applyMove' game (source, dest) = applyMove source dest game

applyMoves :: [(HanoiIndex, HanoiIndex)] -> Hanoi -> Hanoi
applyMoves = flip $ foldl applyMove'

checkMoves :: [(HanoiIndex, HanoiIndex)] -> Hanoi -> Bool
checkMoves moves game = all validGame $ scanl applyMove' game moves

maybeApplyMove :: Hanoi -> (HanoiIndex, HanoiIndex) -> Maybe Hanoi
maybeApplyMove game move = if validGame game'
                             then Just game'
                             else Nothing
    where game' = applyMove' game move

maybeApplyMoves :: [(HanoiIndex, HanoiIndex)] -> Hanoi -> Maybe Hanoi
maybeApplyMoves [] game = Just game
maybeApplyMoves (move:moves) game = case maybeApplyMove game move of Just game' -> maybeApplyMoves moves game'
                                                                     Nothing -> Nothing

neither :: HanoiIndex -> HanoiIndex -> HanoiIndex
neither x y = head $ [Lft, Mid, Rit] \\ [x, y]

multiMove :: HanoiIndex -> HanoiIndex -> HanoiIndex -> Int -> [(HanoiIndex, HanoiIndex)]
multiMove _ _ _ 0 = []
multiMove source dest via n = (multiMove source via dest (n - 1)) ++ [(source, dest)] ++ (multiMove via dest source (n - 1))

-- locate a tile and identify the number of tiles above it
findTile :: Int -> Hanoi -> (HanoiIndex, Int)
findTile tile (lft, mid, rit) = tryLeft . tryMiddle . tryRight $ undefined
    where try tower tindex backup = case elemIndex tile tower of Just i -> (tindex, i)
                                                                 Nothing -> backup
          tryLeft = try lft Lft
          tryMiddle = try mid Mid
          tryRight = try rit Rit

--solve :: Hanoi -> [(HanoiIndex, HanoiIndex)]
--solve game@(lft, mid, rit) = partial (maximum . map maximum $ [lft, mid, rit]) Rit game
--    where partial Int dest game = 
