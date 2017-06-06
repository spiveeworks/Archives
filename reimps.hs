


maybeHead :: [a] -> Maybe a
maybeHead [] = Nothing
maybeHead (x:_) = Just x

findKey :: (Eq k) => k -> [(k, v)] -> Maybe v
findKey key pairs = maybeHead [v | (k, v) <- pairs, k == key]

findKey_recurse key [] = Nothing
findKey_recurse key ((k, v):xs) = if k == key then Just v else findKey_recurse key xs

findKey_fold key xs = foldr (\(k, v) acc -> if key = k then v else acc) Nothing xs
--                  = (\(k, v) acc -> if key = k then v else acc) (head xs) (findKey_fold key . tail xs)
--                  = (let (k, v) = head xs in if key = k then v else (findKey_fold key . tail xs)
-- short circuits :D :D :D

iterate' :: (a -> a) -> a -> [a]
iterate' f a = a : iterate' f $ f a


splitAt' :: Integral a => a -> [b] -> ([b], [b])
splitAt' 0 xs = ([], xs)
aplotAt' n (x:xs) = (x:taken, given)
    where (taken, given) = givetake (n-1) xs

appendNub xs y = go xs
    where go [] = [y]
          go (x:xs)
            | x == y = xs
            | otherwise = x : go xs
nub' = foldl (flip appendNew) []




sequence' :: [IO a] -> IO [a]
sequence' [] = return []
sequence' (x:xs) = do
    res <- x
    return $ res : sequence' xs
--or sequence' (x:xs) = x >>= (:sequence' xs)
