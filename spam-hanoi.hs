import Misc (splitUp)
import HanoiTools
import Control.Monad(forM)

main = do
    tilesS <- getLine
    let tiles = read tilesS :: Int
        moves = multiMove Lft Mid Rit tiles
        output = splitUp 2000 . show $ moves
    forM output putStrLn
