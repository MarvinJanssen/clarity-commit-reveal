;; P = 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffefffffc2f
(define-constant p-uint256 (tuple (i0 u18446744073709551615) (i1 u18446744073709551615) (i2 u18446744073709551615) (i3 u18446744069414583343)))
(define-constant p-uint512 (tuple (i0 u0) (i1 u0) (i2 u0) (i3 u0) (i4 u18446744073709551615) (i5 u18446744073709551615) (i6 u18446744073709551615) (i7 u18446744069414583343)))
(define-constant iter-uint-256
  (list u255 u254 u253 u252 u251 u250 u249 u248 u247 u246 u245 u244 u243 u242 u241 u240 u239 u238 u237 u236 u235 u234 u233 u232 u231 u230 u229 u228 u227 u226 u225 u224 u223 u222 u221 u220 u219 u218 u217 u216 u215 u214 u213 u212 u211 u210 u209 u208 u207 u206 u205 u204 u203 u202 u201 u200 u199 u198 u197 u196 u195 u194 u193 u192 u191 u190 u189 u188 u187 u186 u185 u184 u183 u182 u181 u180 u179 u178 u177 u176 u175 u174 u173 u172 u171 u170 u169 u168 u167 u166 u165 u164 u163 u162 u161 u160 u159 u158 u157 u156 u155 u154 u153 u152 u151 u150 u149 u148 u147 u146 u145 u144 u143 u142 u141 u140 u139 u138 u137 u136 u135 u134 u133 u132 u131 u130 u129 u128 u127 u126 u125 u124 u123 u122 u121 u120 u119 u118 u117 u116 u115 u114 u113 u112 u111 u110 u109 u108 u107 u106 u105 u104 u103 u102 u101 u100 u99 u98 u97 u96 u95 u94 u93 u92 u91 u90 u89 u88 u87 u86 u85 u84 u83 u82 u81 u80 u79 u78 u77 u76 u75 u74 u73 u72 u71 u70 u69 u68 u67 u66 u65 u64 u63 u62 u61 u60 u59 u58 u57 u56 u55 u54 u53 u52 u51 u50 u49 u48 u47 u46 u45 u44 u43 u42 u41 u40 u39 u38 u37 u36 u35 u34 u33 u32 u31 u30 u29 u28 u27 u26 u25 u24 u23 u22 u21 u20 u19 u18 u17 u16 u15 u14 u13 u12 u11 u10 u9 u8 u7 u6 u5 u4 u3 u2 u1 u0))

(define-constant uint256-zero   (tuple (i0 u0) (i1 u0) (i2 u0) (i3 u0)))
(define-constant uint256-one    (tuple (i0 u0) (i1 u0) (i2 u0) (i3 u1)))
(define-constant uint256-four   (tuple (i0 u0) (i1 u0) (i2 u0) (i3 u4)))
(define-constant uint256-seven  (tuple (i0 u0) (i1 u0) (i2 u0) (i3 u7)))

;; for secp256k1
;; Gx = 55066263022277343669578718895168534326250603453777594175500187360389116729240 (0x79BE667EF9DCBBAC55A06295CE870B07029BFCDB2DCE28D959F2815B16F81798)
;; Gy = 32670510020758816978083085130507043184471273380659243275938904335757337482424 (0x483ADA7726A3C4655DA4FBFC0E1108A8FD17B448A68554199C47D08FFB10D4B8)
(define-constant Gx (tuple (i0 u8772561819708210092) (i1 u6170039885052185351) (i2 u188021827762530521) (i3 u6481385041966929816)))
(define-constant Gy (tuple (i0 u5204712524664259685) (i1 u6747795201694173352) (i2 u18237243440184513561) (i3 u11261198710074299576)))

(define-read-only (is-zero-point
  (p (tuple (x (tuple (i0 uint) (i1 uint) (i2 uint) (i3 uint))) (y (tuple (i0 uint) (i1 uint) (i2 uint) (i3 uint))))))
  (and
    (uint256-is-zero (get x p))
    (uint256-is-zero (get y p)))
)

(define-private (square-and-multiply-iter
  (s uint)
  (acc (tuple
    (base (tuple (i0 uint) (i1 uint) (i2 uint) (i3 uint)))
    (exponent (tuple (i0 uint) (i1 uint) (i2 uint) (i3 uint)))
    (result (tuple (i0 uint) (i1 uint) (i2 uint) (i3 uint)))
    (modulus (tuple (i0 uint) (i1 uint) (i2 uint) (i3 uint))))))
  (let (
    (base (get base acc))
    (exponent (get exponent acc))
    (modulus (get modulus acc))
    (result (uint512-mod
      (uint256-mul (get result acc) (get result acc))
      (tuple (i0 u0) (i1 u0) (i2 u0) (i3 u0) (i4 (get i0 modulus)) (i5 (get i1 modulus)) (i6 (get i2 modulus)) (i7 (get i3 modulus))))))
    (if (> (uint256-check-bit exponent s) u0)
      (let (
        (mod-result
          (uint512-mod
            (uint256-mul
              result
              base)
            (tuple (i0 u0) (i1 u0) (i2 u0) (i3 u0) (i4 (get i0 modulus)) (i5 (get i1 modulus)) (i6 (get i2 modulus)) (i7 (get i3 modulus))))))
        {
          base: base,
          exponent: exponent,
          result: mod-result,
          modulus: modulus,
        })
      {
        base: base,
        exponent: exponent,
        result: result,
        modulus: modulus,
      })))

(define-read-only (square-and-multiply
  (base (tuple (i0 uint) (i1 uint) (i2 uint) (i3 uint)))
  (exponent (tuple (i0 uint) (i1 uint) (i2 uint) (i3 uint)))
  (modulus (tuple (i0 uint) (i1 uint) (i2 uint) (i3 uint))))
  (let (
    ;; if base >= modulus
    (base-mod (if (uint256> base p-uint256) (uint256-mod base p-uint256) base)))
    (get result (fold square-and-multiply-iter iter-uint-256
      {
        base: base-mod,
        exponent: exponent,
        result: uint256-one,
        modulus: modulus
      }))))

;; modulo square root, only works if p is prime
(define-read-only (mod-sqrt
  (base (tuple (i0 uint) (i1 uint) (i2 uint) (i3 uint)))
  (p (tuple (i0 uint) (i1 uint) (i2 uint) (i3 uint))))
  (let ((exponent (uint256-div (uint256-add p uint256-one) uint256-four)))
    (square-and-multiply base exponent p-uint256)))

(define-read-only (get-slope
  (p1 (tuple (x (tuple (i0 uint) (i1 uint) (i2 uint) (i3 uint))) (y (tuple (i0 uint) (i1 uint) (i2 uint) (i3 uint)))))
  (p2 (tuple (x (tuple (i0 uint) (i1 uint) (i2 uint) (i3 uint))) (y (tuple (i0 uint) (i1 uint) (i2 uint) (i3 uint))))))
  (let (
    (y1 (get y p1))
    (y2 (get y p2))
    (x1 (get x p1))
    (x2 (get x p2))
    (y2-y1 (uint256-sub-mod y2 y1))
    (x2-x1 (uint256-sub-mod x2 x1))
    (x2-x1**minus1
      (square-and-multiply
        x2-x1
        (uint256-sub
          p-uint256
          (tuple (i0 u0) (i1 u0) (i2 u0) (i3 u2)))
        p-uint256))
    (slope (uint512-mod (uint256-mul y2-y1 x2-x1**minus1) p-uint512)))
    slope))

(define-read-only (get-tangent-slope
  (p1 (tuple (x (tuple (i0 uint) (i1 uint) (i2 uint) (i3 uint))) (y (tuple (i0 uint) (i1 uint) (i2 uint) (i3 uint))))))
  (let (
    (num
      (uint512-mod
        (uint256-mul
          (uint512-mod (uint256-mul (get x p1) (get x p1)) p-uint512)
          (tuple (i0 u0) (i1 u0) (i2 u0) (i3 u3)))
        p-uint512))
    (den 
      (square-and-multiply
        (uint512-mod
          (uint256-mul
            (get y p1)
            (tuple (i0 u0) (i1 u0) (i2 u0) (i3 u2)))
          p-uint512)
        (uint256-sub
          p-uint256
          (tuple (i0 u0) (i1 u0) (i2 u0) (i3 u2)))
        p-uint256)))
    (uint512-mod (uint256-mul num den) p-uint512)))

(define-read-only (point-add
  (p1 (tuple (x (tuple (i0 uint) (i1 uint) (i2 uint) (i3 uint))) (y (tuple (i0 uint) (i1 uint) (i2 uint) (i3 uint)))))
  (p2 (tuple (x (tuple (i0 uint) (i1 uint) (i2 uint) (i3 uint))) (y (tuple (i0 uint) (i1 uint) (i2 uint) (i3 uint)))))
  (slope (tuple (i0 uint) (i1 uint) (i2 uint) (i3 uint))))
  (let (
    (x1 (get x p1))
    (x2 (get x p2))
    (y1 (get y p1))
    (y2 (get y p2))
    (slope_2 (uint512-mod (uint256-mul slope slope) p-uint512))
    (x3 (uint256-sub-mod (uint256-sub-mod slope_2 x1) x2))
    (m_x1-x3 (uint512-mod (uint256-mul slope (uint256-sub-mod x1 x3)) p-uint512))
    (y3 (uint256-mod (uint256-sub-mod m_x1-x3 y1) p-uint256)))
    { x: x3, y: y3 }))

(define-read-only (ecc-add
  (p1 (tuple (x (tuple (i0 uint) (i1 uint) (i2 uint) (i3 uint))) (y (tuple (i0 uint) (i1 uint) (i2 uint) (i3 uint)))))
  (p2 (tuple (x (tuple (i0 uint) (i1 uint) (i2 uint) (i3 uint))) (y (tuple (i0 uint) (i1 uint) (i2 uint) (i3 uint))))))
  (if (is-zero-point p1)
    (ok p2)
    (if (is-zero-point p2)
      (ok p1)
      (if (and (uint256-is-eq (get x p1) (get x p2)) (uint256-is-eq (get y p1) (get y p2)))
        (if (uint256-is-zero (get y p1))
          (ok (tuple (x uint256-zero) (y uint256-zero)))
          (ok (point-add p1 p2 (get-tangent-slope p1))))
        (if (uint256-is-eq (get x p1) (get x p2))
          (ok (tuple (x uint256-zero) (y uint256-zero)))
          (ok (point-add p1 p2 (get-slope p1 p2))))))))


(define-read-only (double-and-add
  (i uint)
  (acc (tuple
    (result (tuple (x (tuple (i0 uint) (i1 uint) (i2 uint) (i3 uint))) (y (tuple (i0 uint) (i1 uint) (i2 uint) (i3 uint)))))
    (point (tuple (x (tuple (i0 uint) (i1 uint) (i2 uint) (i3 uint))) (y (tuple (i0 uint) (i1 uint) (i2 uint) (i3 uint)))))
    (scalar (tuple (i0 uint) (i1 uint) (i2 uint) (i3 uint)))
    (count uint)
    (double_rs (list 256 (tuple (x (buff 32)) (y (buff 32)))))
    (add (list 256 (tuple (x (buff 32)) (y (buff 32))))))))
  (let (
    (double_r (unwrap-panic (ecc-add (get result acc) (get result acc)))))
    (if (> (uint256-check-bit (get scalar acc) i) u0)
      (let (
        (last-add (unwrap-panic (ecc-add double_r (get point acc)))))
        {
          result: last-add,
          point: (get point acc),
          scalar: (get scalar acc),
          count: (+ u1 (get count acc)),
          double_rs: (unwrap-panic (as-max-len? (append (get double_rs acc) (tuple (x (uint256-to-hex (get x double_r))) (y (uint256-to-hex (get y double_r))) )) u256)),
          add: (unwrap-panic (as-max-len? (append (get add acc) (tuple (x (uint256-to-hex (get x last-add))) (y (uint256-to-hex (get y last-add))) )) u256))
        })
      {
        result: double_r,
        point: (get point acc),
        scalar: (get scalar acc),
        count: (get count acc),
        double_rs: (unwrap-panic (as-max-len? (append (get double_rs acc) (tuple (x (uint256-to-hex (get x double_r))) (y (uint256-to-hex (get y double_r))) )) u256)),
        add: (unwrap-panic (as-max-len? (append (get  add acc) (tuple (x (uint256-to-hex (get x double_r))) (y (uint256-to-hex (get y double_r))) )) u256)),
      })))

;; scalar x point
(define-read-only (scalar-mul
  (scalar (tuple (i0 uint) (i1 uint) (i2 uint) (i3 uint)))
  (a (tuple (x (tuple (i0 uint) (i1 uint) (i2 uint) (i3 uint))) (y (tuple (i0 uint) (i1 uint) (i2 uint) (i3 uint))))) )
  (fold double-and-add iter-uint-256 {
    result: (tuple (x uint256-zero) (y uint256-zero)),
    point: a,
    scalar: scalar,
    count: u0,
    double_rs: (list),
    add: (list)
    }))

;; scalar x Base point
(define-read-only (txG
  (scalar (tuple (i0 uint) (i1 uint) (i2 uint) (i3 uint))))
  (fold double-and-add iter-uint-256 {
    result: (tuple (x uint256-zero) (y uint256-zero)),
    point: (tuple (x Gx) (y Gy)),
    scalar: scalar,
    count: u0,
    double_rs: (list),
    add: (list)
    }))

;; 0x02, even
;; 0x03, odd
(define-read-only (get-y-from-xpubkey
  (even bool)
  (x (tuple (i0 uint) (i1 uint) (i2 uint) (i3 uint))))
  (let (
    (x_3 (uint512-mod (uint256-mul (uint512-mod (uint256-mul x x) p-uint512) x) p-uint512))
    (x_3_plus_7 (uint256-mod (uint256-add x_3 uint256-seven) p-uint256))
    (x_3_plus_7_mod_p (uint256-mod x_3_plus_7 p-uint256))
    (y (mod-sqrt x_3_plus_7_mod_p p-uint256)))
    (if (and even (not (> (mod (get i3 y) u2) u0)))
      y
      (uint256-sub p-uint256 y))))

(define-read-only (get-y-from-x-only
  (x (tuple (i0 uint) (i1 uint) (i2 uint) (i3 uint))))
  (let (
    (x_3 (uint512-mod (uint256-mul (uint512-mod (uint256-mul x x) p-uint512) x) p-uint512))
    (x_3_plus_7 (uint256-mod (uint256-add x_3 uint256-seven) p-uint256))
    (x_3_plus_7_mod_p (uint256-mod x_3_plus_7 p-uint256))
    (y (mod-sqrt x_3_plus_7_mod_p p-uint256)))
    (if (> (mod (get i3 y) u2) u0)
      (uint256-sub p-uint256 y)
      y)))

(define-read-only (get-y-from-compressed-pubkey (compressed-pubkey (buff 33)))
  (let  (
    (even (if (is-eq 0x02 (unwrap-panic (slice? compressed-pubkey u0 u1))) true false))
    (x (hex-to-uint256 (unwrap-panic (as-max-len? (unwrap-panic (slice? compressed-pubkey u1 u33)) u32)))))
    (get-y-from-xpubkey even x)))

(define-read-only (from-compressed (compressed-pubkey (buff 33)))
  {
    x: (hex-to-uint256 (unwrap-panic (as-max-len? (unwrap-panic (slice? compressed-pubkey u1 u33)) u32))),
    y: (get-y-from-compressed-pubkey compressed-pubkey)
  })

;; contract-call Wrappers
(define-read-only (uint512-mod
  (a (tuple (i0 uint) (i1 uint) (i2 uint) (i3 uint) (i4 uint) (i5 uint) (i6 uint) (i7 uint)))
  (b (tuple (i0 uint) (i1 uint) (i2 uint) (i3 uint) (i4 uint) (i5 uint) (i6 uint) (i7 uint))))
  (let (
    (result (unwrap-panic (contract-call? .uint512-lib uint512-mod a b))))
    {
      i0: (get i4 result),
      i1: (get i5 result),
      i2: (get i6 result),
      i3: (get i7 result),
    }))

(define-read-only (hex-to-uint256 (hex (buff 32)))
  (unwrap-panic (contract-call? .uint256-lib hex-to-uint256 hex)))

(define-read-only (uint256-to-hex
  (a (tuple (i0 uint) (i1 uint) (i2 uint) (i3 uint))))
  (unwrap-panic (contract-call? .uint256-lib uint256-to-hex a)))

(define-read-only (uint256-is-eq
  (a (tuple (i0 uint) (i1 uint) (i2 uint) (i3 uint)))
  (b (tuple (i0 uint) (i1 uint) (i2 uint) (i3 uint))))
  (unwrap-panic (contract-call? .uint256-lib uint256-is-eq a b)))

(define-read-only (uint256>
  (a (tuple (i0 uint) (i1 uint) (i2 uint) (i3 uint)))
  (b (tuple (i0 uint) (i1 uint) (i2 uint) (i3 uint))))
  (unwrap-panic (contract-call? .uint256-lib uint256> a b)))

(define-read-only (uint256<
  (a (tuple (i0 uint) (i1 uint) (i2 uint) (i3 uint)))
  (b (tuple (i0 uint) (i1 uint) (i2 uint) (i3 uint))))
  (unwrap-panic (contract-call? .uint256-lib uint256< a b)))

(define-read-only (uint256-is-zero
  (a (tuple (i0 uint) (i1 uint) (i2 uint) (i3 uint))))
  (unwrap-panic (contract-call? .uint256-lib uint256-is-zero a)))

(define-read-only (uint256-div
  (a (tuple (i0 uint) (i1 uint) (i2 uint) (i3 uint)))
  (b (tuple (i0 uint) (i1 uint) (i2 uint) (i3 uint)))) 
  (unwrap-panic (contract-call? .uint256-lib uint256-div a b)))

(define-read-only (uint256-mul-short
  (a (tuple (i0 uint) (i1 uint) (i2 uint) (i3 uint)))
  (b uint))
  (unwrap-panic (contract-call? .uint256-lib uint256-mul-short a b)))

(define-read-only (uint256-mul
  (a (tuple (i0 uint) (i1 uint) (i2 uint) (i3 uint)))
  (b (tuple (i0 uint) (i1 uint) (i2 uint) (i3 uint))))
  (unwrap-panic (contract-call? .uint256-lib uint256-mul a b)))

(define-read-only (uint256-add
  (a (tuple (i0 uint) (i1 uint) (i2 uint) (i3 uint)))
  (b (tuple (i0 uint) (i1 uint) (i2 uint) (i3 uint))))
  (unwrap-panic (contract-call? .uint256-lib uint256-add a b)))

(define-read-only (uint256-mod
  (a (tuple (i0 uint) (i1 uint) (i2 uint) (i3 uint)))
  (b (tuple (i0 uint) (i1 uint) (i2 uint) (i3 uint))))
  (unwrap-panic (contract-call? .uint256-lib uint256-mod a b)))

(define-read-only (uint256-sub
  (a (tuple (i0 uint) (i1 uint) (i2 uint) (i3 uint)))
  (b (tuple (i0 uint) (i1 uint) (i2 uint) (i3 uint))))
  (unwrap-panic (contract-call? .uint256-lib uint256-sub a b)))

(define-read-only (uint256-sub-mod
  (a (tuple (i0 uint) (i1 uint) (i2 uint) (i3 uint)))
  (b (tuple (i0 uint) (i1 uint) (i2 uint) (i3 uint))))
  (unwrap-panic (contract-call? .uint256-lib uint256-sub-mod a b p-uint256)))

(define-read-only (uint512-to-hex
  (a (tuple (i0 uint) (i1 uint) (i2 uint) (i3 uint) (i4 uint) (i5 uint) (i6 uint) (i7 uint))))
  (unwrap-panic (contract-call? .uint512-lib uint512-to-hex a)))

(define-read-only (uint512-to-uint256-overflow
  (a (tuple (i0 uint) (i1 uint) (i2 uint) (i3 uint) (i4 uint) (i5 uint) (i6 uint) (i7 uint))))
  (unwrap-panic (contract-call? .uint512-lib uint512-to-uint256-overflow a)))

(define-read-only (uint256-check-bit
  (a (tuple (i0 uint) (i1 uint) (i2 uint) (i3 uint))) (b uint))
  (unwrap-panic (contract-call? .uint256-lib uint256-check-bit a b)))
