set GPG_TTY (who | grep (id -un) | awk '{print "/dev/" $2}')
set SSH_AUTH_SOCK (gpgconf --list-dirs agent-ssh-socket)
gpgconf --launch gpg-agent

function yk-reset
	/usr/bin/env gpg --card-status 2>/dev/null |
		awk -F: '/Name of cardholder/ {print $NF}' |
		sed '/^$/d' |
		xargs -I{} git config --global user.name "{}"
	/usr/bin/env gpg --card-status 2>/dev/null |
		awk -F: '/Login data/ {gsub(" ", "", $NF);print $NF}' |
		sed '/^$/d' |
		xargs -I{} git config --global user.email "{}"
end

function yk-keys
  gpg --list-secret-keys | awk '{
		if ($1 == "sec#" ) {
			gsub(/.*\//, "", $2); keyid=$2; 
		} else if ($1 == "uid") {
			$1="";
			print keyid, $0;
		};
	}'
end

function yk-ssh
	/usr/bin/env ssh-add -L
end

function yk-gpg
	yk-keys |awk '{print $1}'| xargs -I{} gpg --armor --export {}
end

function yk-encrypt
  # example:
  # ╰─> gyk-encrypt 0x91BB20A6F956A176 ~/.config/reason.key
	gpg --encrypt --armor --output=- --recipient $argv
end

function yk-decrypt
  # example:
  # ╰─> yk-decrypt ~/Downloads/reason.key.asc
	gpg --decrypt $argv
end
