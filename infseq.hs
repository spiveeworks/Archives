
coords = zipWith (map . (,)) [0..] $ repeat [0..]

diagonals xxs = go [] xxs
    where go lxxs (rxx:rxxs) = let (lxs, lxxs') = geth lxxs in lxs ++ go (rxx:lxxs') rxxs
          geth = unzip . map (\(x:xs) -> (x, xs))


coordsZ3 = concat . map go $ [0..]
  where go n = [(x, y, z) | x <- [-n .. n], y <- [abs x - n .. n - abs x], z <- zs x y]
          where zs x y
                  | abs x + abs y == n = [0]
                  | otherwise = [abs x + abs y - n, n - abs x - abs y]
