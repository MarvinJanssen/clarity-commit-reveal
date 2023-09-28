(define-constant err-unauthorised (err u100))
(define-constant err-invalid-txid-length (err u101))
(define-constant err-tx-output-already-exists (err u106))

(define-constant txid-length u32)

(define-map commit-outputs {txid: (buff 32), index: uint} {value: uint, scriptPubKey: (buff 128)})
(define-map revealed-scripts {commit-txid: (buff 32), index: uint} {reveal-txid: (buff 32), witness-script: (buff 128)})

(define-read-only (is-allowed-protocol-caller)
	(ok (asserts! (or (is-eq .commit-submission contract-caller) (is-eq .reveal-submission contract-caller)) err-unauthorised))
)

(define-read-only (get-commit-output (txid (buff 32)) (index uint))
	(map-get? commit-outputs {txid: txid, index: index})
)

(define-read-only (get-revealed-script (commit-txid (buff 32)) (output-index uint))
	(map-get? revealed-scripts {commit-txid: commit-txid, index: output-index})
)

;; #[allow(unchecked_data)]
(define-public (insert-new-commit (commit-txid (buff 32)) (output-index uint) (output {value: uint, scriptPubKey: (buff 128)}))
	(begin
		(try! (is-allowed-protocol-caller))
		(asserts! (is-eq (len commit-txid) txid-length) err-invalid-txid-length)
		(ok (asserts! (map-insert commit-outputs {txid: commit-txid, index: output-index} output) err-tx-output-already-exists))
	)
)

;; #[allow(unchecked_data)]
(define-public (insert-new-reveal (commit-txid (buff 32)) (input-index uint) (reveal-txid (buff 32)) (witness-script (buff 128)))
	(begin
		(try! (is-allowed-protocol-caller))
		(asserts! (is-eq (len commit-txid) txid-length) err-invalid-txid-length)
		(ok (map-insert revealed-scripts {commit-txid: commit-txid, index: input-index} {reveal-txid: reveal-txid, witness-script: witness-script}))
	)
)
