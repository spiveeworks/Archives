
seriesBy _ [] = []
seriesBy _ [x] = [x]
seriesBy f (x0:x1:xs) = x0 : (seriesBy f $ x':xs)
    where x' = f x0 x1

series :: (Num a) => [a] -> [a]
series = seriesBy (+)

sequenceFrom f a d = iterate (`f` d) a
-- alternatively sequenceFrom f a d = seriesBy f $ a : repeat d
arithmeticSequence = sequenceFrom (+)
geometricSequence = sequenceFrom (*)

seriesFrom f a d = series(sequenceFrom f a d)
arithmeticSeries = seriesFrom (+)
geometricSeries = seriesFrom (*)


