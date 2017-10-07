import System.Random
import Control.Monad

coin :: IO Integer
coin = liftM (flip mod 2) randomIO

divergeGame :: IO Integer
divergeGame = do
    x <- coin
    if x == 1
        then liftM (*2) divergeGame
        else return 2

iterateMean :: IO Integer -> (Integer, Integer) -> IO (Integer, Integer)
-- mean accumulating kleisli arrow from some Num action
iterateMean game (total, numGames) = do
    nextGame <- game
    return (total + nextGame, numGames + 1)

displayGame :: IO Integer -> IO a
displayGame game = displayIteration (0, 0)
    where displayIteration tn@(t, n) = do
              let [t', n'] = map fromInteger [t, n]
              putStrLn (show (t' / n'))
              (iterateMean game tn) >>= displayIteration
