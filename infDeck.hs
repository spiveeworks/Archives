
type Freq a = [(Int, a)]

genDeck :: [a] -> [Int] -> [a]
genDeck xs = genDeckFromFreq (fromList xs)

fromList :: [a] -> Freq a
fromList xs = [(length xs, x) | x <- xs]

genDeckFromFreq :: Freq a -> [Int] -> [a]
genDeckFromFreq _ [] = []
genDeckFromFreq freq (roll:rolls) = choice : genDeckFromFreq freq'' rolls
  where (freq', choice) = drawFromFreq freq roll
        freq'' = incrementFreq freq'


incrementFreq :: Freq a -> Freq a
incrementFreq = map (\(f, c) -> (f + 1, c))

drawFromFreq :: Freq a -> Int -> (Freq a, a)
drawFromFreq freq n = case drawFromFreq_ freq n of
    Left n' -> drawFromFreq freq n'
    Right result -> result

drawFromFreq_ :: Freq a -> Int -> Either Int (Freq a, a)
drawFromFreq_ [] n = Left n
drawFromFreq_ ((f, c):freq) n
  | n < f = Right ((0, c):freq, c)
  | otherwise = case drawFromFreq_ freq (n - f) of
        Left x -> Left x
        Right (freq', c') -> Right ((f, c):freq', c')


