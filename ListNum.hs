data IntIsh = IntIsh [()] [()]
data RedInt = RedInt Bool [()]

reduce :: IntIsh -> RedInt
reduce (IntIsh x []) = RedInt False x  -- False is positive so that zero is (False, [])
reduce (IntIsh [] y) = RedInt True y
reduce (IntIsh (():x) (():y)) = reduce (IntIsh x y)

fromReduced :: RedInt -> IntIsh
fromReduced (RedInt True x) = IntIsh [] x
fromReduced (RedInt False x) = IntIsh x []

fromNatural :: Integer -> [()]
fromNatural 0 = []
fromNatural x = () : fromNatural (x - 1)

instance Num RedInt where
  x + y = reduce (fromReduced x + fromReduced y)

  RedInt sx x * RedInt sy y = RedInt (sx != sy) [() | () <- x, () <- y]

  abs (RedInt _ x) = RedInt False x

  signum (RedInt sign _) = RedInt sign [()]

  fromInteger x
    | x < 0 = RedInt True . fromNatural . negate $ x
    | otherwise = RedInt False . fromNatural $ x

  negate (RedInt sign x) = RedInt (not sign) x


instance Num IntIsh where
    IntIsh x1 y1 + IntIsh x2 y2 = IntIsh (x1 ++ x2) (y1 ++ y2)

    i1 * i2 = fromReduced (reduce i1 * reduce i2)

    abs = fromReduced . abs . reduce

    signum = fromReduced . signum . reduce

    fromInteger x
      | x < 0 = IntIsh [] (fromNatural x)
      | otherwise = IntIsh (fromNatural x) []

    negate (IntIsh x y) = IntIsh y x
