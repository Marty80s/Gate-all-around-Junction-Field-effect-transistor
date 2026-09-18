; ================================
;  Gate-All-Around JFET geometry (NO OXIDE, NO DOPING HERE)
;  Sentaurus Structure Editor (Scheme)
;  Units: micrometers (µm)
; ================================

(sde:clear)

; --------- Parameters ----------
(define Rch    0.02)
(define tgate  0.01)

(define Lch    0.10)
(define Lsd    0.05)

; Positions
(define xs0 0.0)
(define xs1 Lsd)
(define xc0 xs1)
(define xc1 (+ xc0 Lch))
(define xd0 xc1)
(define xd1 (+ xd0 Lsd))

; Gate radius
(define Rgate (+ Rch tgate))

; ============================
; 1. Gate region
; ============================
(sdegeo:create-cylinder
  (position xs0 0 0)
  (position xd1 0 0)
  Rgate
  "Silicon"
  "Gate")

; ============================
; 2. Channel
; ============================
(sdegeo:create-cylinder
  (position xs0 0 0)
  (position xd1 0 0)
  Rch
  "Silicon"
  "Channel")

; ============================
; 3. Source
; ============================
(sdegeo:create-cylinder
  (position xs0 0 0)
  (position xs1 0 0)
  Rch
  "Silicon"
  "Source")

; ============================
; 4. Drain
; ============================
(sdegeo:create-cylinder
  (position xd0 0 0)
  (position xd1 0 0)
  Rch
  "Silicon"
  "Drain")

; ============================
; 5. Gas background
; ============================
(define pad 0.05)
(define xbox0 (- xs0 pad))
(define xbox1 (+ xd1 pad))
(define ybox0 (- Rgate pad))
(define ybox1 (+ Rgate pad))
(define zbox0 (- Rgate pad))
(define zbox1 (+ Rgate pad))

(sdegeo:create-cuboid
  (position xbox0 ybox0 zbox0)
  (position xbox1 ybox1 zbox1)
  "Gas"
  "Box")

; ============================
; 6. CONTACTS (these work)
; ============================

; Source
(sdegeo:define-contact-set "SourceContact" "Source")
(sdegeo:define-contact
  "SourceContact"
  (list
    (position xs0 (- Rgate) (- Rgate))
    (position xs0 Rgate      (- Rgate))
    (position xs0 Rgate       Rgate)
    (position xs0 (- Rgate)   Rgate)
  )
)

; Drain
(sdegeo:define-contact-set "DrainContact" "Drain")
(sdegeo:define-contact
  "DrainContact"
  (list
    (position xd1 (- Rgate) (- Rgate))
    (position xd1 Rgate      (- Rgate))
    (position xd1 Rgate       Rgate)
    (position xd1 (- Rgate)   Rgate)
  )
)

; Gate
(sdegeo:define-contact-set "GateContact" "Gate")
(sdegeo:define-contact
  "GateContact"
  (list
    (position xs0 Rgate (- Rgate))
    (position xd1 Rgate (- Rgate))
    (position xd1 Rgate  Rgate)
    (position xs0 Rgate  Rgate)
  )
)

; ============================
; 7. BUILD + EXPORT
; ============================
(sde:build-mesh)
(sde:save-model "gaajfet_msh")
