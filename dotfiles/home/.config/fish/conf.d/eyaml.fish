set -gx EYAML_CONFIG ~/.eyaml/production.config.yaml

alias eyaml-dev-encrypt="eyaml encrypt --pkcs7-public-key=$HOME/.eyaml/dev.public_key.pkcs7.pem"
alias eyaml-dev-decrypt="eyaml decrypt --pkcs7-private-key=$HOME/.eyaml/dev.private_key.pkcs7.pem --pkcs7-public-key=$HOME/.eyaml/dev.public-key.pkcs7.pem"
alias eyaml-staging-encrypt="eyaml encrypt --pkcs7-public-key=$HOME/.eyaml/staging.public_key.pkcs7.pem"
alias eyaml-staging-decrypt="eyaml decrypt --pkcs7-private-key=$HOME/.eyaml/staging.private_key.pkcs7.pem --pkcs7-public-key=$HOME/.eyaml/staging.public_key.pkcs7.pem"
