; https://www.sfu.ca/math-coursenotes/Math%20157%20Course%20Notes/sec_Optimization.html 5.8.7
; OptiMathSAT cannot find a solution for this as the objective function is non-linear

(set-option :produce-models true)

(declare-const b Real)
(declare-const h Real)

(assert (>= b 0))
(assert (>= h 0))
(assert (= (* b h) 100))

(minimize (+ b b h h) :id perimetro)

(echo "satisfiability:")
(check-sat)

(echo "objectives:")
(get-objectives)

(echo "model:")
(get-model)

(exit)
