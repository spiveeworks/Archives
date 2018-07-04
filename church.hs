import Data.Maybe
import Data.List

data Lambda = Lambda String Lambda | Var String | Lambda :$ Lambda

data Expr = Expr HeadExpr [Expr] deriving Show
data HeadExpr = LambdaExpr Expr | VarExpr Int deriving Show

compile :: Lambda -> Expr
compile = compile_ [] []
compile_ :: [String] -> [Expr] -> Lambda -> Expr
compile_ ctx args (x :$ y) = compile_ ctx (compile_ ctx [] y : args) x
compile_ ctx args (Lambda name body) = Expr head args
  where head = LambdaExpr $ compile_ (name : ctx) [] body
compile_ ctx args (Var name) = Expr head args
  where head = VarExpr $ fromJust $ elemIndex name ctx


substitute :: Expr -> Int -> Expr -> Expr
substitute term n (Expr head tail) = Expr head' (pretail ++ tail')
  where Expr head' pretail = substituteHead term n head
        tail' = map (substitute term n) tail

substituteHead :: Expr -> Int -> HeadExpr -> Expr
substituteHead term n (LambdaExpr x) = Expr head' []
  where head' = LambdaExpr (substitute term' (n+1) x)
        term' = deepen 0 term
substituteHead term n (VarExpr m)
 | n == m = term
 | otherwise = Expr (VarExpr m) []

deepen :: Int -> Expr -> Expr
deepen n (Expr head tail) = Expr head' tail'
  where head' = deepenHead n head
        tail' = map (deepen n) tail
deepenHead n (LambdaExpr x) = LambdaExpr (deepen (n+1) x)
deepenHead n (VarExpr m)
 | m < n = VarExpr m
 | otherwise = VarExpr (m + 1)

-- head normal form
normalize :: Expr -> Expr
normalize (Expr (LambdaExpr x) []) = Expr (LambdaExpr (normalize x)) []
normalize x = betaReduce x

betaReduce 
