-- like the State Monad but with a changing state
class Scopeful s where
    -- used to create a scoped action that does not transform anything
    scopeReturn :: a -> s t t a
    -- feed a scoped action into a function that acts with the result
    scopeBind :: s t0 t1 a -> (a -> s t1 t2 b) -> s t0 t2 b

    -- apply two actions in order without using the results of the first
    scopeChain :: s t0 t1 () -> s t1 t2 a -> s t0 t2 a
    scopeChain ssnl ssa = ssnl `scopeBind` \() -> ssa

newtype ScopeState t0 t1 a = ScopeState {getSState :: t0 -> (t1, a)}

instance Scopeful ScopeState where
    scopeBind ss01 fss12 = ScopeState fs2
      where fs2 s0 = getSState (ss12 val) s1
              where (s2, val) = getSState ss01 s0

composeScope :: (a -> s t0 t1 b) -> (b -> s t1 t2 c) -> (a -> s t0 t2 c)
composeScope fss01 fss12 = \ x -> fss01 x `scopeBind` fss12

apScope :: s t0 t1 (a -> b) -> s t1 t2 a -> s t0 t2 b
apScope ss01 ss12 = ss01 `scopeBind` \ f -> liftScope f ss12

liftScope :: (a -> b) -> s t0 t1 a -> s t0 t1 b
liftScope f ss = ss `scopeBind` scopeReturn . f

joinScope :: s t0 t1 (s t1 t2 a) -> s t0 t2 a
joinScope ssssx = ssssx `scopeBind` id

voidScope :: s t0 t1 a -> s t0 t1 ()
voidScope = liftScope \x -> ()


removeScope :: ScopeState t t -> State t
removeScope = State . getSState

applyScope :: State t -> ScopeState t t
applyScope = getState . ScopeState


newtype ScopeMonad s t a = ScopeMonad {getScopeMonad :: s t t a}

Scopeful s => instance Monad ScopeMonad s t where
    return = ScopeMonad . scopeReturn
    ma >>= fmb = ScopeMonad $ getScopeMonad ma `scopeBind` getScopeMonad . fmb
    ScopeMonad ssa >> ScopeMonad ssb = ScopeMonad $ voidScope ssa `scopeChain` ssb

