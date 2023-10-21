(define-constant OP_0 0x00)
(define-constant OP_1 0x51)
(define-constant segwit-marker-flag 0x0001)
(define-constant version-P2WSH 0x05)
(define-constant version-P2TR 0x06)
(define-constant supported-address-versions (list version-P2WSH version-P2TR))
(define-constant default-witness-reserved-data 0x0000000000000000000000000000000000000000000000000000000000000000)

(define-constant err-not-segwit-tx (err u500))
(define-constant err-minimum-burnchain-confirmations-not-reached (err u103))

(define-constant burnchain-confirmations-required u2)

(define-public (get-verified-tx-data
	(burn-height uint) ;; bitcoin block height
	(tx (buff 4096)) ;; tx to check
	(header (buff 80)) ;; bitcoin block header
	(tx-index uint)
	(cproof (list 14 (buff 32)))
	(tree-depth uint)
	)
	(begin
		(asserts! (<= (+ burn-height burnchain-confirmations-required) burn-block-height) err-minimum-burnchain-confirmations-not-reached)
		;; Check if the transaction is a segwit transaction (clarity-bitcoin-v4 does not do this check).
		;; (asserts! (is-eq (slice? tx u4 u6) (some segwit-marker-flag)) err-not-segwit-tx)
		;; TODO: optimise to one call
		(try! (contract-call? .clarity-bitcoin-v5 was-tx-mined-compact
			burn-height
			tx
			header
      {
        tx-index: tx-index,
        hashes: cproof,
        tree-depth: tree-depth,
      }
		))
		(ok
      (merge
        (try! (contract-call? .clarity-bitcoin-v5 parse-tx tx))
        { txid: (sha256 (sha256 tx)) }
      )
    )
	)
)