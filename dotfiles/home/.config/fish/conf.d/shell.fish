
contains $fish_user_paths ~/bin; or set -Ua fish_user_paths ~/bin

export LESSOPEN="|/usr/local/bin/lesspipe.sh %s" LESS_ADVANCED_PREPROCESSOR=1

contains $CDPATH . ; or set -Ua CDPATH .
contains $CDPATH ~/src; or set -Ua CDPATH ~/src
contains $CDPATH ~ ; or set -Ua CDPATH ~

#alias openssl="docker run -t --rm rnix/openssl-gost /usr/bin/openssl"

