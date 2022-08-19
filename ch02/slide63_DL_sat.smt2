; mathsat ch02/slide63.smt2
; sat

(set-option :produce-models true)
(set-option :produce-unsat-cores true)

(declare-const x1 Int)
(declare-const x2 Int)
(declare-const x3 Int)
(declare-const x4 Int)

; x1 − x2 ≤ −1
(assert (!
    (<= (- x1 x2) (- 1))
:named "x1 − x2 ≤ −1"))

; x1 − x4 ≤ −1
(assert (!
    (<= (- x1 x4) (- 1))
:named "x1 − x4 ≤ −1"))

; x1 − x3 ≤ −2
(assert (!
    (<= (- x1 x3) (- 2))
:named "x1 − x3 ≤ −2"))

; x3 − x4 ≤ −2
(assert (!
    (<= (- x3 x4) (- 2))
:named "x3 − x4 ≤ −2"))

; x3 − x2 ≤ −1
(assert (!
    (<= (- x3 x2) (- 1))
:named "x3 − x2 ≤ −1"))

; x4 − x2 ≤ 3
(assert (!
    (<= (- x4 x2) 3)
:named "x4 − x2 ≤ 3"))

; x4 − x3 ≤ 6
(assert (!
    (<= (- x4 x3) 6)
:named "x4 − x3 ≤ 6"))

(check-sat)
(get-unsat-core)

(exit)