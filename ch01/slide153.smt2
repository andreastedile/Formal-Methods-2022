; http://disi.unitn.it/~rseba/DIDATTICA/fm2022/SLIDES/01-sat_handouts.pdf
; slide 153
;
; -proof_generation=BOOL
;          Enable proof generation.
; mathsat ch01/slide153.smt2 -proof_generation=true
;
; unsupported

(set-option :produce-proofs true)

(declare-const A1 Bool)
(declare-const A2 Bool)
(declare-const B0 Bool)
(declare-const B1 Bool)
(declare-const B2 Bool)
(declare-const B3 Bool)
(declare-const B4 Bool)
(declare-const B5 Bool)
(declare-const B6 Bool)
(declare-const B7 Bool)

(assert (or B0 (not B1) A1))
(assert (or B0 B1 A2))
(assert (or (not B0) B1 A2))
(assert (or (not B0) (not B1)))
(assert (or (not B2) (not B4)))
(assert (or (not A2) B2))
(assert (or (not A1) B3))
(assert B4)
(assert (or A2 B5))
(assert (or (not B6) (not B4)))
(assert (or B6 (not A1)))
(assert B7)

(check-sat)
(get-proof)

(exit)
