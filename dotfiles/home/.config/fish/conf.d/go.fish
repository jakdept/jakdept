set -x GOROOT "/usr/local/go" #set goroot
set -x GOPATH "$HOME" # set GOPATH
set PATH $PATH /usr/local/go/bin
set CGO_ENABLED "0"
function update-go
	sudo rm -rf /usr/local/go
	lynx -dump -listonly -nonumbers https://golang.org/dl |
	grep (uname -s|tr '[:upper:]' '[:lower:]') |
	grep amd64 |
	grep tar.gz |
	head -n1 |
	xargs curl -sSL -o- |
	sudo tar -C /usr/local -zx
end

function gohttpdoc
	lsof -i :6060|tail -n +2|awk '{print $2}'|xargs kill
	nohup godoc -http localhost:6060 &>/dev/null &
end
