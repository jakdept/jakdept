
contains $fish_user_paths ~/bin; or set -Ua fish_user_paths ~/bin
contains $fish_user_paths /usr/local/sbin; or set -Ua fish_user_paths /usr/local/sbin

# contains $CDPATH . ; or set -Ua CDPATH .
contains $CDPATH ~/src; or set -Ua CDPATH ~/src
contains $CDPATH ~ ; or set -Ua CDPATH ~

export EDITOR="vim"

#alias openssl="docker run -t --rm rnix/openssl-gost /usr/bin/openssl"

alias lpenter=enter
function ssl-check
	for domain in $argv
		echo |
		openssl s_client -connect $domain:443 -servername $domain -showcerts 2>/dev/null |
		openssl x509 -noout -subject -issuer -enddate -modulus
	end
end

# Defined in /usr/local/Cellar/fish/3.2.2_1/share/fish/functions/fish_greeting.fish @ line 1
function fish_greeting
    if not set -q fish_greeting
        set -l line1 (_ 'Welcome to fish, the friendly interactive shell')
        set -l line2 \n(printf (_ 'Type %shelp%s for instructions on how to use fish') (set_color green) (set_color normal))
        set -g fish_greeting "$line1$line2"
    end

    if set -q fish_private_mode
        set -l line (_ "fish is running in private mode, history will not be persisted.")
        set -g fish_greeting $fish_greeting.\n$line
    end

    # The greeting used to be skipped when fish_greeting was empty (not just undefined)
    # Keep it that way to not print superfluous newlines on old configuration
    test -n "$fish_greeting"
    and echo $fish_greeting
    and timeout 10s neofetch
end
