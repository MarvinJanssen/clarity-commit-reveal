(define-constant iter-buff-32 (keccak256 0))
(define-constant iter-buff-64 0x00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000)
(define-constant iter-buff-256 0x00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000)

(define-constant uint64-max u18446744073709551615)
(define-constant uint64-max-limit u18446744073709551616)

(define-constant uint256-zero (tuple (i0 u0) (i1 u0) (i2 u0) (i3 u0)))
(define-constant uint256-one (tuple (i0 u0) (i1 u0) (i2 u0) (i3 u1)))

(define-constant ERR-OUT-OF-BOUNDS (err u1))

;; reads BE
(define-read-only (hex-to-uint256 (a (buff 32)))
  (ok
    (tuple
      (i0 (buff-to-uint-be (try! (read-uint64 a u0 u8))))
      (i1 (buff-to-uint-be (try! (read-uint64 a u8 u8))))
      (i2 (buff-to-uint-be (try! (read-uint64 a u16 u8))))
      (i3 (buff-to-uint-be (try! (read-uint64 a u24 u8)))))))

(define-read-only (uint64-to-hex (a uint))
  (unwrap-panic (as-max-len? (unwrap-panic (slice? (unwrap-panic (to-consensus-buff? a)) u9 u17)) u8)))

;; TODO: assert each val is < uint-64-max
(define-read-only (uint256-to-hex
  (a (tuple (i0 uint) (i1 uint) (i2 uint) (i3 uint))))
  (ok
    (concat (concat (concat (uint64-to-hex (get i0 a)) (uint64-to-hex (get i1 a))) (uint64-to-hex (get i2 a))) (uint64-to-hex (get i3 a)))))

(define-read-only (bignum-to-hex
  (a (tuple (i0 uint) (i1 uint) (i2 uint) (i3 uint) (i4 uint) (i5 uint) (i6 uint) (i7 uint) (i8 uint) (i9 uint) (i10 uint) (i11 uint))))
  (ok
    (concat
    (concat
    (concat
    (concat
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
      (uint64-to-hex (get i7 a)))
      (uint64-to-hex (get i8 a)))
      (uint64-to-hex (get i9 a)))
      (uint64-to-hex (get i10 a)))
      (uint64-to-hex (get i11 a)))))

(define-read-only (read-uint64 (data (buff 32)) (offset uint) (size uint))
  (ok
    (unwrap! (as-max-len? (unwrap! (slice? data offset (+ offset size)) ERR-OUT-OF-BOUNDS) u8) ERR-OUT-OF-BOUNDS)))

(define-read-only (carry (a uint))
  (if (> a uint64-max) (/ a uint64-max-limit) u0))

(define-read-only (remainder-uint64 (a uint))
  (if (> (/ a uint64-max-limit) u0) (mod a uint64-max-limit) a))

(define-read-only (uint256-add
  (a (tuple (i0 uint) (i1 uint) (i2 uint) (i3 uint)))
  (b (tuple (i0 uint) (i1 uint) (i2 uint) (i3 uint))))
  (let ((i3 (+ (get i3 a) (get i3 b))))
  (let ((i2 (+ (get i2 a) (get i2 b) (carry i3)) ))
  (let ((i1 (+ (get i1 a) (get i1 b) (carry i2)) ))
  (let ((i0 (+ (get i0 a) (get i0 b) (carry i1)) ))
  (ok (tuple (i0 i0)
    (i1 (remainder-uint64 i1))
    (i2 (remainder-uint64 i2))
    (i3 (remainder-uint64 i3)))))))))

(define-read-only (uint256-cmp
  (a (tuple (i0 uint) (i1 uint) (i2 uint) (i3 uint)))
  (b (tuple (i0 uint) (i1 uint) (i2 uint) (i3 uint))))
  (ok (if (is-eq (get i0 a) (get i0 b))
    (if (is-eq (get i1 a) (get i1 b))
      (if (is-eq (get i2 a) (get i2 b))
        (if (is-eq (get i3 a) (get i3 b))
          0
          (if (> (get i3 a) (get i3 b)) 1 -1))
        (if (> (get i2 a) (get i2 b)) 1 -1))
      (if (> (get i1 a) (get i1 b)) 1 -1))
    (if (> (get i0 a) (get i0 b)) 1 -1))))

(define-read-only (uint256-add-short
  (a (tuple (i0 uint) (i1 uint) (i2 uint) (i3 uint)))
  (b uint))
  (uint256-add a (tuple (i0 u0) (i1 u0) (i2 (/ b uint64-max-limit)) (i3 (mod b uint64-max-limit)))))

(define-read-only (uint256-is-eq
  (a (tuple (i0 uint) (i1 uint) (i2 uint) (i3 uint)))
  (b (tuple (i0 uint) (i1 uint) (i2 uint) (i3 uint))))
  (ok (is-eq (unwrap-panic (uint256-cmp a b)) 0)))

(define-read-only (uint256>
  (a (tuple (i0 uint) (i1 uint) (i2 uint) (i3 uint)))
  (b (tuple (i0 uint) (i1 uint) (i2 uint) (i3 uint))))
  (ok (> (unwrap-panic (uint256-cmp a b)) 0)))

(define-read-only (uint256<
  (a (tuple (i0 uint) (i1 uint) (i2 uint) (i3 uint)))
  (b (tuple (i0 uint) (i1 uint) (i2 uint) (i3 uint))))
  (ok (< (unwrap-panic (uint256-cmp a b)) 0)))

(define-read-only (uint256-is-zero
  (a (tuple (i0 uint) (i1 uint) (i2 uint) (i3 uint))))
  (ok (if (is-eq (get i0 a) u0)
    (if (is-eq (get i1 a) u0)
      (if (is-eq (get i2 a) u0)
        (if (is-eq (get i3 a) u0)
          true
          false)
        false)
      false)
  false)))

(define-private (loop-bits-iter
  (i (buff 1))
  (val (tuple (num uint) (res uint))))
  (if (> (get num val) u0)
    (tuple (num (/ (get num val) u2)) (res (+ (get res val) u1)))
    (tuple (num u0) (res (get res val)))))

(define-read-only (loop-bits (num uint))
  (ok (get res (fold loop-bits-iter iter-buff-64 (tuple (num num) (res u0))))))

(define-read-only (uint256-bits
  (a (tuple (i0 uint) (i1 uint) (i2 uint) (i3 uint))))
  (ok
    (if (is-eq (get i0 a) u0)
      (if (is-eq (get i1 a) u0)
        (if (is-eq (get i2 a) u0)
          (unwrap-panic (loop-bits (get i3 a)))
          (+ (unwrap-panic (loop-bits (get i2 a))) u64))
        (+ (unwrap-panic (loop-bits (get i1 a))) u128))
      (+ (unwrap-panic (loop-bits (get i0 a))) u192))))

(define-read-only (uint256-rshift-64-overflow (a (tuple (i0 uint) (i1 uint) (i2 uint) (i3 uint))))
  (ok (tuple (i0 (get i1 a)) (i1 (get i2 a)) (i2 (get i3 a)) (i3 u0))))

(define-read-only (uint256-rshift-overflow
  (a (tuple (i0 uint) (i1 uint) (i2 uint) (i3 uint)))
  (b uint))
    (if (< b u128)
      (begin
        (let ((i3 (bit-shift-left (get i3 a) b)))
        (let ((i2 (+ (bit-shift-left (get i2 a) b) (carry i3) )))
        (let ((i1 (+ (bit-shift-left (get i1 a) b) (carry i2) )))
        (let ((i0 (+ (bit-shift-left (get i0 a) b) (carry i1) )))
        (ok (tuple 
          (i0 i0)
          (i1 (remainder-uint64 i1))
          (i2 (remainder-uint64 i2))
          (i3 (remainder-uint64 i3))
          )))))))
      (if (< b u256)
        (let ((r  (- b u128)))
          (let ((i1 (bit-shift-left (get i3 a) r)))
          (let ((i0 (+ (bit-shift-left (get i2 a) r) (carry i1))))
          (ok (tuple 
            (i0 (remainder-uint64 i0))
            (i1 (remainder-uint64 i1))
            (i2 u0) 
            (i3 u0))))))
        (ok uint256-zero))))

(define-read-only (uint256-lshift-1
  (a (tuple (i0 uint) (i1 uint) (i2 uint) (i3 uint))))
  (let ((r u2))
  (let ((i0 (get i0 a)))
  (let ((i1 (+ (* (mod i0 r) uint64-max-limit) (get i1 a))))
  (let ((i2 (+ (* (mod i1 r) uint64-max-limit) (get i2 a))))
  (let ((i3 (+ (* (mod i2 r) uint64-max-limit) (get i3 a))))
    (ok (tuple 
      (i0 (/ i0 r))
      (i1 (/ i1 r)) 
      (i2 (/ i2 r)) 
      (i3 (/ i3 r))))))))))

(define-read-only (uint256-check-bit
  (a (tuple (i0 uint) (i1 uint) (i2 uint) (i3 uint))) (b uint))
  (if (> b u256) (err 1)
    (let ((v (if (is-eq (/ b u64) u3)
      (get i0 a)
      (if (is-eq (/ b u64) u2)
        (get i1 a)
        (if (is-eq (/ b u64) u1)
          (get i2 a)
          (get i3 a))))))
    (ok (bit-and (bit-shift-right v (mod b u64)) u1)))))

(define-read-only (check-bit-64 (v uint) (b uint))
  (ok (bit-and (bit-shift-right v (mod b u64)) u1)))

(define-read-only (uint256-sub
  (a (tuple (i0 uint) (i1 uint) (i2 uint) (i3 uint)))
  (b (tuple (i0 uint) (i1 uint) (i2 uint) (i3 uint))))
  (let ((i (if (unwrap-panic (uint256> a b)) a b)) (j (if (unwrap-panic (uint256> a b)) b a )))
  (let ((i3 (- (to-int (get i3 i)) (to-int (get i3 j)))))
  (let ((i2 (- (- (to-int (get i2 i)) (to-int (get i2 j))) (if (< i3 0) 1 0))))
  (let ((i1 (- (- (to-int (get i1 i)) (to-int (get i1 j))) (if (< i2 0) 1 0))))
  (let ((i0 (- (- (to-int (get i0 i)) (to-int (get i0 j))) (if (< i1 0) 1 0))))
  (ok (tuple
    (i0 (to-uint i0)) 
    (i1 (mod (to-uint (if (< i1 0) (+ (to-int uint64-max-limit) i1) i1)) uint64-max-limit)) 
    (i2 (mod (to-uint (if (< i2 0) (+ (to-int uint64-max-limit) i2) i2)) uint64-max-limit)) 
    (i3 (mod (to-uint (if (< i3 0) (+ (to-int uint64-max-limit) i3) i3)) uint64-max-limit))))))))))

(define-read-only (uint256-sub-mod
  (a (tuple (i0 uint) (i1 uint) (i2 uint) (i3 uint)))
  (b (tuple (i0 uint) (i1 uint) (i2 uint) (i3 uint)))
  (p (tuple (i0 uint) (i1 uint) (i2 uint) (i3 uint))))
  (if (unwrap-panic (uint256< a b))
    (uint256-mod (unwrap-panic (uint256-sub p (unwrap-panic (uint256-sub a b)))) p)
    (uint256-mod (unwrap-panic (uint256-sub a b)) p)))

(define-read-only (uint256-mul-short
  (a (tuple (i0 uint) (i1 uint) (i2 uint) (i3 uint)))
  (b uint))
  (let ((i3 (* (get i3 a) b)))
  (let ((i2 (+ (* (get i2 a) b) (if (> i3 uint64-max) (/ i3 uint64-max-limit) u0))))
  (let ((i1 (+ (* (get i1 a) b) (if (> i2 uint64-max) (/ i2 uint64-max-limit) u0))))
  (let ((i0 (+ (* (get i0 a) b) (if (> i1 uint64-max) (/ i1 uint64-max-limit) u0))))
  (ok (tuple
    (i0 i0)
    (i1 ( if (> (/ i1 uint64-max-limit) u0) (mod i1 uint64-max-limit) i1))
    (i2 ( if (> (/ i2 uint64-max-limit) u0) (mod i2 uint64-max-limit) i2))
    (i3 ( if (> (/ i3 uint64-max-limit) u0) (mod i3 uint64-max-limit) i3)))))))))

(define-read-only (uint256-mul
  (a (tuple (i0 uint) (i1 uint) (i2 uint) (i3 uint)))
  (b (tuple (i0 uint) (i1 uint) (i2 uint) (i3 uint))))
  (let ((i7 (* (get i3 a) (get i3 b))))
  (let ((i6-1 { remainder: (remainder-uint64 (* (get i3 a) (get i2 b))), carry: (carry (* (get i3 a) (get i2 b))) })
        (i6-2 { remainder: (remainder-uint64 (* (get i2 a) (get i3 b))), carry: (carry (* (get i2 a) (get i3 b))) })
        (i6 (+
              (carry i7)
              (get remainder i6-1)
              (get remainder i6-2))))
  (let ((i5-1 { remainder: (remainder-uint64 (* (get i3 a) (get i1 b))), carry: (carry (* (get i3 a) (get i1 b))) })
        (i5-2 { remainder: (remainder-uint64 (* (get i2 a) (get i2 b))), carry: (carry (* (get i2 a) (get i2 b))) })
        (i5-3 { remainder: (remainder-uint64 (* (get i1 a) (get i3 b))), carry: (carry (* (get i1 a) (get i3 b))) })
        (i5 (+
              (carry i6)
              (get carry i6-1)
              (get carry i6-2)
              (get remainder i5-1)
              (get remainder i5-2)
              (get remainder i5-3))))
  (let ((i4-1 { remainder: (remainder-uint64 (* (get i3 a) (get i0 b))), carry: (carry (* (get i3 a) (get i0 b))) })
        (i4-2 { remainder: (remainder-uint64 (* (get i2 a) (get i1 b))), carry: (carry (* (get i2 a) (get i1 b))) })
        (i4-3 { remainder: (remainder-uint64 (* (get i1 a) (get i2 b))), carry: (carry (* (get i1 a) (get i2 b))) })
        (i4-4 { remainder: (remainder-uint64 (* (get i0 a) (get i3 b))), carry: (carry (* (get i0 a) (get i3 b))) })
        (i4 (+
              (carry i5)
              (get carry i5-1)
              (get carry i5-2)
              (get carry i5-3)
              (get remainder i4-1)
              (get remainder i4-2)
              (get remainder i4-3)
              (get remainder i4-4))))
  (let ((i3-1 { remainder: (remainder-uint64 (* (get i2 a) (get i0 b))), carry: (carry (* (get i2 a) (get i0 b))) })
        (i3-2 { remainder: (remainder-uint64 (* (get i1 a) (get i1 b))), carry: (carry (* (get i1 a) (get i1 b))) })
        (i3-3 { remainder: (remainder-uint64 (* (get i0 a) (get i2 b))), carry: (carry (* (get i0 a) (get i2 b))) })
        (i3 (+
              (carry i4)
              (get carry i4-1)
              (get carry i4-2)
              (get carry i4-3)
              (get carry i4-4)
              (get remainder i3-1)
              (get remainder i3-2)
              (get remainder i3-3)
            )))
  (let ((i2-1 { remainder: (remainder-uint64 (* (get i1 a) (get i0 b))), carry: (carry (* (get i1 a) (get i0 b))) })
        (i2-2 { remainder: (remainder-uint64 (* (get i0 a) (get i1 b))), carry: (carry (* (get i0 a) (get i1 b))) })
        (i2 (+
              (carry i3)
              (get carry i3-1)
              (get carry i3-2)
              (get carry i3-3)
              (get remainder i2-1)
              (get remainder i2-2)
            )))
  (let ((i1-1 { remainder: (remainder-uint64 (* (get i0 a) (get i0 b))), carry: (carry (* (get i0 a) (get i0 b))) })
        (i1 (+
              (carry i2)
              (get carry i2-1)
              (get carry i2-2)
              (get remainder i1-1)
            )))
  (let ((i0 (+ (carry i1)  (get carry i1-1))))
  (ok (tuple
    (i0 i0)
    (i1 (remainder-uint64 i1))
    (i2 (remainder-uint64 i2))
    (i3 (remainder-uint64 i3))
    (i4 (remainder-uint64 i4))
    (i5 (remainder-uint64 i5))
    (i6 (remainder-uint64 i6))
    (i7 (remainder-uint64 i7)))))))))))))

(define-private (loop-div-iter
  (i (buff 1))
  (val (tuple
    (p uint)
    (a (tuple (i0 uint) (i1 uint) (i2 uint) (i3 uint)))
    (b (tuple (i0 uint) (i1 uint) (i2 uint) (i3 uint)))
    (q (tuple (i0 uint) (i1 uint) (i2 uint) (i3 uint)))
    (r (tuple (i0 uint) (i1 uint) (i2 uint) (i3 uint))))))
  (let ((t (unwrap-panic (uint256-rshift-overflow (get r val) u1))))
    (if (unwrap-panic (uint256< t (get b val)))
    (tuple
      (p (+ (get p val) u1))
      (a (get a val))
      (b (get b val))
      (q (get q val))
      (r (unwrap-panic (uint256-add-short
        t 
        (unwrap-panic (uint256-check-bit (get a val) (- u255 (get p val))))))))
    (tuple
      (p (+ (get p val) u1))
      (a (get a val))
      (b (get b val))
      (q (unwrap-panic (uint256-add (get q val)
        (unwrap-panic (uint256-rshift-overflow uint256-one (- u255 (get p val)))))))
      (r (unwrap-panic (uint256-sub
        (unwrap-panic (uint256-add-short
          t
          (unwrap-panic (uint256-check-bit (get a val) (- u255 (get p val))))))
        (get b val))))))))

(define-read-only (uint256-euclid
  (a (tuple (i0 uint) (i1 uint) (i2 uint) (i3 uint)))
  (b (tuple (i0 uint) (i1 uint) (i2 uint) (i3 uint))))
  (if (unwrap-panic (uint256-is-zero b))
    (err 1)
    (ok (fold loop-div-iter iter-buff-256 (tuple (p u0) (a a) (b b) (q uint256-zero) (r uint256-zero))))))

(define-read-only (uint256-div
  (a (tuple (i0 uint) (i1 uint) (i2 uint) (i3 uint)))
  (b (tuple (i0 uint) (i1 uint) (i2 uint) (i3 uint))))
  (if (unwrap-panic (uint256-is-zero b))
    (err 1)
    (ok (get q (fold loop-div-iter iter-buff-256 (tuple (p u0) (a a) (b b) (q uint256-zero) (r uint256-zero)))))))

(define-read-only (uint256-mod
  (a (tuple (i0 uint) (i1 uint) (i2 uint) (i3 uint)))
  (b (tuple (i0 uint) (i1 uint) (i2 uint) (i3 uint)))) 
  (if (unwrap-panic (uint256-is-zero b))
    (err 1)
    (ok (get r (fold loop-div-iter iter-buff-256 (tuple (p u0) (a a) (b b) (q uint256-zero) (r uint256-zero)))))))

(define-read-only (uint-to-uint256 (a uint))
  (ok (tuple
    (i0 u0)
    (i1 u0)
    (i2 (/ a uint64-max-limit))
    (i3 (mod a uint64-max-limit)))))
