#!/bin/sh

if test ! "$(which brew)"; then
	if test "$(uname)" = "Darwin"; then
		ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
	elif test "$(expr substr $(uname -s) 1 5)" = "Linux"; then
		ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/linuxbrew/go/install)"
	else
		echo "Unknown platform."
	fi
else
	echo "Homebrew is already installed."
fi
