(m >>= f) >>= g
(concat (map f m)) >> g
concat (map g (concat (map f m)))
concat . map g . concat . map f $ m

m >>= \x -> f x >>= g
concat . map (\x -> f x >>= g) $ m
concat . map (\x -> concat (map g (f x))) $ m
concat . map (concat . map g . f) $ m



(m >>= f) >>= g
(case m of Just x -> f x; Nothing -> Nothing) >>= g
case (case m of Just x -> f x; Nothing -> Nothing) of Just x' -> g x'; Nothing -> Nothing

m >>= \x -> f x >>= g
case m of Just x -> (f x >>= g); Nothing -> Nothing
case m of Just x -> (case f x of Just x' -> g x'; Nothing -> Nothing); Nothing -> Nothing






(>>=) for IO gives:: IO a -> (a -> IO b) -> IO b
so getLine >>= putStrLn will bounce a line of input






newtype State s a = State { runState :: s -> (a,s) }
i.e. a State of s and a is a function that takes an s, and returns an a, and a new s
so a stateful computation is one which changes a state, while generating a value

usesState >>= f state = let (a, state') = usesState state in f a state'
