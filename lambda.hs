import Data.Maybe
import Data.List

data Term a = Fun (Term a -> Term a) | Value a

extractTerm :: Term a -> a
extractTerm (Value x) = x

extractFun :: Term a -> a -> a
extractFun (Fun f) = extractTerm . f . Value

buildFun :: (a -> a) -> Term a
buildFun f = Fun (Value . f . extractTerm)


data LambdaAST a =
  Variable String
  | Lambda String (LambdaAST a)
  | Apply (LambdaAST a) (LambdaAST a)
  | Term (Term a)


transform :: LambdaAST a -> Term a
transform (Lambda ident body) = Fun (\val -> transform (sub ident val body))
transform (Apply f x) = applyTerm (transform f) (transform x)
transform (Term result) = result

sub :: String -> Term a -> LambdaAST a -> LambdaAST a
sub ident val = go
  where go (Lambda ident' body)
          | ident' == ident = Lambda ident' body  -- shadowing
          | otherwise = Lambda ident' (go body)
        go (Apply f x) = Apply (go f) (go x)
        go (Variable ident')
          | ident' == ident = Term val
          | otherwise = Variable ident'
        go (Term other) = Term other


applyTerm :: Term a -> Term a -> Term a
applyTerm (Fun f) = f

data ParseTree =
  Str String
  | Brackets [ParseTree]

parseAST :: String -> LambdaAST a
parseAST ('\\':xs) = Lambda ident (parseAST body)
  where (ident, _ : body) = splitAt (fromJust (elemIndex '.' xs)) xs
parseAST xs = foldl1 Apply $ map Variable $ words xs

parseLambda :: String -> Term a
parseLambda = transform . parseAST

parseFun :: String -> a -> a
parseFun = extractFun . parseLambda

