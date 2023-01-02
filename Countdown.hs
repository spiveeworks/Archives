data Expr = L Int | Expr `Plus` Expr | Expr `Minus` Expr
            | Expr `Times` Expr | Expr `Divide` Expr

instance Show Expr where
  showsPrec _ (L x) = (++) (show x)
  showsPrec i (x `Plus` y) = (++) "(" . showsPrec i x . (++) " + " . showsPrec i y . (++) ")"
  showsPrec i (x `Minus` y) = (++) "(" . showsPrec i x . (++) " - " . showsPrec i y . (++) ")"
  showsPrec i (x `Times` y) = (++) "(" . showsPrec i x . (++) " * " . showsPrec i y . (++) ")"
  showsPrec i (x `Divide` y) = (++) "(" . showsPrec i x . (++) " / " . showsPrec i y . (++) ")"


combinations :: [Int] -> [[Int]]
combinations [] = [[]]
combinations (x : xs) = cs ++ map ((:) x) cs where cs = combinations xs

chooseOne :: [Int] -> [(Int, [Int])]
chooseOne [] = []
chooseOne (x : xs) = (x, xs) : map (\(y, ys) -> (y, x:ys)) (chooseOne xs)

appendExpr :: Int -> (Expr, Int) -> [(Expr, Int)]
appendExpr x (yExpr, y) = divA ++ divB ++ subtract ++ add ++ mul where
  divA = if x `mod` y == 0 then [(L x `Divide` yExpr, x `div` y)] else []
  divB = if y `mod` x == 0 then [(yExpr `Divide` L x, y `div` x)] else []
  subtract = if x > y then [(L x `Minus` yExpr, x - y)]
                      else if x < y then [(yExpr `Minus` L x, y - x)]
                                    else []
  add = [(L x `Plus` yExpr, x + y), (yExpr `Plus` L x, y + x)]
  mul = [(L x `Times` yExpr, x * y), (yExpr `Times` L x, y * x)]

generateExprsStrict :: [Int] -> [(Expr, Int)]
generateExprsStrict [x] = [(L x, x)]
generateExprsStrict [x, y] = appendExpr x (L y, y)
generateExprsStrict args = do
  (arg, rest) <- chooseOne args
  expr <- generateExprsStrict rest
  appendExpr arg expr

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

