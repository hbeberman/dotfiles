#!/bin/bash

function syncNow() {
	rsync --exclude ".git/" \
	--exclude "apply.sh"    \
	--exclude "extras/"     \
	-avh --no-perms . ~;
}

syncNow;

git config --global user.email "henry.beberman@microsoft.com"
git config --global user.name "Henry Beberman"
git config --global core.editor "vim"
