(define-constant err-invalid-output-index (err u100))
(define-constant err-invalid-scriptpubkey (err u101))

(define-public (submit-commit
	(burn-height uint)
	(tx (buff 4096))
	(header (buff 80))
	(tx-index uint)
	(tree-depth uint)
	(txproof (list 14 (buff 32)))
  (compressed-pubkey (buff 33))
  (version (buff 1))
  (script (buff 128))
	(output-index uint)
	) 
	(let (
		(tx-data (try! (contract-call? .bitcoin-helper get-verified-tx-data
			burn-height
			tx
			header
			tx-index
			txproof
			tree-depth
      )))
		(selected-output (unwrap! (element-at? (get outs tx-data) output-index) err-invalid-output-index))
    (scriptPubKey (contract-call? .tapscript get-tapscript-scriptpubkey compressed-pubkey version script))
		)
    ;; (asserts! (is-eq scriptPubKey (get scriptPubKey selected-output)) err-invalid-scriptpubkey)
		;; TODO: print event
		(contract-call? .transaction-storage insert-new-commit (get txid tx-data) output-index selected-output)
	)
)
