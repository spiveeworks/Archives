

data Game = Game [Game] [Game]

zeroGame = Game [] []

instance Num Game where
    (+) = disjunctSum
    (*) = surrealProduct
    abs game = if isNegative then negate game else game
    signum game = if isNegative game then minus1 else plus1
        where plus1 = Game [zeroGame] []
              minus1 = Game [] [zeroGame]
    fromInteger x
        | x < 0 = godown x
        | otherwise = goup x
        where godown 0 = zeroGame
              godown i = Game [godown (i-1)] []
              goup 0 = zeroGame
              goup i = Game [] [goup (i+1)]
    negate Game ls rs = Game (map negate rs) (map negate ls)

disjunctSum x@(Game xL xR) y@(Game yL yR) = Game (xL >>= (disjunctSum y) ++ yL >>= (disjunctSum x)) (xR >>= (disjunctSum y) ++ yR >>= (disjunctSum x))

leftLoses (Game moves _) = all rightWins moves
rightLoses (Game _ moves) = all leftWins moves
leftWins (Game moves _) = all rightLoses moves
rightWins (Game _ moves) = all leftLoses moves

--are these correct? which are existential and which are universal?
isZero game = leftLoses game && rightLoses game
isPositive game = leftWins game && rightLoses game
isNegative game = leftLoses game && rightWins game

