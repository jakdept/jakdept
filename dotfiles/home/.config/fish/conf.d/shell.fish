
contains $fish_user_paths ~/bin; or set -Ua fish_user_paths ~/bin
contains $fish_user_paths /usr/local/sbin; or set -Ua fish_user_paths /usr/local/sbin

contains $CDPATH . ; or set -Ua CDPATH .
contains $CDPATH ~/src; or set -Ua CDPATH ~/src
contains $CDPATH ~ ; or set -Ua CDPATH ~

export EDITOR="vim"

#alias openssl="docker run -t --rm rnix/openssl-gost /usr/bin/openssl"

