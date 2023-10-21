
(define-read-only (hex-to-uint256 (hex (buff 32)))
  (contract-call? .point hex-to-uint256 hex))

(define-read-only (uint256-to-hex (a (tuple (i0 uint) (i1 uint) (i2 uint) (i3 uint))))
  (contract-call? .point uint256-to-hex a))

(define-read-only (ecc-add (p1 (tuple (x (tuple (i0 uint) (i1 uint) (i2 uint) (i3 uint))) (y (tuple (i0 uint) (i1 uint) (i2 uint) (i3 uint)))))
                        (p2 (tuple (x (tuple (i0 uint) (i1 uint) (i2 uint) (i3 uint))) (y (tuple (i0 uint) (i1 uint) (i2 uint) (i3 uint))))))
  (contract-call? .point ecc-add p1 p2))

(define-read-only (scalar-mul (scalar (tuple (i0 uint) (i1 uint) (i2 uint) (i3 uint)))
  (a (tuple (x (tuple (i0 uint) (i1 uint) (i2 uint) (i3 uint))) (y (tuple (i0 uint) (i1 uint) (i2 uint) (i3 uint))))) )
  (contract-call? .point scalar-mul scalar a))

(define-read-only (txG (scalar (tuple (i0 uint) (i1 uint) (i2 uint) (i3 uint))))
  (contract-call? .point txG scalar))

(define-read-only (tweak-pubkey
  (tweak (tuple (i0 uint) (i1 uint) (i2 uint) (i3 uint)))
  (pubkey (tuple (x (tuple (i0 uint) (i1 uint) (i2 uint) (i3 uint))) (y (tuple (i0 uint) (i1 uint) (i2 uint) (i3 uint))))))
  (contract-call? .tapscript tweak-pubkey tweak pubkey))

;; add differing points #1
(define-read-only (test-sum-1)
  (let (
    (p1
      (tuple
        (x (hex-to-uint256 0x1340a0cdc67100268fd325ff41ddc736e7fc2b078526758633e0c2d260fd1afa))
        (y (hex-to-uint256 0x121352dc1ba32ce746c38f4c18eae7a3a9ff7f06002e9c12ecb259e05da9b622))))
    (p2
      (tuple
        (x (hex-to-uint256 0x79be667ef9dcbbac55a06295ce870b07029bfcdb2dce28d959f2815b16f81798))
        (y (hex-to-uint256 0x483ada7726a3c4655da4fbfc0e1108a8fd17b448a68554199c47d08ffb10d4b8))))
    (p-result (unwrap-panic (ecc-add p1 p2))))
    (asserts! (is-eq (uint256-to-hex (get x p-result)) 0xdf0e99b655223a8414d76c0f0a379eb280c1b562f7acd096e33d1a35bed97ad4) (err "problem!"))
    (asserts! (is-eq (uint256-to-hex (get y p-result)) 0xd068ddeb8543af2b7b16b730f9a2f25943d5a89bb8943a431fa6ee8e4c970d68) (err "problem!"))
    (ok {
        x: (uint256-to-hex (get x p-result)),
        y: (uint256-to-hex (get y p-result)) })))

;; add same points
;; slope is : 0x9cbf21601d33e7fd52b9dcc0cd78e995423240c6e1613f686f4c2c6109d0c64f
(define-read-only (test-sum-2)
  (let (
    (p1
      (tuple
        (x (hex-to-uint256 0x1340a0cdc67100268fd325ff41ddc736e7fc2b078526758633e0c2d260fd1afa))
        (y (hex-to-uint256 0x121352dc1ba32ce746c38f4c18eae7a3a9ff7f06002e9c12ecb259e05da9b622))))
    (p2
      (tuple
        (x (hex-to-uint256 0x1340a0cdc67100268fd325ff41ddc736e7fc2b078526758633e0c2d260fd1afa))
        (y (hex-to-uint256 0x121352dc1ba32ce746c38f4c18eae7a3a9ff7f06002e9c12ecb259e05da9b622))))
    (p-result (unwrap-panic (ecc-add p1 p2))))
    (asserts! (is-eq (uint256-to-hex (get x p-result)) 0x33347485512e02596bc77c80c01dd1c1a2d96befe939422a6fda04669ec82020) (err "problem!"))
    (asserts! (is-eq (uint256-to-hex (get y p-result)) 0x0d6243f43c748faf25b2f05639b2cbe954f8603271a61395ad4180c93a5d9777) (err "problem!"))
    (ok {
        x: (uint256-to-hex (get x p-result)),
        y: (uint256-to-hex (get y p-result)) })))

;; add differing points #3
(define-read-only (test-sum-3)
  (let (
    (p1
      (tuple
        (x (hex-to-uint256 0x33347485512e02596bc77c80c01dd1c1a2d96befe939422a6fda04669ec82020))
        (y (hex-to-uint256 0x0d6243f43c748faf25b2f05639b2cbe954f8603271a61395ad4180c93a5d9777))))
    (p2
      (tuple
        (x (hex-to-uint256 0x1340a0cdc67100268fd325ff41ddc736e7fc2b078526758633e0c2d260fd1afa))
        (y (hex-to-uint256 0x121352dc1ba32ce746c38f4c18eae7a3a9ff7f06002e9c12ecb259e05da9b622))))
    (p-result (unwrap-panic (ecc-add p1 p2))))
    (asserts! (is-eq (uint256-to-hex (get x p-result)) 0xf4c23089accadbcfd8742eec537507cd0ca860bd7d4714dfa88713756487bdd7) (err "problem!"))
    (asserts! (is-eq (uint256-to-hex (get y p-result)) 0x27e0b00f0435e520e3810e74dc32caa9aff6143930003ad468a0298147c68183) (err "problem!"))
    (ok {
        x: (uint256-to-hex (get x p-result)),
        y: (uint256-to-hex (get y p-result)) })))

(define-read-only (test-scalar-mul-1)
  (let (
    (p1
      (tuple
        (x (hex-to-uint256 0x1340a0cdc67100268fd325ff41ddc736e7fc2b078526758633e0c2d260fd1afa))
        (y (hex-to-uint256 0x121352dc1ba32ce746c38f4c18eae7a3a9ff7f06002e9c12ecb259e05da9b622))))
    (scalar (tuple (i0 u0) (i1 u0) (i2 u0) (i3 u2)))
    (p-result (scalar-mul scalar p1)))
    (asserts! (is-eq (uint256-to-hex (get x (get result p-result))) 0x33347485512e02596bc77c80c01dd1c1a2d96befe939422a6fda04669ec82020) (err "problem!"))
    (asserts! (is-eq (uint256-to-hex (get y (get result p-result))) 0x0d6243f43c748faf25b2f05639b2cbe954f8603271a61395ad4180c93a5d9777) (err "problem!"))
    (ok {
        result-x: (uint256-to-hex (get x (get result p-result))),
        result-y: (uint256-to-hex (get y (get result p-result))),
        point-x: (uint256-to-hex (get x (get point p-result))),
        point-y: (uint256-to-hex (get y (get point p-result))),
        scalar: (uint256-to-hex (get scalar p-result)),
        ;; count: (get count p-result),
        ;; DOUBLE_RS: (get double_rs p-result),
        ;; ADDS: (get add p-result),
        })))

(define-read-only (test-scalar-mul-2)
  (let (
    (p1
      (tuple
        (x (hex-to-uint256 0x1340a0cdc67100268fd325ff41ddc736e7fc2b078526758633e0c2d260fd1afa))
        (y (hex-to-uint256 0x121352dc1ba32ce746c38f4c18eae7a3a9ff7f06002e9c12ecb259e05da9b622))))
    (scalar (tuple (i0 u0) (i1 u0) (i2 u0) (i3 u3)))
    (p-result (scalar-mul scalar p1)))
    (asserts! (is-eq (uint256-to-hex (get x (get result p-result))) 0xf4c23089accadbcfd8742eec537507cd0ca860bd7d4714dfa88713756487bdd7) (err "problem!"))
    (asserts! (is-eq (uint256-to-hex (get y (get result p-result))) 0x27e0b00f0435e520e3810e74dc32caa9aff6143930003ad468a0298147c68183) (err "problem!"))

    (ok {
        result-x: (uint256-to-hex (get x (get result p-result))),
        result-y: (uint256-to-hex (get y (get result p-result))),
        point-x: (uint256-to-hex (get x (get point p-result))),
        point-y: (uint256-to-hex (get y (get point p-result))),
        scalar: (uint256-to-hex (get scalar p-result)),
        ;; count: (get count p-result),
        ;; DOUBLE_RS: (get double_rs p-result),
        ;; ADDS: (get add p-result),
        })))

(define-read-only (test-scalar-mul-3)
  (let (
    (p1
      (tuple
        (x (hex-to-uint256 0x1340a0cdc67100268fd325ff41ddc736e7fc2b078526758633e0c2d260fd1afa))
        (y (hex-to-uint256 0x121352dc1ba32ce746c38f4c18eae7a3a9ff7f06002e9c12ecb259e05da9b622))))
    (scalar (tuple (i0 u0) (i1 u0) (i2 u0) (i3 u16)))
    (p-result (scalar-mul scalar p1)))
    (asserts! (is-eq (uint256-to-hex (get x (get result p-result))) 0x3c00b0943b4462e513f6265f725c5a946896f3d059771a243ccb182af00087dd) (err "problem!"))
    (asserts! (is-eq (uint256-to-hex (get y (get result p-result))) 0x0a716018b57502aeb3e14eb7d5a662453e684b33c09b92f4568b71a1bd7ef3bd) (err "problem!"))

    (ok {
        result-x: (uint256-to-hex (get x (get result p-result))),
        result-y: (uint256-to-hex (get y (get result p-result))),
        point-x: (uint256-to-hex (get x (get point p-result))),
        point-y: (uint256-to-hex (get y (get point p-result))),
        scalar: (uint256-to-hex (get scalar p-result)),
        ;; count: (get count p-result),
        ;; DOUBLE_RS: (get double_rs p-result),
        ;; ADDS: (get add p-result),
        })))

(define-read-only (test-scalar-mul-4)
  (let (
    (p1
      (tuple
        (x (hex-to-uint256 0x1340a0cdc67100268fd325ff41ddc736e7fc2b078526758633e0c2d260fd1afa))
        (y (hex-to-uint256 0x121352dc1ba32ce746c38f4c18eae7a3a9ff7f06002e9c12ecb259e05da9b622))))
    (scalar (tuple (i0 u0) (i1 u0) (i2 u0) (i3 u15)))
    (p-result (scalar-mul scalar p1)))
    (asserts! (is-eq (uint256-to-hex (get x (get result p-result))) 0x62476d7c1a0644fea3d46c8fbf58b4d26ca6e669e9a45dab460ceb1686bd6c23) (err "problem!"))
    (asserts! (is-eq (uint256-to-hex (get y (get result p-result))) 0x57c9d6f1d140492e6321db21e4436ee830d884bdfacba90bd2b48a0e72c05a67) (err "problem!"))

    (ok {
        result-x: (uint256-to-hex (get x (get result p-result))),
        result-y: (uint256-to-hex (get y (get result p-result))),
        point-x: (uint256-to-hex (get x (get point p-result))),
        point-y: (uint256-to-hex (get y (get point p-result))),
        scalar: (uint256-to-hex (get scalar p-result)),
        ;; count: (get count p-result),
        ;; DOUBLE_RS: (get double_rs p-result),
        ;; ADDS: (get add p-result),
        })))

(define-read-only (test-txG-1)
  (let (
    (scalar (tuple (i0 u0) (i1 u0) (i2 u0) (i3 u2)))
    (p-result (get result (txG scalar))))
    (asserts! (is-eq (uint256-to-hex (get x p-result)) 0xc6047f9441ed7d6d3045406e95c07cd85c778e4b8cef3ca7abac09b95c709ee5) (err "problem!"))
    (asserts! (is-eq (uint256-to-hex (get y p-result)) 0x1ae168fea63dc339a3c58419466ceaeef7f632653266d0e1236431a950cfe52a) (err "problem!"))
    (ok {
        result-x: (uint256-to-hex (get x p-result)),
        result-y: (uint256-to-hex (get y p-result)),
        ;; point-x: (uint256-to-hex (get x (get point p-result))),
        ;; point-y: (uint256-to-hex (get y (get point p-result))),
        ;; scalar: (uint256-to-hex (get scalar p-result)),
        ;; count: (get count p-result),
        ;; DOUBLE_RS: (get double_rs p-result),
        ;; ADDS: (get add p-result),
        })))

(define-read-only (test-txG-2)
  (let (
    (scalar (tuple (i0 u0) (i1 u0) (i2 u0) (i3 u3)))
    (p-result (get result (txG scalar))))
    (asserts! (is-eq (uint256-to-hex (get x p-result)) 0xf9308a019258c31049344f85f89d5229b531c845836f99b08601f113bce036f9) (err "problem!"))
    (asserts! (is-eq (uint256-to-hex (get y p-result)) 0x388f7b0f632de8140fe337e62a37f3566500a99934c2231b6cb9fd7584b8e672) (err "problem!"))
    (ok {
        result-x: (uint256-to-hex (get x p-result)),
        result-y: (uint256-to-hex (get y p-result)),
      })))

(define-read-only (test-txG-3)
  (let (
    (scalar (tuple (i0 u0) (i1 u0) (i2 u0) (i3 u4)))
    (p-result (get result (txG scalar))))
    (asserts! (is-eq (uint256-to-hex (get x p-result)) 0xe493dbf1c10d80f3581e4904930b1404cc6c13900ee0758474fa94abe8c4cd13) (err "problem!"))
    (asserts! (is-eq (uint256-to-hex (get y p-result)) 0x51ed993ea0d455b75642e2098ea51448d967ae33bfbdfe40cfe97bdc47739922) (err "problem!"))
    (ok {
        result-x: (uint256-to-hex (get x p-result)),
        result-y: (uint256-to-hex (get y p-result)),
      })))

(define-read-only (test-txG-4)
  (let (
    (scalar (tuple (i0 u0) (i1 u0) (i2 u0) (i3 u7)))
    (p-result (get result (txG scalar))))
    (asserts! (is-eq (uint256-to-hex (get x p-result)) 0x5cbdf0646e5db4eaa398f365f2ea7a0e3d419b7e0330e39ce92bddedcac4f9bc) (err "problem!"))
    (asserts! (is-eq (uint256-to-hex (get y p-result)) 0x6aebca40ba255960a3178d6d861a54dba813d0b813fde7b5a5082628087264da) (err "problem!"))
    (ok {
        result-x: (uint256-to-hex (get x p-result)),
        result-y: (uint256-to-hex (get y p-result)),
      })))

(define-read-only (test-txG-5)
  (let (
    (scalar (tuple (i0 u0) (i1 u0) (i2 u0) (i3 u15)))
    (p-result (get result (txG scalar))))
    (asserts! (is-eq (uint256-to-hex (get x p-result)) 0xd7924d4f7d43ea965a465ae3095ff41131e5946f3c85f79e44adbcf8e27e080e) (err "problem!"))
    (asserts! (is-eq (uint256-to-hex (get y p-result)) 0x581e2872a86c72a683842ec228cc6defea40af2bd896d3a5c504dc9ff6a26b58) (err "problem!"))
    (ok {
        result-x: (uint256-to-hex (get x p-result)),
        result-y: (uint256-to-hex (get y p-result)),
        })))

(define-read-only (test-txG-6)
  (let (
    (scalar (tuple (i0 u0) (i1 u0) (i2 u0) (i3 u15)))
    (p-result (get result (txG scalar))))
    (asserts! (is-eq (uint256-to-hex (get x p-result)) 0xd7924d4f7d43ea965a465ae3095ff41131e5946f3c85f79e44adbcf8e27e080e) (err "problem!"))
    (asserts! (is-eq (uint256-to-hex (get y p-result)) 0x581e2872a86c72a683842ec228cc6defea40af2bd896d3a5c504dc9ff6a26b58) (err "problem!"))
    (ok {
        result-x: (uint256-to-hex (get x p-result)),
        result-y: (uint256-to-hex (get y p-result)),
        ;; point-x: (uint256-to-hex (get x (get point p-result))),
        ;; point-y: (uint256-to-hex (get y (get point p-result))),
        ;; scalar: (uint256-to-hex (get scalar p-result)),
        ;; count: (get count p-result),
        ;; DOUBLE_RS: (get double_rs p-result),
        ;; ADDS: (get add p-result),
        })))

(define-read-only (test-txG-7)
  (let (
    (scalar (hex-to-uint256 0x45f3b51eeac2e7610fa7902abfce05c3f6a9f3599fa5cc004b269bb9c10baf28))
    (p-result (txG scalar)))
    ;; (asserts! (is-eq (uint256-to-hex (get x (get result p-result))) 0xd7924d4f7d43ea965a465ae3095ff41131e5946f3c85f79e44adbcf8e27e080e) (err "problem!"))
    ;; (asserts! (is-eq (uint256-to-hex (get y (get result p-result))) 0x581e2872a86c72a683842ec228cc6defea40af2bd896d3a5c504dc9ff6a26b58) (err "problem!"))
    (ok {
        result-x: (uint256-to-hex (get x (get result p-result))),
        result-y: (uint256-to-hex (get y (get result p-result))),
        point-x: (uint256-to-hex (get x (get point p-result))),
        point-y: (uint256-to-hex (get y (get point p-result))),
        scalar: (uint256-to-hex (get scalar p-result)),
        count: (get count p-result),
        DOUBLE_RS: (get double_rs p-result),
        ADDS: (get add p-result),
        })))

(define-read-only (test-tweak-pubkey-1)
  (let (
    (tweak (hex-to-uint256 0x0000000000000000000000000000000000000000000000000000000000000002))
    (pubkey (tuple (x (hex-to-uint256 0x1340a0cdc67100268fd325ff41ddc736e7fc2b078526758633e0c2d260fd1afa)) (y (hex-to-uint256 0x121352dc1ba32ce746c38f4c18eae7a3a9ff7f06002e9c12ecb259e05da9b622))))
    (tweaked-point (tweak-pubkey tweak pubkey)))

  (asserts! (is-eq (uint256-to-hex (get x tweaked-point)) 0xc9e2a87dfb567263856a23277435e860359c5b480f7ce4108790b9300e2668c2) (err "problem!"))
  (asserts! (is-eq (uint256-to-hex (get y tweaked-point)) 0x434b4967fb4fd4f94d9049329a35c571c43d0875bb5f3f7ca672b756a72eeff0) (err "problem!"))

  (ok {
    x: (uint256-to-hex (get x tweaked-point)),
    y: (uint256-to-hex (get y tweaked-point)),
      })))

(define-read-only (test-tweak-pubkey-2)
  (let (
    (tweak (hex-to-uint256 0x0000000000000000000000000000000000000000000000000000000000000003))
    (pubkey (tuple (x (hex-to-uint256 0x1340a0cdc67100268fd325ff41ddc736e7fc2b078526758633e0c2d260fd1afa)) (y (hex-to-uint256 0x121352dc1ba32ce746c38f4c18eae7a3a9ff7f06002e9c12ecb259e05da9b622))))
    (tweaked-point (tweak-pubkey tweak pubkey)))

  (asserts! (is-eq (uint256-to-hex (get x tweaked-point)) 0x0b3c76063853eb11c5d90905c45d2f1e4abf72d2bb61835c23caa5b6315a3890) (err "problem!"))
  (asserts! (is-eq (uint256-to-hex (get y tweaked-point)) 0xbad5bdfedfa3fa5b932c93006b05bae9030a1b24d40e5d113de1b7badc79be67) (err "problem!"))

  (ok {
    x: (uint256-to-hex (get x tweaked-point)),
    y: (uint256-to-hex (get y tweaked-point)),
      })))

(define-read-only (test-tweak-pubkey-3)
  (let (
    (tweak (hex-to-uint256 0x0000000000000000000000000000000000000000000000000000000000000004))
    (pubkey (tuple (x (hex-to-uint256 0x1340a0cdc67100268fd325ff41ddc736e7fc2b078526758633e0c2d260fd1afa)) (y (hex-to-uint256 0x121352dc1ba32ce746c38f4c18eae7a3a9ff7f06002e9c12ecb259e05da9b622))))
    (tweaked-point (tweak-pubkey tweak pubkey)))

  (asserts! (is-eq (uint256-to-hex (get x tweaked-point)) 0x33fb6ce81682690c9d14ed297dc630f315f1d4d54826b10dbb2343e8d4d67b00) (err "problem!"))
  (asserts! (is-eq (uint256-to-hex (get y tweaked-point)) 0xe4ade2a8d403e6275ae2fbd8aff527ab7278b004ab94be887b132f9b4f8c44d9) (err "problem!"))

  (ok {
    x: (uint256-to-hex (get x tweaked-point)),
    y: (uint256-to-hex (get y tweaked-point)),
      })))

(define-read-only (test-tweak-pubkey-4)
  (let (
    (tweak (hex-to-uint256 0x0000000000000000000000000000000000000000000000000000000000000005))
    (pubkey (tuple (x (hex-to-uint256 0x1340a0cdc67100268fd325ff41ddc736e7fc2b078526758633e0c2d260fd1afa)) (y (hex-to-uint256 0x121352dc1ba32ce746c38f4c18eae7a3a9ff7f06002e9c12ecb259e05da9b622))))
    (tweaked-point (tweak-pubkey tweak pubkey)))

  (asserts! (is-eq (uint256-to-hex (get x tweaked-point)) 0xd3b810e96a40b541bcb22256a8c9344f7b8cde64229d146725035df12bc760d5) (err "problem!"))
  (asserts! (is-eq (uint256-to-hex (get y tweaked-point)) 0xcb06aaa20495653ece0c1b6d5c4fbe885913b34efa6104eac9165434682fa330) (err "problem!"))

  (ok {
    x: (uint256-to-hex (get x tweaked-point)),
    y: (uint256-to-hex (get y tweaked-point)),
      })))


(define-read-only (debug-test-tweak-pubkey-1)
  (let (
    (tweak (hex-to-uint256 0x45f3b51eeac2e7610fa7902abfce05c3f6a9f3599fa5cc004b269bb9c10baf28))
    (tweak-point (txG tweak))
    ;; (tweak-point (tuple (x (hex-to-uint256 0x1634e9b9bbfbda67b81f8c7c1e4c35ceb3fb113d42ae5cb92bc30d572f2b08b4)) (y (hex-to-uint256 0xb0277922a1f80f43b06f08d1fc571c7d41f8dc09ab63f7ae109b255421da6a71))))
    (pubkey (tuple (x (hex-to-uint256 0x1340a0cdc67100268fd325ff41ddc736e7fc2b078526758633e0c2d260fd1afa)) (y (hex-to-uint256 0x121352dc1ba32ce746c38f4c18eae7a3a9ff7f06002e9c12ecb259e05da9b622))))
    (tweaked-point (unwrap-panic (ecc-add (get result tweak-point) pubkey))))

  ;; (asserts! (is-eq (uint256-to-hex (get x tweaked-point)) 0xaf5e6479a4af8f0745649554245110d1b408baed0f48feb49437f86ede2ddbdf) (err "problem!"))
  ;; (asserts! (is-eq (uint256-to-hex (get y tweaked-point)) 0x23d9bc8164816e41c89a7d2195f373ba17895be899b07df9011ac8b6847dfb31) (err "problem!"))

  (ok {
    tweak-x: (uint256-to-hex (get x tweaked-point)),
    tweak-y: (uint256-to-hex (get y tweaked-point)),
    x: (uint256-to-hex (get x tweaked-point)),
    y: (uint256-to-hex (get y tweaked-point)),
    point-x: (uint256-to-hex (get x (get point tweak-point))),
    point-y: (uint256-to-hex (get y (get point tweak-point))),
    scalar: (uint256-to-hex (get scalar tweak-point)),
    count: (get count tweak-point),
    DOUBLE_RS: (get double_rs tweak-point),
    ADDS: (get add tweak-point),
      })))