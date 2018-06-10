


data SKTree = S | K | SKTree :$ SKTree deriving (Show, Eq)
data IotaTree = Iota | IotaTree :! IotaTree deriving (Show, Eq)

class Combinator a where
    ($$) :: a -> a -> a
    -- note that many combinators will freeze when eval'd
    -- law: eval . eval == eval
    eval :: a -> a
    -- law: eval (iota $$ x) == eval ((x $$ combS) $$ combK)
    iota :: a
    iota = combS $$ (combS $$ combI $$ (combK $$ combS)) $$ (combK $$ combK)

    -- law: eval (combK $$ x $$ y) == eval x
    combK :: a
    combK = iota $$ (iota $$ (iota $$ iota))

    -- law: eval (combS $$ x $$ y $$ z) == eval (x $$ z $$ (y $$ z))
    combS :: a
    combS = iota $$ combK

    -- law: eval (combI $$ x) == eval x
    combI :: a
    combI = combS $$ combK $$ combK
    -- alternatively combI = iota $$ iota

-- derivation of default value for iota
-- \x.(xS)K
-- S(\x.xS)(\x.K)
-- S(\x.xS)(KK)
-- S(S(\x.x)(\x.S))(KK)
-- S(SI(KS))(KK)

-- expansion of iota as lambda term
-- iota x = (xS)K
-- iota x = (x(\x y z. x z (y z)))(\x _. x)
-- iota x y = 
instance Combinator SKTree where
  ($$) = (:$)

  eval S = S
  eval K = K
  eval (x :$ y) = reduceThenEval (x' :$ y')
    where x' = eval x
          y' = eval y
          reduceThenEval (K :$ x :$ y) = eval x
          reduceThenEval (S :$ x :$ y :$ z) = eval (x :$ z :$ (y :$ z))
          reduceThenEval x = x

  combK = K

  combS = S

fromSK :: Combinator a => SKTree -> a
fromSK S = combS
fromSK K = combK
fromSK (x :$ y) = fromSK x $$ fromSK y

fromIota :: Combinator a => IotaTree -> a
fromIota Iota = iota
fromIota (x :! y) = fromIota x $$ fromIota y

instance Combinator IotaTree where
  ($$) = (:!)

  eval = fromSK . eval . fromIota  -- a direct implementation could give more
                                   -- compact results, but would be emulating
                                   -- SK evaluation

  iota = Iota


iterateIota :: Combinator a => [a]
iterateIota = map eval $ iterate helper iota
  where helper x = iota $$ x
