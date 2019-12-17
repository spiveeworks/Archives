
data Tree a = Leaf a | Branch [Tree a] deriving Show

type FreqMap a = [(Int, a)]

-- should probably be left to right with seq but hey we're only dealing with
-- 40ish characters
popMin :: FreqMap a -> Maybe ((Int, a), FreqMap a)
popMin [] = Nothing
popMin (x0 : xs) = case popMin xs of
  Nothing -> Just (x0, [])
  Just (x1, xs) -> Just (if fst x0 < fst x1 then
    (x0, x1:xs) else
    (x1, x0:xs))

selectN :: Int -> FreqMap a -> (FreqMap a, FreqMap a)
selectN n xs
  | n < 0 = undefined
  | n == 0 = ([], xs)
  | n > 0 = case popMin xs of
    Nothing -> ([], [])
    Just (min, xs') -> let (sel, xs'') = selectN (n-1) xs' in (min:sel, xs'')

initFreqMap :: FreqMap a -> FreqMap (Tree a)
initFreqMap = map (\(r, x) -> (r, Leaf x))

freqSeq :: FreqMap a -> (Int, [a])
freqSeq = foldr (\(r0, x) (r1, xs) -> (r0 + r1, x : xs)) (0, [])

iterateHuffman :: Int -> FreqMap (Tree a) -> FreqMap (Tree a)
iterateHuffman n xs = result where
  (sel, xs') = selectN n xs
  (r, sel') = freqSeq sel
  result = (r, Branch sel') : xs'

finishHuffman :: Int -> FreqMap (Tree a) -> Tree a
finishHuffman n [] = Branch []
finishHuffman n [(r, x)] = x
finishHuffman n xs = finishHuffman n (iterateHuffman n xs)

startHuffman :: Int -> FreqMap (Tree a) -> FreqMap (Tree a)
startHuffman n xs = result where
  k = length xs `mod` (n - 1)
  k' = if k == 0 then n - 1 else k
  result = if k' == 1 then xs else iterateHuffman k' xs

huffman :: Int -> FreqMap a -> Tree a
huffman n = finishHuffman n . startHuffman n . initFreqMap

-- total ~= 100 000
freqs :: FreqMap Char
freqs = [
    ( 8167, 'a'),
    ( 1492, 'b'),
    ( 2202, 'c'),
    ( 4253, 'd'),
    (12702, 'e'),
    ( 2228, 'f'),
    ( 2015, 'g'),
    ( 6094, 'h'),
    ( 6966, 'i'),
    (  153, 'j'),
    ( 1292, 'k'),
    ( 4025, 'l'),
    ( 2406, 'm'),
    ( 6749, 'n'),
    ( 7507, 'o'),
    ( 1929, 'p'),
    (   95, 'q'),
    ( 5987, 'r'),
    ( 6327, 's'),
    ( 9356, 't'),
    ( 2758, 'u'),
    (  978, 'v'),
    ( 2560, 'w'),
    (  150, 'x'),
    ( 1994, 'y'),
    (   77, 'z')
  ]

main :: IO ()
main = print (huffman 4 freqs)

result :: Tree Char
result = Branch [
  Leaf 'e',
  Branch [
    Leaf 'd',
    Leaf 'r',
    Leaf 'h',
    Branch [
      Leaf 'k',
      Branch [
        Leaf 'x',
        Leaf 'j',
        Branch [
          Leaf 'z',
          Leaf 'q'
        ],
        Leaf 'v'
      ],
      Leaf 'b',
      Leaf 'p'
    ]
  ],
  Branch [
    Leaf 's',
    Leaf 'n',
    Leaf 'i',
    Leaf 'o'
  ],
  Branch [
    Leaf 'a',
    Branch [
      Leaf 'y',
      Leaf 'g',
      Leaf 'c',
      Leaf 'f'
    ],
    Leaf 't',
    Branch [
      Leaf 'm',
      Leaf 'w',
      Leaf 'u',
      Leaf 'l'
    ]
  ]]
