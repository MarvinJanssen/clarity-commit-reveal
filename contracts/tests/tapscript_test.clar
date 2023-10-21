
(define-read-only (x-only (pubkey (buff 33)))
  (contract-call? .tapscript x-only pubkey))

(define-read-only (get-tap-leaf (data (buff 128)))
  (contract-call? .tapscript get-tap-leaf data))

(define-read-only (get-tap-tweak (data (buff 128)))
  (contract-call? .tapscript get-tap-tweak data))



;; pubkey: 0x1340a0cdc67100268fd325ff41ddc736e7fc2b078526758633e0c2d260fd1afa
;; version: 0xc0
;; script: 0x519fb620bed0d5dada5f4ccf61024ba8500fc9bd95af04ff34fe0d5a5ddc37cc
(define-read-only (get-tapscript-tweak-test-1)
  (let (
    (version 0xc0)
    (script 0x519fb620bed0d5dada5f4ccf61024ba8500fc9bd95af04ff34fe0d5a5ddc37cc)
    (pubkey 0x031340a0cdc67100268fd325ff41ddc736e7fc2b078526758633e0c2d260fd1afa)
    (x-only-pubkey (x-only pubkey))
    
    (tapleaf (get-tap-leaf (unwrap-panic (as-max-len? (concat version script) u128))))
    (tap-tweak (get-tap-tweak (unwrap-panic (as-max-len? (concat x-only-pubkey tapleaf) u128))))
    ;; (tweaked-key (contract-call? .point tweak-pubkey-hex tap-tweak compressed-pubkey))
    (tweaked-key 0x032fff4d7278bb2ab1c7c7b768f264c8a0d4113312e4d55b19f2af85e7a0af0682)
    ;; (x-only-tweaked-key (x-only tweaked-key))
    ;; (tweak-key-parity (read-parity-bit tweaked-key))
    ;; (c-bit (get-control-bit version tweak-key-parity))
    ;; (cblock (concat c-bit x-only-pubkey))
  )
    ;; (get-tapscript-tweak 0x1340a0cdc67100268fd325ff41ddc736e7fc2b078526758633e0c2d260fd1afa 0xc0 0x519fb620bed0d5dada5f4ccf61024ba8500fc9bd95af04ff34fe0d5a5ddc37cc)
    ;; { tweaked-pubkey: x-only-tweaked-key, cblock: cblock }
    (concat 0x5120 (x-only tweaked-key))
  ))

;; testnet txid: 98f945641dbe22de5d66165bb1da90461ef4bd4963b3c5d438e5ed3afc3e2bcc
(define-read-only (get-tapscript-tweak-test-2)
  (let (
    (version 0xc0)
    (script 0x3c183c001a7321b74e2b6a7e949e6c4ad313035b1665095017007520e1d3413dade623aa179992d8902bab5695c34bdfab306322992005fe62387bcfac)
    (pubkey 0x02e1d3413dade623aa179992d8902bab5695c34bdfab306322992005fe62387bcf)
    (x-only-pubkey (x-only pubkey))
    
    (tapleaf (get-tap-leaf (unwrap-panic (as-max-len? (concat version script) u128))))
    (tap-tweak (get-tap-tweak (unwrap-panic (as-max-len? (concat x-only-pubkey tapleaf) u128))))
    ;; (tweaked-key (contract-call? .point tweak-pubkey-hex tap-tweak compressed-pubkey))
    (tweaked-key 0x02d9a118ecbf36c85e844af80d26b9cb8e461075c9bac9d54a07da44b05c10c4af)
    ;; (x-only-tweaked-key (x-only tweaked-key))
    ;; (tweak-key-parity (read-parity-bit tweaked-key))
    ;; (c-bit (get-control-bit version tweak-key-parity))
    ;; (cblock (concat c-bit x-only-pubkey))
  )
    ;; (get-tapscript-tweak 0x1340a0cdc67100268fd325ff41ddc736e7fc2b078526758633e0c2d260fd1afa 0xc0 0x519fb620bed0d5dada5f4ccf61024ba8500fc9bd95af04ff34fe0d5a5ddc37cc)
    ;; { tweaked-pubkey: x-only-tweaked-key, cblock: cblock }
    (concat 0x5120 (x-only tweaked-key))
  ))