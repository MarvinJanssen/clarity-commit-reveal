
(define-constant TapLeaf 0x5461704c656166)
(define-constant TapTweak 0x546170547765616b)

(define-constant default-version u192)
(define-constant last-byte-consensus-uint-pos u17)

(define-read-only (get-tapscript-scriptpubkey (compressed-pubkey (buff 33)) (version (buff 1)) (script (buff 128)))
  (concat 0x5120 (get-tapscript-tweak compressed-pubkey version script)))

(define-read-only (get-tapscript-tweak (compressed-pubkey (buff 33)) (version (buff 1)) (script (buff 128)))
  (let (
    (x-only-pubkey (x-only compressed-pubkey))
    (tapleaf (get-tap-leaf (unwrap-panic (as-max-len? (concat version script) u128))))
    (tap-tweak (get-tap-tweak (unwrap-panic (as-max-len? (concat x-only-pubkey tapleaf) u128))))
    ;; tweaked key should include PARITY so it's a compressed pubkey
    (tweaked-point (tweak-pubkey-hex tap-tweak compressed-pubkey))
    (tweaked-key (point-to-compressed-pubkey tweaked-point)))
    (x-only tweaked-key)))

(define-read-only (point-to-compressed-pubkey (point (tuple (x (tuple (i0 uint) (i1 uint) (i2 uint) (i3 uint))) (y (tuple (i0 uint) (i1 uint) (i2 uint) (i3 uint))))))
  (let (
    (x-only (uint256-to-hex (get x point)))
    (y-parity (if (> (bit-and (get i3 (get y point)) u1) u0) 0x03 0x02)))
    (concat y-parity x-only))
)

(define-read-only (tweak-pubkey-hex (taptweak (buff 32)) (compressed-pubkey (buff 33)))
  (tweak-pubkey (hex-to-uint256 taptweak) (from-compressed compressed-pubkey)))

(define-read-only (tweak-pubkey
  (tweak (tuple (i0 uint) (i1 uint) (i2 uint) (i3 uint)))
  (pubkey (tuple (x (tuple (i0 uint) (i1 uint) (i2 uint) (i3 uint))) (y (tuple (i0 uint) (i1 uint) (i2 uint) (i3 uint))))))
  (let ((tweak-point (get result (txG tweak))))
    (unwrap-panic (ecc-add tweak-point pubkey)))
)

(define-read-only (x-only (pubkey (buff 33)))
  (unwrap-panic (as-max-len? (unwrap-panic (slice? pubkey u1 u33)) u32))
)

(define-read-only (read-parity-bit (pubkey (buff 33)))
  (unwrap-panic (as-max-len? (unwrap-panic (slice? pubkey u0 u1)) u1))
)

(define-read-only (get-control-bit (version (buff 1)) (parity-bit (buff 1)))
  (if (is-eq parity-bit 0x02)
    version
    (hex-add-byte version u1))
)

(define-read-only (hex-add-byte (byte (buff 1)) (a uint))
  (unwrap-panic (slice? (unwrap-panic (to-consensus-buff? (+ (buff-to-uint-be byte) a))) (- last-byte-consensus-uint-pos u1) last-byte-consensus-uint-pos))
)

(define-read-only (get-tap-leaf (data (buff 128)))
  (tagged-hash TapLeaf data)
)

(define-read-only (get-tap-tweak (data (buff 128)))
  (tagged-hash TapTweak data)
)

(define-read-only (tagged-hash (tag (buff 32)) (m (buff 1024)))
  (sha256 (concat (concat (sha256 tag) (sha256 tag)) m))
)

;; contract-call? Wrappers
(define-read-only (hex-to-uint256 (hex (buff 32)))
  (unwrap-panic (contract-call? .uint256-lib hex-to-uint256 hex)))

(define-read-only (uint256-to-hex (a (tuple (i0 uint) (i1 uint) (i2 uint) (i3 uint))))
  (unwrap-panic (contract-call? .uint256-lib uint256-to-hex a)))

(define-read-only (from-compressed (compressed-pubkey (buff 33)))
  (contract-call? .point from-compressed compressed-pubkey))

(define-read-only (ecc-add (p1 (tuple (x (tuple (i0 uint) (i1 uint) (i2 uint) (i3 uint))) (y (tuple (i0 uint) (i1 uint) (i2 uint) (i3 uint)))))
                        (p2 (tuple (x (tuple (i0 uint) (i1 uint) (i2 uint) (i3 uint))) (y (tuple (i0 uint) (i1 uint) (i2 uint) (i3 uint))))))
  (contract-call? .point ecc-add p1 p2))

(define-read-only (txG
  (scalar (tuple (i0 uint) (i1 uint) (i2 uint) (i3 uint))))
  (contract-call? .point txG scalar))
