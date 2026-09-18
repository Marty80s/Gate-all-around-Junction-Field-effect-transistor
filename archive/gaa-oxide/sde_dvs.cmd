; ============================================================
;   Gate-All-Around JFET — FINAL SDE GEOMETRY FILE
; ============================================================

(sde:clear)

; -----------------------------
; PARAMETERS
; -----------------------------
(define Rch     0.02)      ; Channel radius (µm)
(define tox     0.005)     ; Gate oxide thickness
(define tgate   0.01)      ; Gate silicon thickness
(define Lch     0.10)      ; Channel length
(define Lsd     0.05)      ; Source/drain extension

(define xs0 0.0)
(define xs1 Lsd)
(define xc0 xs1)
(define xc1 (+ xc0 Lch))
(define xd0 xc1)
(define xd1 (+ xd0 Lsd))

(define Rox    (+ Rch tox))
(define Rgate  (+ Rch tox tgate))

; ============================================================
; GEOMETRY CREATION
; ============================================================

; Gate silicon (outer cylinder)
(sdegeo:create-cylinder
  (position xs0 0 0) (position xd1 0 0)
  Rgate "Silicon" "gate")

; Gate oxide
(sdegeo:create-cylinder
  (position xs0 0 0) (position xd1 0 0)
  Rox "Oxide" "GateOxide")

; Channel silicon
(sdegeo:create-cylinder
  (position xs0 0 0) (position xd1 0 0)
  Rch "Silicon" "Channel")

; Source (left)
(sdegeo:create-cylinder
  (position xs0 0 0) (position xs1 0 0)
  Rch "Silicon" "source")

; Drain (right)
(sdegeo:create-cylinder
  (position xd0 0 0) (position xd1 0 0)
  Rch "Silicon" "drain")

; ============================================================
; CONTACT SETS
; ============================================================

(sdegeo:define-contact-set "source" 7)
(sdegeo:define-contact-set "drain"  7)
(sdegeo:define-contact-set "gate"   7)

; ============================================================
; CONTACTS (3D POLYGONS)
; ============================================================

; -------- SOURCE CONTACT (left circular patch) --------
(sdegeo:define-contact "source"
  (list
    (position xs0  0       0)
    (position xs0  Rch     0)
    (position xs0  0       Rch)
    (position xs0 (- Rch)  0)
    (position xs0  0     (- Rch))
  ))

; -------- DRAIN CONTACT (right circular patch) --------
(sdegeo:define-contact "drain"
  (list
    (position xd1  0       0)
    (position xd1  Rch     0)
    (position xd1  0       Rch)
    (position xd1 (- Rch)  0)
    (position xd1  0     (- Rch))
  ))

; -------- GATE CONTACT (rectangular strip on outer silicon) --------
(sdegeo:define-contact "gate"
  (list
    (position xs0 Rgate (- Rgate))
    (position xd1 Rgate (- Rgate))
    (position xd1 Rgate   Rgate)
    (position xs0 Rgate   Rgate)
  ))

; ============================================================
; DOPING PROFILES
; ============================================================

; Channel ND = 1e17
(sdedr:define-constant-profile "ND_Channel"
        "PhosphorusActiveConcentration" 1e17)
(sdedr:define-constant-profile-region "PlaceND_Ch"
        "ND_Channel" "Channel")

; Source ND = 1e19
(sdedr:define-constant-profile "ND_Source"
        "PhosphorusActiveConcentration" 1e19)
(sdedr:define-constant-profile-region "PlaceND_S"
        "ND_Source" "source")

; Drain ND = 1e19
(sdedr:define-constant-profile "ND_Drain"
        "PhosphorusActiveConcentration" 1e19)
(sdedr:define-constant-profile-region "PlaceND_D"
        "ND_Drain" "drain")

; Gate p+ = 5e18
(sdedr:define-constant-profile "NA_Gate"
        "BoronActiveConcentration" 5e18)
(sdedr:define-constant-profile-region "PlaceNA_G"
        "NA_Gate" "gate")

; ============================================================
; MESH REFINEMENT
; ============================================================

(sdedr:define-refinement-size "RefAll"
    0.01 0.01
    0.01 0.01
    0.01 0.01)

(sdedr:define-refinement-placement "RefCh"   "RefAll" (list "region" "Channel"))
(sdedr:define-refinement-placement "RefSrc"  "RefAll" (list "region" "source"))
(sdedr:define-refinement-placement "RefDr"   "RefAll" (list "region" "drain"))
(sdedr:define-refinement-placement "RefGate" "RefAll" (list "region" "gate"))
(sdedr:define-refinement-placement "RefGox"  "RefAll" (list "region" "GateOxide"))

; ============================================================
; WRITE MESH
; ============================================================

(sde:save-model "sdemodel")
(sde:build-mesh "sdemodel_msh")
