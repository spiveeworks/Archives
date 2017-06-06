
primes :: (Integral a) => [a]
primes = 2 : filter sievePrimes [3..]
    where sievePrimes n = not . any (divisorOf n) . takeWhile (<= iroot n) $ primes
          divisorOf n a = n `mod` a == 0
          iroot = floor . sqrt . fromIntegral

fibbs = 0 : 1 : zipWith (+) fibbs (tail fibbs)

factorials = 1 : zipWith (*) [1..] factorials

triangles = 0 : zipWith (+) [1..] triangles

tetrahedra = 0 : zipWith (+) (tail triangles) tetrahedra
