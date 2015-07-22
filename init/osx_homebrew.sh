#!/usr/bin/env bash

# OSX-only stuff. Abort if not OSX.
is_osx || return 1

# Install Homebrew.
if [[ ! "$(type -P brew)" ]]; then
  e_header "Installing Homebrew"
  true | ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

# Exit if, for some reason, Homebrew is not installed.
[[ ! "$(type -P brew)" ]] && e_error "Homebrew failed to install." && return 1

e_header "Updating Homebrew"
brew doctor
brew update


##################
# Helper Functions
##################

# Tap Homebrew kegs.
function brew_tap_kegs() {
  kegs=($(setdiff "${kegs[*]}" "$(brew tap)"))
  if (( ${#kegs[@]} > 0 )); then
    e_header "Tapping Homebrew kegs: ${kegs[*]}"
    for keg in "${kegs[@]}"; do
      brew tap "$keg"
    done
  fi
}

# Install Homebrew formulae.
function brew_install_formulae() {
  formulae=($(setdiff "${formulae[*]}" "$(brew list)"))
  if (( ${#formulae[@]} > 0 )); then
    e_header "Installing Homebrew formulae: ${formulae[*]}"
    for recipe in "${formulae[@]}"; do
      brew install "$recipe"
    done
  fi
}


#######
# Casks
#######

# Ensure the cask keg and formula are installed.
kegs=(caskroom/cask caskroom/versions caskroom/fonts)
brew_tap_kegs
formulae=(brew-cask)
brew_install_formulae

# Hack to show the first-run brew-cask password prompt immediately.
brew cask info this-is-somewhat-annoying 2>/dev/null

# Read list of Homebrew casks from /conf/casks.txt (ignoring commented lines).
readarray casks < <(grep -v '^$\|^\s*\#' "${DOTFILES}/conf/casks.txt")

# Install Homebrew casks.
casks=($(setdiff "${casks[*]}" "$(brew cask list 2>/dev/null)"))
if (( ${#casks[@]} > 0 )); then
  e_header "Installing Homebrew casks: ${casks[*]}"
  for cask in "${casks[@]}"; do
    brew cask install "$cask"
  done
  brew cask cleanup
fi

# Work around colorPicker symlink issue.
# https://github.com/caskroom/homebrew-cask/issues/7004
cps=()
for f in ~/Library/ColorPickers/*.colorPicker; do
  [[ -L "$f" ]] && cps=("${cps[@]}" "$f")
done

if (( ${#cps[@]} > 0 )); then
  e_header "Fixing colorPicker symlinks"
  for f in "${cps[@]}"; do
    target="$(readlink "$f")"
    e_arrow "$(basename "$f")"
    rm "$f"
    cp -R "$target" ~/Library/ColorPickers/
  done
fi


##########
# Formulae
##########

# Read list of Homebrew casks from /conf/formulae.txt (ignoring commented lines).
readarray formulae < <(grep -v '^$\|^\s*\#' "${DOTFILES}/conf/formulae.txt")

brew_install_formulae

# Misc cleanup!

# This is where brew stores its binary symlinks
local binroot="$(brew --config | awk '/HOMEBREW_PREFIX/ {print $2}')"/bin

# bash
if [[ $(type -P "$binroot/bash") && $(grep -q "$binroot/bash" /etc/shells) ]]; then
  e_header "Adding $binroot/bash to the list of acceptable shells"
  echo "$binroot/bash" | sudo tee -a /etc/shells >/dev/null
fi
if [[ "$(dscl . -read ~ UserShell | awk '{print $2}')" != "$binroot/bash" ]]; then
  e_header "Making $binroot/bash your default shell"
  sudo chsh -s "$binroot/bash" "$USER" >/dev/null 2>&1
  e_arrow "Please exit and restart all your shells."
fi
