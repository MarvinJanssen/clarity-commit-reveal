(define-constant OP_0 0x00)
(define-constant OP_1 0x51)

(define-constant expected-program-length-byte 0x20)
(define-constant expected-taproot-header (some (concat OP_1 expected-program-length-byte)))
(define-constant expected-p2wsh-header (some (concat OP_0 expected-program-length-byte)))
(define-constant taproot-annex-a-prefix 0x50)

(define-constant err-witness-stack-too-small (err u200))
(define-constant err-p2wsh-wrong-version-or-length (err u201))
(define-constant err-p2wsh-script-hash-mismatch (err u202))

(define-read-only (verify-p2wsh-script-witness-program (program (buff 128)) (script-sha256 (buff 32)))
	(begin
		(asserts! (is-eq (slice? program u0 u2) expected-p2wsh-header) err-p2wsh-wrong-version-or-length)
		(ok (asserts! (is-eq (slice? program u2 u34) (some script-sha256)) err-p2wsh-script-hash-mismatch))
	)
)

(define-read-only (verify-taproot-script-witness-program (program (buff 128)) (witness-stack (list 8 (buff 128))))
	(begin
		(asserts! (is-eq (slice? program u0 u2) expected-taproot-header) err-p2wsh-wrong-version-or-length)
		(asserts! (is-eq (len witness-stack) u0) err-witness-stack-too-small)
		;; TODO: verify taproot witness script
		(ok true)
	)
)

(define-read-only (verify-script-witness-program (program (buff 128)) (witness-stack (list 8 (buff 128))))
	(if (is-eq (element-at? program u0) (some OP_1))
		(verify-taproot-script-witness-program program witness-stack)
		(verify-p2wsh-script-witness-program program (sha256 (unwrap! (element-at? witness-stack u0) err-witness-stack-too-small)))
	)
)
