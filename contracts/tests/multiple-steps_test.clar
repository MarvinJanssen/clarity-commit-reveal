(define-constant iter-uint-256-test
  (list
  ;; u255 u254 u253 u252 u251 u250 u249 u248 u247 u246 u245 u244 u243 u242 u241 u240 u239 u238 u237 u236 u235 u234 u233 u232 u231 u230 u229 u228 u227 u226 u225 u224 u223 u222 u221 u220 u219 u218 u217 u216 u215 u214 u213 u212 u211 u210 u209 u208 u207 u206 u205 u204 u203 u202 u201 u200 u199 u198 u197 u196 u195 u194 u193 u192 u191 u190 u189 u188 u187 u186 u185 u184 u183 u182 u181 u180 u179 u178 u177 u176 u175 u174 u173 u172 u171 u170 u169 u168 u167 u166 u165 u164 u163 u162 u161 u160 u159 u158 u157 u156 u155 u154 u153 u152 u151 u150 u149 u148 u147 u146 u145 u144 u143 u142 u141 u140 u139 u138 u137 u136 u135 u134 u133 u132 u131 u130 u129 u128 u127 u126 u125 u124 u123 u122 u121
  ;;  u120 u119 u118 u117 u116 u115 u114 u113 u112 u111 u110 u109 u108 u107 u106 u105 u104 u103 u102 u101 u100 u99 u98 u97 u96 u95 u94 u93 u92 u91 u90 u89 u88 u87 u86 u85 u84 u83 u82 u81 u80 u79 u78 u77 u76 u75 u74 u73 u72 u71 u70 u69 u68 u67 u66 u65 u64 u63 u62 u61 u60 u59 u58 u57 u56 u55 u54 u53 u52 u51 u50 u49 u48 u47 u46 u45 u44 u43 u42 u41 u40 u39 u38 u37 u36 u35 u34 u33 u32
  ;;  u31 u30 u29 u28 u27 u26 u25 u24 u23 u22 u21 u20 u19 u18 u17 u16
    u15 u14 u13 u12 u11 u10 u9 u8 u7 u6 u5 u4 u3 u2 u1 u0
   ))

(define-constant uint256-zero (tuple (i0 u0) (i1 u0) (i2 u0) (i3 u0)))
(define-constant uint256-one (tuple (i0 u0) (i1 u0) (i2 u0) (i3 u1)))
(define-constant uint256-four (tuple (i0 u0) (i1 u0) (i2 u0) (i3 u4)))
(define-constant uint256-seven (tuple (i0 u0) (i1 u0) (i2 u0) (i3 u7)))
(define-constant uint768-seven (tuple (i0 u0) (i1 u0) (i2 u0) (i3 u0) (i4 u0) (i5 u0) (i6 u0) (i7 u0) (i8 u0) (i9 u0) (i10 u0) (i11 u7)))

;; for secp256k1

;; Gx = 55066263022277343669578718895168534326250603453777594175500187360389116729240 (0x79BE667EF9DCBBAC55A06295CE870B07029BFCDB2DCE28D959F2815B16F81798)
;; Gy = 32670510020758816978083085130507043184471273380659243275938904335757337482424 (0x483ADA7726A3C4655DA4FBFC0E1108A8FD17B448A68554199C47D08FFB10D4B8)
(define-constant Gx (tuple (i0 u8772561819708210092) (i1 u6170039885052185351) (i2 u188021827762530521) (i3 u6481385041966929816)))
(define-constant Gy (tuple (i0 u5204712524664259685) (i1 u6747795201694173352) (i2 u18237243440184513561) (i3 u11261198710074299576)))

(define-read-only (loop-bits-256-steps
    (i uint)
    (acc 
      (tuple
        (result (tuple (x (tuple (i0 uint) (i1 uint) (i2 uint) (i3 uint))) (y (tuple (i0 uint) (i1 uint) (i2 uint) (i3 uint)))))
        (point (tuple (x (tuple (i0 uint) (i1 uint) (i2 uint) (i3 uint))) (y (tuple (i0 uint) (i1 uint) (i2 uint) (i3 uint)))))
        (scalar (tuple (i0 uint) (i1 uint) (i2 uint) (i3 uint)))
        (pos uint)
        (double_rs (list 257 (tuple (x (buff 32)) (y (buff 32)))))
        (add (list 257 (tuple (x (buff 32)) (y (buff 32)))))
      )
    )
  )
    (let (
      (double_r (unwrap-panic (contract-call? .point ecc-add (get result acc) (get result acc))))
    )
      (if (> (contract-call? .point uint256-check-bit (get scalar acc) (- u255 (get pos acc))) u0)
        (let (
          (last-add (unwrap-panic (contract-call? .point ecc-add double_r (get point acc))))
        )
          {
            result: last-add,
            point: (get point acc),
            scalar: (get scalar acc),
            pos: (+ (get pos acc) u1),
            double_rs: (unwrap-panic (as-max-len? (append (get double_rs acc) (tuple (x (contract-call? .point uint256-to-hex (get x double_r))) (y (contract-call? .point uint256-to-hex (get y double_r))) )) u257)),
            add: (unwrap-panic (as-max-len? (append (get add acc) (tuple (x (contract-call? .point uint256-to-hex (get x last-add))) (y (contract-call? .point uint256-to-hex (get y last-add))) )) u257))
          }
        )
        {
          result: double_r,
          point: (get point acc),
          scalar: (get scalar acc),
          pos: (+ (get pos acc) u1),
          double_rs: (unwrap-panic (as-max-len? (append (get double_rs acc) (tuple (x (contract-call? .point uint256-to-hex (get x double_r))) (y (contract-call? .point uint256-to-hex (get y double_r))) )) u257)),
          add: (unwrap-panic (as-max-len? (append (get  add acc) (tuple (x (contract-call? .point uint256-to-hex (get x double_r))) (y (contract-call? .point uint256-to-hex (get y double_r))) )) u257)),
        }
      )
    )
)

(define-read-only (txG-steps
  (result (tuple (x (tuple (i0 uint) (i1 uint) (i2 uint) (i3 uint))) (y (tuple (i0 uint) (i1 uint) (i2 uint) (i3 uint)))))
  (scalar (tuple (i0 uint) (i1 uint) (i2 uint) (i3 uint)))
  (pos uint)
  (double_rs (list 257 (tuple (x (buff 32)) (y (buff 32)))))
  (add (list 257 (tuple (x (buff 32)) (y (buff 32)))))
  )
  (fold loop-bits-256-steps iter-uint-256-test {
    result: result,
    point: (tuple (x Gx) (y Gy)),
    scalar: scalar,
    pos: pos,
    double_rs: double_rs,
    add: add
    })
)

(define-data-var result-temp
  (tuple (x (buff 32)) (y (buff 32)))
  (tuple
    (x (contract-call? .point uint256-to-hex uint256-zero))
    (y (contract-call? .point uint256-to-hex uint256-zero))))

(define-data-var scalar-temp
  (tuple (i0 uint) (i1 uint) (i2 uint) (i3 uint))
  uint256-zero
)

(define-data-var pos-temp uint u0)

(define-data-var double_rs-temp
  (list 257 (tuple (x (buff 32)) (y (buff 32))))
  (list))

(define-data-var add-temp
  (list 257 (tuple (x (buff 32)) (y (buff 32))))
  (list))

(define-public (test-txG-steps-a-1)
  (let (
    (scalar (contract-call? .point hex-to-uint256 0x1e409779582e92bb9bb50e4ac01f0f8bc73b79a678aabd5ae85eda180babc19c))
    (p-result 
      (txG-steps
        (tuple (x uint256-zero) (y uint256-zero))
        scalar
        u0
        (list)
        (list)
      ))
  )
    (var-set result-temp { x: (contract-call? .point uint256-to-hex (get x (get result p-result))), y: (contract-call? .point uint256-to-hex (get y (get result p-result)))})
    (var-set scalar-temp (get scalar p-result))
    (var-set pos-temp (get pos p-result))
    (var-set double_rs-temp (get double_rs p-result))
    (var-set add-temp (get add p-result))
    ;; (asserts! (is-eq (uint256-to-hex (get x p-result)) 0x6eadfbf6201a6845ad32c947b99c25aaff4c5ae61800c53928f0c88a70084b77) (err "problem!"))
    ;; (asserts! (is-eq (uint256-to-hex (get y p-result)) 0x88cc90fb2cd35d3dcd6f7d39b025ccaea1e58572b3b59f53ebc312e77c70ceb5) (err "problem!"))
    (ok {
        result-x: (contract-call? .point uint256-to-hex (get x (get result p-result))),
        result-y: (contract-call? .point uint256-to-hex (get y (get result p-result))),
        point-x: (contract-call? .point uint256-to-hex (get x (get point p-result))),
        point-y: (contract-call? .point uint256-to-hex (get y (get point p-result))),
        scalar: (contract-call? .point uint256-to-hex (get scalar p-result)),
        pos: (get pos p-result),
        DOUBLE_RS: (get double_rs p-result),
        ADDS: (get add p-result),
        })
  )
)

(define-public (test-txG-steps-a-2)
  (let (
    (p-result 
      (txG-steps
        { x: (contract-call? .point hex-to-uint256 (get x (var-get result-temp))), y: (contract-call? .point hex-to-uint256 (get y (var-get result-temp))) }
        (var-get scalar-temp)
        (var-get pos-temp)
        (var-get double_rs-temp)
        (var-get add-temp)
      ))
  )
    (var-set result-temp { x: (contract-call? .point uint256-to-hex (get x (get result p-result))), y: (contract-call? .point uint256-to-hex (get y (get result p-result)))})
    (var-set scalar-temp (get scalar p-result))
    (var-set pos-temp (get pos p-result))
    (var-set double_rs-temp (get double_rs p-result))
    (var-set add-temp (get add p-result))

    (ok {
        result-x: (contract-call? .point uint256-to-hex (get x (get result p-result))),
        result-y: (contract-call? .point uint256-to-hex (get y (get result p-result))),
        point-x: (contract-call? .point uint256-to-hex (get x (get point p-result))),
        point-y: (contract-call? .point uint256-to-hex (get y (get point p-result))),
        scalar: (contract-call? .point uint256-to-hex (get scalar p-result)),
        pos: (get pos p-result),
        DOUBLE_RS: (get double_rs p-result),
        ADDS: (get add p-result),
        })
  )
)