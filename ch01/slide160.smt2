; http://disi.unitn.it/~rseba/DIDATTICA/fm2022/SLIDES/01-sat_handouts.pdf
; slide 160
;
; https://mathsat.fbk.eu/smt2examples.html
;
; unsat
; (and (not B2) (not (and (not B1) (and B3 B4))))
;
; it corresponds to:
; (B1 ∨ ¬B3 ∨ ¬B4) ∧ ¬B2

(set-option :produce-unsat-cores true)

(declare-const A1 Bool)
(declare-const A2 Bool)
(declare-const B1 Bool)
(declare-const B2 Bool)
(declare-const B3 Bool)
(declare-const B4 Bool)

(assert (! (or B1 A1)                               :interpolation-group A))
(assert (! A2                                       :interpolation-group A))
(assert (! (or (not B2) (not A2))                   :interpolation-group A))
(assert (! (or (not A1) (not A2) (not B3) (not B4)) :interpolation-group A))

(assert (! (or (not B3) B4)                         :interpolation-group B))
(assert (! (or (not B1) B2)                         :interpolation-group B))
(assert (! (or B1 B3)                               :interpolation-group B))

(check-sat)

(get-interpolant (A))

(exit)
