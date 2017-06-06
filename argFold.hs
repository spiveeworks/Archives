dothing = foldr func []
  where func "-f" ((False, x):xs) = (True, x):xs
        func x xs = (False, x) : xs

