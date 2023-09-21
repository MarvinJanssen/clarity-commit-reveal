
(define-constant OP_0 0x00)
(define-constant OP_1 0x51)
(define-constant taproot-annex-a-prefix 0x50)

(define-constant expected-program-length-byte 0x20)
(define-constant expected-taproot-header (some (concat OP_1 expected-program-length-byte)))
(define-constant expected-p2wsh-header (some (concat OP_0 expected-program-length-byte)))

(define-constant err-invalid-input-index (err u100))
(define-constant err-witness-stack-missing (err u101))
(define-constant err-witness-stack-empty (err u102))
(define-constant err-no-witness-script-in-stack (err u106))
(define-constant err-missing-commit (err u107))
(define-constant err-unknown-witness-version (err u108))

(define-read-only (extract-taproot-witness-script (witness-stack (list 8 (buff 128))))
	(let (
		(length (len witness-stack))
		(has-annex (and (> length u1) (is-eq (element-at? (unwrap-panic (element-at? witness-stack (- length u1))) u0) (some taproot-annex-a-prefix))))
		)
		(asserts! (>= length (if has-annex u3 u2)) err-no-witness-script-in-stack)
		(ok (unwrap-panic (element-at? witness-stack (- length (if has-annex u3 u2)))))
	)
)

(define-public (submit-commit
	(burn-height uint)
	(tx (buff 4096))
	(header (buff 80))
	(tx-index uint)
	(tree-depth uint)
	(input-index uint)
	(wproof (list 14 (buff 32)))
	(witness-merkle-root (buff 32))
	(witness-reserved-data (optional (buff 32)))
	(ctx (buff 1024))
	(cproof (list 14 (buff 32)))
	) 
	(let (
		(tx-data (try! (contract-call? .bitcoin-helper was-segwit-tx-mined
			burn-height
			tx
			header
			tx-index
			tree-depth
			wproof
			witness-merkle-root
			witness-reserved-data
			ctx
			cproof)))
		(selected-input-outpoint (unwrap! (get outpoint (element-at? (get ins tx-data) input-index)) err-invalid-input-index))
		(commit-txid (get hash selected-input-outpoint))
		(commit-output (unwrap! (contract-call? .transaction-storage get-commit-output commit-txid (get index selected-input-outpoint)) err-missing-commit))
		(commit-output-header (slice? (get scriptPubKey commit-output) u0 u2))
		(witness-stack (unwrap! (element-at? (get witnesses tx-data) input-index) err-witness-stack-missing))
		(witness-script (if (is-eq commit-output-header expected-taproot-header)
			(try! (extract-taproot-witness-script witness-stack))
			(if (is-eq commit-output-header expected-p2wsh-header) (default-to 0x (element-at? witness-stack u0)) 0x)
		))
		)
		(asserts! (not (is-eq 0x witness-script)) err-no-witness-script-in-stack)
		;; TODO: print event
		(contract-call? .transaction-storage assert-new-reveal commit-txid input-index (unwrap-panic (get txid tx-data)) witness-script)
	)
)