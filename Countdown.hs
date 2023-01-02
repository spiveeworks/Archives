import Control.Arrow (first, second)

data Expr = L Int | Expr `Plus` Expr | Expr `Minus` Expr
            | Expr `Times` Expr | Expr `Divide` Expr

instance Show Expr where
  showsPrec _ (L x) = (++) (show x)
  showsPrec i (x `Plus` y) = (++) "(" . showsPrec i x . (++) " + " . showsPrec i y . (++) ")"
  showsPrec i (x `Minus` y) = (++) "(" . showsPrec i x . (++) " - " . showsPrec i y . (++) ")"
  showsPrec i (x `Times` y) = (++) "(" . showsPrec i x . (++) " * " . showsPrec i y . (++) ")"
  showsPrec i (x `Divide` y) = (++) "(" . showsPrec i x . (++) " / " . showsPrec i y . (++) ")"


partitionsRaw :: [Int] -> [([Int], [Int])]
partitionsRaw [] = [([], [])]
partitionsRaw (x : xs) = map (first ((:) x)) cs ++ map (second ((:) x)) cs where
  cs = partitionsRaw xs

-- partitions without redundancy or empty parts
partitions :: [Int] -> [([Int], [Int])]
partitions [] = []
partitions (x : xs) = [(x : ls, rs) | (ls, rs) <- partitionsRaw xs, not (null rs)]

-- combinations = map fst . partitionsRaw
combinations :: [Int] -> [[Int]]
combinations [] = [[]]
combinations (x : xs) = cs ++ map ((:) x) cs where cs = combinations xs

appendExpr :: (Expr, Int) -> (Expr, Int) -> [(Expr, Int)]
appendExpr (xExpr, x) (yExpr, y) = divA ++ divB ++ subtract ++ add ++ mul where
  divA = if x `mod` y == 0 then [(xExpr `Divide` yExpr, x `div` y)] else []
  divB = if y `mod` x == 0 then [(yExpr `Divide` xExpr, y `div` x)] else []
  subtract = if x > y then [(xExpr `Minus` yExpr, x - y)]
                      else if x < y then [(yExpr `Minus` xExpr, y - x)]
                                    else []
  add = [(xExpr `Plus` yExpr, x + y), (yExpr `Plus` xExpr, y + x)]
  mul = [(xExpr `Times` yExpr, x * y), (yExpr `Times` xExpr, y * x)]

generateExprsStrict :: [Int] -> [(Expr, Int)]
generateExprsStrict [] = []
generateExprsStrict [x] = [(L x, x)]
generateExprsStrict args = do
  (largs, rargs) <- partitions args
  lexpr <- generateExprsStrict largs
  rexpr <- generateExprsStrict rargs
  appendExpr lexpr rexpr

generateExprsLenient :: [Int] -> [(Expr, Int)]
generateExprsLenient xs = combinations xs >>= generateExprsStrict

solveExpr :: Int -> [Int] -> [Expr]
solveExpr target args = [expr | (expr, val) <- generateExprsLenient args, val == target]

solveExprOnce :: Int -> [Int] -> Expr
solveExprOnce x xs = head (solveExpr x xs)

pickArgs :: IO [Int]
pickArgs = return [75, 50, 2, 3, 8, 7]

pickTarget :: IO Int
pickTarget = return 812

main :: IO ()
main = do
  target <- pickTarget
  args <- pickArgs
  putStrLn ("Solving " ++ show target ++ " from" ++ concat (map (\arg -> ' ' : show arg) args))
  let solutions = solveExpr target args
  putStrLn ("First solution: " ++ show (head solutions))
  putStrLn "Calculating total number of solutions..."
  putStrLn (show (length solutions))

