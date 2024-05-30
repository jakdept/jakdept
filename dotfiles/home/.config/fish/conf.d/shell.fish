
fish_add_path ~/bin
fish_add_path /usr/local/sbin
fish_add_path /usr/local/opt/openssl@3/bin
fish_add_path /opt/homebrew/bin
fish_add_path /opt/homebrew/sbin
fish_add_path /opt/homebrew/opt/ansible@8/bin

# contains $fish_user_paths ~/bin; or set -Ua fish_user_paths ~/bin
# contains $fish_user_paths /usr/local/sbin; or set -Ua fish_user_paths /usr/local/sbin

export EDITOR="vim"

#alias openssl="docker run -t --rm rnix/openssl-gost /usr/bin/openssl"

alias lpenter=enter

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
    and timeout 8s neofetch --disable term_font
end
