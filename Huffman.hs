
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

huffman :: Int -> FreqMap a -> Tree a
huffman n = finishHuffman n . initFreqMap

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
  Branch [
    Leaf 'o',
    Branch [
      Leaf 'p',
      Leaf 'y',
      Leaf 'g',
      Leaf 'c'
    ],
    Leaf 'a',
    Leaf 't'
  ],
  Branch [
    Branch [
      Leaf 'f',
      Leaf 'm',
      Leaf 'w',
      Leaf 'u'
    ],
    Leaf 'e',
    Branch [
      Leaf 'l',
      Branch [
        Branch [
          Leaf 'z',
          Leaf 'q',
          Leaf 'x',
          Leaf 'j'
        ],
        Leaf 'v',
        Leaf 'k',
        Leaf 'b'
      ],
      Leaf 'd',
      Leaf 'r'
    ],
    Branch [
      Leaf 'h',
      Leaf 's',
      Leaf 'n',
      Leaf 'i'
    ]
  ]]
