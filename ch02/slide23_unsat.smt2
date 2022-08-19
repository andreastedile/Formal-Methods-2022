; mathsat -unsat_core_generation=1 ch02/slide23.smt2
; unsat
; ( (f(d) = f(0)) => (read(write(V, i, x), (i + d)) = x + 1)
;   d < 1
;   d ≥ 0 )

(set-option :produce-models true)
(set-option :produce-unsat-cores true)

(declare-const d Int)

(declare-sort my_sort 0)
(declare-fun f (Int) my_sort)


(declare-const V (Array Int Int))
(declare-const x Int)
(declare-const i Int)

; (d ≥ 0)
(assert (!
    (>= d 0)
:named "d ≥ 0"))

; (d < 1)
(assert (!
    (< d 1)
:named "d < 1"))

; ((f(d) = f(0)) → (read(write(V, i, x), i + d) = x + 1))
(assert (!
    (=>
        (= (f d) (f 0))
        (= (select (store V i x) (+ i d)) (+ x 1))
    )
:named "(f(d) = f(0)) => (read(write(V, i, x), (i + d)) = x + 1)"))


(check-sat)
(get-unsat-core)

(exit)