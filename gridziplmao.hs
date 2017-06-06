

data Grid a = Grid a [a] [a] (Grid a) | GridEnd

toLists GridEnd = []
toLists (Grid x xs ys g) = (x:xs):(consZip ys (toLists g))
  where consZip (y:ys) (xs:xxs) = (y : xs) : (consZip ys xxs)
        consZip [] xxs = xxs
        consZip ys [] = map (:[]) ys

fromLists ((x:xs):xxs) = Grid x xs xheads (fromList xtails)
  where (xheads, xtails) = foldr unconsAccum ([],[]) xxs
        unconsAccum (x:xs) (hs, ts) = (x:hs,xs:ts)
        unconsAccum [] ([], []) = ([], [])
fromLists xxs = matchEmpty xxs GridEnd
  where matchEmpty ([]:xxs) = matchEmpty xxs
        matchEmpty [] = id


data GridZipper a = diag (Grid a) (Grid a)

moveUp (GridZipper (Grid x xs ys up) down) = GridZipper up (Grid x xs ys down)
moveDown (GridZipper up (Grid x xs ys down)) = GridZipper (Grid x xs ys up) down




