(import (scheme r5rs))
(import (scheme base))

(display
  (call/cc (lambda (cc)
            (display "I got here.\n")
            (cc "This string was passed to the continuation.\n")
            (display "But not here.\n"))))
