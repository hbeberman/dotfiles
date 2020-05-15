#!/bin/bash

function syncNow() {
	rsync --exclude ".git/" \
	--exclude "apply.sh"    \
	--exclude "extras/"     \
	-avh --no-perms . ~;
}

syncNow;
