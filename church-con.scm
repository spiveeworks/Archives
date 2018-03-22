; this is not chibi/r7rs scheme
; I wanted to play with a language that had no return values,
; and scheme syntax was a good fit
; although some of scheme's features are hard,
;   like defining variadic functions without actually having a list type
(define-syntax define (syntax-rules () ()))

(define (id x) (x))
; =>
(define-cps (id x cc) (cc x))

(define (func-comp f g) (lambda (x ...) (f (g x ...))))
; =>
(define-cps
  (func-comp f g ccf)
  (ccf (lambda-cps
    (x ... ccz)
    (g x ... (lambda-cps
      (y ...)
      (f y ... ccz))))))

(define-cps (empty x _) x)

; fold but with the list already filled
; type [a] = (a, b -> b), b -> b

; (a -> b), [a] -> [b]
(define-cps (map f xs cc)
  (xs empty (lambda (x acc cc-acc)
              (f x (lambda (y)
                     (church-cons y acc cc-acc))))
      cc))

(define-cps (eval expr cc) (uncons expr (lambda-cps (func args) ())))

; 3 transformations happen:
; defines become define-cps's, with extra continuation things
; lambdas do similar
; all function calls are translated into CPS

; type a, ... -> b = <a, ..., <b>>

; a -> a
; <a, <a>>
(define-cps
  (id x cc)
  (cc x))

; (b -> c), (a -> b) -> (a -> c)
(define-cps
  (. f g ccf)
  (ccf (lambda-cps
    (x ccv)
    (ccv (f (g x))))))

; (b, b -> c), (a -> b) -> (a, a -> c)
(define-cps
  (on f g ccf)
  (ccf (lambda-cps
    (x1 x2 ccv)
    (f (g x1) (g x2) ccv))))


; a + b = (a -> c), (b -> c) -> c
; <<a, <c>>, <b, <c>>, <c>>

; a -> a + b
; <a, <<a, <c>>, <b, <c>>, <c>>>
(define-cps
  (inl x ccf)
  (ccf (lambda-cps (ml mr ccv) (ml x ccv))))

; b -> a + b
; b -> a + b
; <b, <<a, <c>>, <b, <c>>, <c>>>
(define-cps
  (inr y ccf)
  (ccf (lambda-cps (ml mr ccv) (mr y ccv))))


; a * b = (a, b -> c) -> c
; <<a, b, <c>>, <c>>

; a, b -> a * b
(define-cps
  (pair x y ccf)
  (ccf (lambda-cps (f ccv) (f x y ccv))))

; a * b -> a
(define-cps
  (fst p cc)
  (p (lambda-cps (x y) (cc x))))

; a * b -> b
(define-cps
  (snd p cc)
  (p (lambda-cps (x y) (cc y))))


; type nat = (a -> a) -> (a -> a)
; <<a, <a>>, <<a, <a>>>>

; nat
(define-cps
  (zero f cc)
  (cc id))

; nat
(define-cps one id)

; nat, nat -> nat
(define-cps
  (+ n m ccn)
  (ccn (lambda-cps
    (f ccf)
    (ccf (. (n f) (m f))))))

; nat -> nat
(define-cps
  (succ n ccn)
  (ccn (+ 1 n)))

; nat, nat -> nat

