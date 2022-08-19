; https://www.sfu.ca/math-coursenotes/Math%20157%20Course%20Notes/sec_Optimization.html 5.8.1
; OptiMathSAT cannot find a solution for this as the objective function is non-linear

(set-option :produce-models true)

(declare-const x Real)

(define-fun profit () Real (+
    (* (- 10000) (* x x))
    (* 25000 x)
    (- 12000)
))

(assert (>= x 0))
(assert (<= x 1.50))

(maximize profit)

(echo "satisfiability:")
(check-sat)

(echo "objectives:")
(get-objectives)

(echo "model:")
(get-model)

(exit)
