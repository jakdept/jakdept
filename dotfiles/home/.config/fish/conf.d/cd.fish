# contains $CDPATH . ; or set -Ua CDPATH .
contains ~/src $CDPATH ; or set -Ua CDPATH ~/src
contains ~ $CDPATH ; or set -Ua CDPATH ~

# git repository greeter
set -e last_repository

function check_directory_for_new_repository
	set -gx current_repository (git rev-parse --show-toplevel 2> /dev/null)
	
	if [ "$current_repository" ] && \
	   [ "$current_repository" != "$last_repository" ]
		onefetch
	end
	set -gx last_repository $current_repository
end

function cd
	builtin cd $argv
	check_directory_for_new_repository
end

