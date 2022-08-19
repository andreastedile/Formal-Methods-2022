; https://www.sfu.ca/math-coursenotes/Math%20157%20Course%20Notes/sec_Optimization.html 5.8.1
; OptiMathSAT cannot find a solution for this as the objective function is non-linear

(set-option :produce-models true)

(declare-const price_per_item Real) ; the free variable

; number of items sold = 5000 + 1000 * (($1.50 - price per item) / $0.10)
(define-fun n_items_sold () Real (+ 5000 (* 1000 (/ (- 1.50 price_per_item) 0.10))))

; total costs of production = number of items sold * per item cost of production
(define-fun total_cost_prod () Real (* n_items_sold 0.50))

; revenue = (number of items sold * price per item) - total costs of production
(define-fun revenue () Real (- (* n_items_sold price_per_item) total_cost_prod))

; An item must generate revenue
(assert (>= price_per_item 0))
(assert (<= price_per_item 1.50))

; profit = revenue - start-up cost
(maximize (- revenue (+ 2000 total_cost_prod)) :id profit)

(echo "satisfiability:")
(check-sat)

(echo "objectives:")
(get-objectives)

(echo "model:")
(get-model)

(exit)