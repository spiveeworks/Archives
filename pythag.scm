(import (chibi))


(let ((a (amb (list 1 2 3 4 5 6 7)))
      (b (amb (list 1 2 3 4 5 6 7)))
      (c (amb (list 1 2 3 4 5 6 7))))
  
  ; We're looking for dimensions of a legal right
  ; triangle using the Pythagorean theorem:
  (assert (= (* c c) (+ (* a a) (* b b))))
  
  ; And, we want the second side to be the shorter one:
  (assert (< b a))

  ; Print out the answer:
  (display (list a b c))
  (newline))
