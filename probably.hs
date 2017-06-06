

newtype ProbList r a = ProbList {getProbList :: [Writer (Product r) a]}

instance Monad ProbList r where
    return x = ProbList [writer (x, mempty)]
    xps >>= f = ProbList $ do
        xp <- getProbList xps
        xp' <- getProbList . f . fst . runWriter $ xp
        return xp >> xp'


addProb xps yp = go xps
    where y = fst . runWriter $ yp
          go [] = [yp]
          go (xp:xps)
            | y == (fst . runWriter) xp = xp >> y : xps
            | otherwise = xp : go xps
nubProb = foldl addProb []


