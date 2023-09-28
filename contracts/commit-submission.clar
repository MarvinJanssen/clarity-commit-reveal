(define-constant err-invalid-output-index (err u100))

(define-public (submit-commit
	(burn-height uint)
	(tx (buff 4096))
	(header (buff 80))
	(tx-index uint)
	(tree-depth uint)
	(output-index uint)
	;; (output-unlock-witness-script (buff 128))
	(wproof (list 14 (buff 32)))
	(witness-merkle-root (buff 32))
	(witness-reserved-data (optional (buff 32)))
	(ctx (buff 1024))
	(cproof (list 14 (buff 32)))
	) 
	(let (
		(tx-data (try! (contract-call? .bitcoin-helper get-verified-tx-data
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
		(selected-output (unwrap! (element-at? (get outs tx-data) output-index) err-invalid-output-index))
		)
		;; TODO: verify taproot witness script. If we verify it here then we can store it early.
		;; (try! (contract-call? .witness-helper verify-script-witness-program (get scriptPubKey selected-output) (list output-unlock-witness-script)))
		;; TODO: print event
		(contract-call? .transaction-storage insert-new-commit (unwrap-panic (get txid tx-data)) output-index selected-output)
	)
)
