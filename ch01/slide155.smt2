; http://disi.unitn.it/~rseba/DIDATTICA/fm2022/SLIDES/01-sat_handouts.pdf
; slide 155 e 157
;
; -unsat_core_generation=INT
;          Enable unsat core generation. Possible values are:
;          - 0 : turn off unsat core generation
;          - 1 : use proof-based unsat core generation
;          - 2 : use lemma-lifting algorithm
;          - 3 : use assumptions-based algorithm.
;
; unsat
; ( (B0 ∨ B1 ∨ A2)
;   (B0 ∨ ¬B1 ∨ A)
;   (B4)
;   (B6 ∨ ¬A1)
;   (¬A2 ∨ B2)
;   (¬B0 ∨ B1 ∨ A2)
;   (¬B0 ∨ ¬B1)
;   (¬B2 ∨ ¬B4)
;   (¬B6 ∨ ¬B4) )

(set-option :produce-unsat-cores true)

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

(assert (! (or B0 (not B1) A1)    :named "(B0 ∨ ¬B1 ∨ A1)"))
(assert (! (or B0 B1 A2)          :named "(B0 ∨ B1 ∨ A2)"))
(assert (! (or (not B0) B1 A2)    :named "(¬B0 ∨ B1 ∨ A2)"))
(assert (! (or (not B0) (not B1)) :named "(¬B0 ∨ ¬B1)"))
(assert (! (or (not B2) (not B4)) :named "(¬B2 ∨ ¬B4)"))
(assert (! (or (not A2) B2)       :named "(¬A2 ∨ B2)"))
(assert (! (or (not A1) B3)       :named "(¬A1 ∨ B3)"))
(assert (! B4                     :named "(B4)"))
(assert (! (or A2 B5)             :named "(A2 ∨ B5)"))
(assert (! (or (not B6) (not B4)) :named "(¬B6 ∨ ¬B4)"))
(assert (! (or B6 (not A1))       :named "(B6 ∨ ¬A1)"))
(assert (! B7                     :named "(B7)"))

(check-sat)
(get-unsat-core)

(exit)
