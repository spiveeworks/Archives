import Data.Maybe
import Data.List

type OpenTerm a = [(String, Term a)] -> Term a
data Term a = Fun (Term a -> Term a) | Value a

close :: OpenTerm a -> Term a
close x = x []

lambda :: String -> OpenTerm a -> OpenTerm a
lambda ident body ctx = Fun (\val -> body ((ident, val) : ctx))

var :: String -> OpenTerm a
var ident ctx = fromJust (lookup ident ctx)

apply :: OpenTerm a -> OpenTerm a -> OpenTerm a
apply f x ctx = applyTerm (f ctx) (x ctx)

applyTerm :: Term a -> Term a -> Term a
applyTerm (Fun f) = f

extractTerm :: Term a -> a
extractTerm (Value x) = x

extractFun :: Term a -> a -> a
extractFun (Fun f) = extractTerm . f . Value



idTerm :: Term a
idTerm = close $ lambda "x" $ var "x"

verboseId :: a -> a
verboseId = extractFun idTerm


data LambdaAST =
  Variable String
  | Lambda String LambdaAST
  | Apply LambdaAST LambdaAST deriving Show

transformAST :: LambdaAST -> Term a
transformAST = close . transform

transform :: LambdaAST -> OpenTerm a
transform (Variable ident) = var ident
transform (Lambda ident body) = lambda ident (transform body)
transform (Apply f x) = apply (transform f) (transform x)

data ParseTree =
  Str String
  | Brackets [ParseTree]

parseAST :: String -> LambdaAST
parseAST ('\\':xs) = Lambda ident (parseAST body)
  where (ident, _ : body) = splitAt (fromJust (elemIndex '.' xs)) xs
parseAST xs = foldl1 Apply $ map Variable $ words xs

parseLambda :: String -> Term a
parseLambda = transformAST . parseAST

parseFun :: String -> a -> a
parseFun = extractFun . parseLambda

