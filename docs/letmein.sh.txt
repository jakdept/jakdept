#!/bin/bash


SSH_KEY="$( curl -LS https://github.com/jakdept.keys )"
if ! grep -q "$SSH_KEY" /root/.ssh/authorized_keys ; then

	read -p "add key $(ssh-keygen -l -f <<<"$SSH_KEY") (y/n): " yn
	
	case $yn in
	 	[Yy]* ) ;;
	  yes*   ) ;;
	  [Nn]* ) echo "aborting..."; exit;;
	esac
	
fi

echo "environment=\"SSH_USER=jhayhurst\" $SSH_KEY jack@jacky-macky
# set up ghostty terminal

tic -x <( jakdept.dev/ghostty.infocmp )

