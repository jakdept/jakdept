function terminfo-ghostty
	infocmp -x | ssh "$argv[1]" -- "tic -x -"
end
