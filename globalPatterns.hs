[a, b, c, d] = take 4 xs
  where xs = 0 : zipWith (+) (repeat 1) xs

main = putStrLn $ show [a,b,c,d]

