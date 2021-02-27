
#alias ls="logo-ls"

function ls --wraps ls --description 'alias ls=logo-ls'
	if isatty stdout
		logo-ls $argv
	else
		/usr/bin/env ls $argv
	end
end


