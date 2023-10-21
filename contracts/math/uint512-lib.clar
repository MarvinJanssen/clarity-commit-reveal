
(define-constant iter-buff-512 0x0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000)

(define-constant uint64-max u18446744073709551615)
(define-constant uint64-max-limit u18446744073709551616)

(define-constant uint512-zero (tuple (i0 u0) (i1 u0) (i2 u0) (i3 u0) (i4 u0) (i5 u0) (i6 u0) (i7 u0)))
(define-constant uint512-one (tuple (i0 u0) (i1 u0) (i2 u0) (i3 u0) (i4 u0) (i5 u0) (i6 u0) (i7 u1)))

(define-read-only (uint64-to-hex (a uint))
  (unwrap-panic (as-max-len? (unwrap-panic (slice? (unwrap-panic (to-consensus-buff? a)) u9 u17)) u8))
)

;; TODO: assert each val is < uint-64-max
(define-read-only (uint512-to-hex
  (a (tuple (i0 uint) (i1 uint) (i2 uint) (i3 uint) (i4 uint) (i5 uint)  (i6 uint)  (i7 uint) )))
  (ok
    (concat
    (concat
    (concat
    (concat
    (concat
    (concat
    (concat
      (uint64-to-hex (get i0 a))
      (uint64-to-hex (get i1 a)))
      (uint64-to-hex (get i2 a)))
      (uint64-to-hex (get i3 a)))
      (uint64-to-hex (get i4 a)))
      (uint64-to-hex (get i5 a)))
      (uint64-to-hex (get i6 a)))
      (uint64-to-hex (get i7 a)))))

(define-read-only (remainder-uint64 (a uint))
  (if (> (/ a uint64-max-limit) u0) (mod a uint64-max-limit) a))

(define-read-only (carry (a uint))
  (if (> a uint64-max) (/ a uint64-max-limit) u0))

(define-read-only (uint512-cmp
  (a (tuple (i0 uint) (i1 uint) (i2 uint) (i3 uint) (i4 uint) (i5 uint) (i6 uint) (i7 uint)))
  (b (tuple (i0 uint) (i1 uint) (i2 uint) (i3 uint) (i4 uint) (i5 uint) (i6 uint) (i7 uint))))
  (ok (if (is-eq (get i0 a) (get i0 b))
    (if (is-eq (get i1 a) (get i1 b))
        (if (is-eq (get i2 a) (get i2 b))
            (if (is-eq (get i3 a) (get i3 b))
                (if (is-eq (get i4 a) (get i4 b))
                    (if (is-eq (get i5 a) (get i5 b))
                        (if (is-eq (get i6 a) (get i6 b))
                            (if (is-eq (get i7 a) (get i7 b))
                                0
                                (if (> (get i7 a) (get i7 b)) 1 -1))
                            (if (> (get i6 a) (get i6 b)) 1 -1))
                        (if (> (get i5 a) (get i5 b)) 1 -1))
                    (if (> (get i4 a) (get i4 b)) 1 -1))
                (if (> (get i3 a) (get i3 b)) 1 -1))
            (if (> (get i2 a) (get i2 b)) 1 -1))
        (if (> (get i1 a) (get i1 b)) 1 -1))
      (if (> (get i0 a) (get i0 b)) 1 -1))))

(define-read-only (uint512-is-eq
  (a (tuple (i0 uint) (i1 uint) (i2 uint) (i3 uint) (i4 uint) (i5 uint) (i6 uint) (i7 uint)))
  (b (tuple (i0 uint) (i1 uint) (i2 uint) (i3 uint) (i4 uint) (i5 uint) (i6 uint) (i7 uint))))
  (ok (is-eq (unwrap-panic (uint512-cmp a b)) 0)))

(define-read-only (uint512>
  (a (tuple (i0 uint) (i1 uint) (i2 uint) (i3 uint) (i4 uint) (i5 uint) (i6 uint) (i7 uint)))
  (b (tuple (i0 uint) (i1 uint) (i2 uint) (i3 uint) (i4 uint) (i5 uint) (i6 uint) (i7 uint))))
  (ok (> (unwrap-panic (uint512-cmp a b)) 0)))

(define-read-only (uint512<
  (a (tuple (i0 uint) (i1 uint) (i2 uint) (i3 uint) (i4 uint) (i5 uint) (i6 uint) (i7 uint)))
  (b (tuple (i0 uint) (i1 uint) (i2 uint) (i3 uint) (i4 uint) (i5 uint) (i6 uint) (i7 uint))))
  (ok (< (unwrap-panic (uint512-cmp a b)) 0)))

(define-read-only (uint512-is-zero
  (a (tuple (i0 uint) (i1 uint) (i2 uint) (i3 uint) (i4 uint) (i5 uint) (i6 uint) (i7 uint))))
  (ok 
    (and
      (is-eq (get i0 a) u0)
      (is-eq (get i1 a) u0)
      (is-eq (get i2 a) u0)
      (is-eq (get i3 a) u0)
      (is-eq (get i4 a) u0)
      (is-eq (get i5 a) u0)
      (is-eq (get i6 a) u0)
      (is-eq (get i7 a) u0))))

(define-read-only (uint512-add
  (a (tuple (i0 uint) (i1 uint) (i2 uint) (i3 uint) (i4 uint) (i5 uint) (i6 uint) (i7 uint)))
  (b (tuple (i0 uint) (i1 uint) (i2 uint) (i3 uint) (i4 uint) (i5 uint) (i6 uint) (i7 uint))))
  (let ((i7 (+ (get i7 a) (get i7 b))))
  (let ((i6 (+ (get i6 a) (get i6 b) (carry i7)) ))
  (let ((i5 (+ (get i5 a) (get i5 b) (carry i6)) ))
  (let ((i4 (+ (get i4 a) (get i4 b) (carry i5)) ))
  (let ((i3 (+ (get i3 a) (get i3 b) (carry i4)) ))
  (let ((i2 (+ (get i2 a) (get i2 b) (carry i3)) ))
  (let ((i1 (+ (get i1 a) (get i1 b) (carry i2)) ))
  (let ((i0 (+ (get i0 a) (get i0 b) (carry i1)) ))
  (ok (tuple (i0 i0)
        (i1 (remainder-uint64 i1))
        (i2 (remainder-uint64 i2))
        (i3 (remainder-uint64 i3))
        (i4 (remainder-uint64 i4))
        (i5 (remainder-uint64 i5))
        (i6 (remainder-uint64 i6))
        (i7 (remainder-uint64 i7)))))))))))))

(define-read-only (uint512-sub
  (a (tuple (i0 uint) (i1 uint) (i2 uint) (i3 uint) (i4 uint) (i5 uint) (i6 uint) (i7 uint)))
  (b (tuple (i0 uint) (i1 uint) (i2 uint) (i3 uint) (i4 uint) (i5 uint) (i6 uint) (i7 uint))))
  (let ((i (if (unwrap-panic (uint512> a b)) a b)) (j (if (unwrap-panic (uint512> a b)) b a )))
  (let ((i7 (- (to-int (get i7 i)) (to-int (get i7 j)))))
  (let ((i6 (- (- (to-int (get i6 i)) (to-int (get i6 j))) (if (< i7 0) 1 0))))
  (let ((i5 (- (- (to-int (get i5 i)) (to-int (get i5 j))) (if (< i6 0) 1 0))))
  (let ((i4 (- (- (to-int (get i4 i)) (to-int (get i4 j))) (if (< i5 0) 1 0))))
  (let ((i3 (- (- (to-int (get i3 i)) (to-int (get i3 j))) (if (< i4 0) 1 0))))
  (let ((i2 (- (- (to-int (get i2 i)) (to-int (get i2 j))) (if (< i3 0) 1 0))))
  (let ((i1 (- (- (to-int (get i1 i)) (to-int (get i1 j))) (if (< i2 0) 1 0))))
  (let ((i0 (- (- (to-int (get i0 i)) (to-int (get i0 j))) (if (< i1 0) 1 0))))
    (ok (tuple (i0 (to-uint i0))
        (i1 (mod (to-uint (if (< i1 0) (+ (to-int uint64-max-limit) i1) i1)) uint64-max-limit)) 
        (i2 (mod (to-uint (if (< i2 0) (+ (to-int uint64-max-limit) i2) i2)) uint64-max-limit)) 
        (i3 (mod (to-uint (if (< i3 0) (+ (to-int uint64-max-limit) i3) i3)) uint64-max-limit)) 
        (i4 (mod (to-uint (if (< i4 0) (+ (to-int uint64-max-limit) i4) i4)) uint64-max-limit)) 
        (i5 (mod (to-uint (if (< i5 0) (+ (to-int uint64-max-limit) i5) i5)) uint64-max-limit)) 
        (i6 (mod (to-uint (if (< i6 0) (+ (to-int uint64-max-limit) i6) i6)) uint64-max-limit)) 
        (i7 (mod (to-uint (if (< i7 0) (+ (to-int uint64-max-limit) i7) i7)) uint64-max-limit))))))))))))))

(define-read-only (uint512-add-short
  (a (tuple (i0 uint) (i1 uint) (i2 uint) (i3 uint) (i4 uint) (i5 uint) (i6 uint) (i7 uint)))
  (b uint))
  (uint512-add
    a
    (tuple
      (i0 u0)
      (i1 u0)
      (i2 u0)
      (i3 u0)
      (i4 u0)
      (i5 u0)
      (i6 (/ b uint64-max-limit))
      (i7 (mod b uint64-max-limit)))))

(define-read-only (uint512-check-bit
  (a (tuple (i0 uint) (i1 uint) (i2 uint) (i3 uint) (i4 uint) (i5 uint) (i6 uint) (i7 uint)))
  (b uint))
  (if (> b u512) (err 1)
    (let ((v
      (if (is-eq (/ b u64) u7)
        (get i0 a)
        (if (is-eq (/ b u64) u6)
          (get i1 a)
          (if (is-eq (/ b u64) u5)
            (get i2 a)
            (if (is-eq (/ b u64) u4)
              (get i3 a)
              (if (is-eq (/ b u64) u3)
                (get i4 a)
                (if (is-eq (/ b u64) u2)
                  (get i5 a)
                  (if (is-eq (/ b u64) u1)
                    (get i6 a)
                    (get i7 a))))))))))
    (ok (bit-and (bit-shift-right v (mod b u64)) u1)))))

(define-read-only (uint512-rshift-overflow
  (a (tuple (i0 uint) (i1 uint) (i2 uint) (i3 uint) (i4 uint) (i5 uint) (i6 uint) (i7 uint)))
  (b uint))
  (if (< b u128)
    (begin
      (let ((i7 (bit-shift-left (get i7 a) b)))
      (let ((i6 (+ (bit-shift-left (get i6 a) b) (carry i7) )))
      (let ((i5 (+ (bit-shift-left (get i5 a) b) (carry i6) )))
      (let ((i4 (+ (bit-shift-left (get i4 a) b) (carry i5) )))
      (let ((i3 (+ (bit-shift-left (get i3 a) b) (carry i4) )))
      (let ((i2 (+ (bit-shift-left (get i2 a) b) (carry i3) )))
      (let ((i1 (+ (bit-shift-left (get i1 a) b) (carry i2) )))
      (let ((i0 (+ (bit-shift-left (get i0 a) b) (carry i1) )))
      (ok (tuple
        (i0 i0)
        (i1 (remainder-uint64 i1))
        (i2 (remainder-uint64 i2))
        (i3 (remainder-uint64 i3))
        (i4 (remainder-uint64 i4))
        (i5 (remainder-uint64 i5))
        (i6 (remainder-uint64 i6))
        (i7 (remainder-uint64 i7))
        )))))))))))
    (if (< b u256)
      (let ((r  (- b u128)))
      (let ((i5 (bit-shift-left (get i7 a) r)))
      (let ((i4 (+ (bit-shift-left (get i6 a) r) (carry i5))))
      (let ((i3 (+ (bit-shift-left (get i5 a) r) (carry i4))))
      (let ((i2 (+ (bit-shift-left (get i4 a) r) (carry i3))))
      (let ((i1 (+ (bit-shift-left (get i3 a) r) (carry i2))))
      (let ((i0 (+ (bit-shift-left (get i2 a) r) (carry i1))))
      (ok (tuple
        (i0 (remainder-uint64 i0))
        (i1 (remainder-uint64 i1))
        (i2 (remainder-uint64 i2))
        (i3 (remainder-uint64 i3))
        (i4 (remainder-uint64 i4))
        (i5 (remainder-uint64 i5))
        (i6 u0)
        (i7 u0))))))))))
      (if (< b u384)
        (let ((r  (- b u256)))
        (let ((i3 (bit-shift-left (get i7 a) r)))
        (let ((i2 (+ (bit-shift-left (get i6 a) r) (carry i3))))
        (let ((i1 (+ (bit-shift-left (get i5 a) r) (carry i2))))
        (let ((i0 (+ (bit-shift-left (get i4 a) r) (carry i1))))
        (ok (tuple
          (i0 (remainder-uint64 i0))
          (i1 (remainder-uint64 i1))
          (i2 (remainder-uint64 i2))
          (i3 (remainder-uint64 i3))
          (i4 u0)
          (i5 u0)
          (i6 u0)
          (i7 u0))))))))
        (if (< b u512)
          (let ((r  (- b u384)))
          (let ((i1 (bit-shift-left (get i7 a) r)))
          (let ((i0 (+ (bit-shift-left (get i6 a) r) (carry i1))))
          (ok (tuple
            (i0 (remainder-uint64 i0))
            (i1 (remainder-uint64 i1))
            (i2 u0)
            (i3 u0)
            (i4 u0)
            (i5 u0)
            (i6 u0)
            (i7 u0))))))
    (ok uint512-zero))))))

(define-private (loop512-div-iter
  (i (buff 1))
  (val (tuple
    (p uint)
    (a (tuple (i0 uint) (i1 uint) (i2 uint) (i3 uint) (i4 uint) (i5 uint) (i6 uint) (i7 uint)))
    (b (tuple (i0 uint) (i1 uint) (i2 uint) (i3 uint) (i4 uint) (i5 uint) (i6 uint) (i7 uint)))
    (q (tuple (i0 uint) (i1 uint) (i2 uint) (i3 uint) (i4 uint) (i5 uint) (i6 uint) (i7 uint)))
    (r (tuple (i0 uint) (i1 uint) (i2 uint) (i3 uint) (i4 uint) (i5 uint) (i6 uint) (i7 uint))))))
  (let ((t (unwrap-panic (uint512-rshift-overflow (get r val) u1))))
    (if (unwrap-panic (uint512< t (get b val)))
      (tuple 
        (p (+ (get p val) u1)) 
        (a (get a val)) 
        (b (get b val)) 
        (q (get q val))
        (r (unwrap-panic (uint512-add-short
          t
          (unwrap-panic (uint512-check-bit (get a val) (- u511 (get p val))))))))
      (tuple
        (p (+ (get p val) u1))
        (a (get a val))
        (b (get b val))
        (q (unwrap-panic (uint512-add (get q val)
          (unwrap-panic (uint512-rshift-overflow uint512-one (- u511 (get p val)))))))
        (r (unwrap-panic (uint512-sub
          (unwrap-panic (uint512-add-short
            t
            (unwrap-panic (uint512-check-bit (get a val) (- u511 (get p val))))))
          (get b val))))))))

(define-read-only (uint512-mod
  (a (tuple (i0 uint) (i1 uint) (i2 uint) (i3 uint) (i4 uint) (i5 uint) (i6 uint) (i7 uint)))
  (b (tuple (i0 uint) (i1 uint) (i2 uint) (i3 uint) (i4 uint) (i5 uint) (i6 uint) (i7 uint))))
  (if (unwrap-panic (uint512-is-zero b))
    (err 1)
    (ok (get r (fold loop512-div-iter iter-buff-512 (tuple (p u0) (a a) (b b) (q uint512-zero) (r uint512-zero)))))))

(define-read-only (uint512-to-uint256-overflow
  (a (tuple (i0 uint) (i1 uint) (i2 uint) (i3 uint) (i4 uint) (i5 uint) (i6 uint) (i7 uint))))
  (ok (tuple 
    (i0 (get i4 a))
    (i1 (get i5 a)) 
    (i2 (get i6 a)) 
    (i3 (get i7 a)))))
