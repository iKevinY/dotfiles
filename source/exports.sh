export EDITOR="vim"

# Larger bash history (allow 32³ entries; default is 500)
export HISTSIZE=32768
export HISTFILESIZE=$HISTSIZE
# Ignore duplicate entries and commands with leading spaces
export HISTCONTROL=ignoreboth
# Make some commands not show up in history
export HISTIGNORE="ls:cd:cd -:pwd:exit:date:* --help"

# Prefer Canadian English and use UTF-8
export LANG="en_CA"
export LC_ALL="en_CA.UTF-8"

# Highlight section titles in manual pages
export LESS_TERMCAP_md="$ORANGE"

# Don’t clear the screen after quitting a manual page
export MANPAGER="less -X"

# Always enable colored `grep` output
export GREP_OPTIONS="--color=auto"

# Link Homebrew casks in `/Applications` rather than `~/Applications`
export HOMEBREW_CASK_OPTS="--appdir=/Applications"

# More convenient trigger sequence for fzf
export FZF_COMPLETION_TRIGGER=','

# Add previews to fzf shortcuts
export FZF_CTRL_T_OPTS="--preview '(highlight -O ansi -l {} 2> /dev/null || cat {} || tree -C {}) 2> /dev/null | head -200'"
export FZF_DEFAULT_OPTS='--height 80% --preview-window right:70%'

# Use ripgrep for fzf if installed
if command -v rg >/dev/null 2>&1; then
	export FZF_DEFAULT_COMMAND='rg --files --no-ignore --hidden --follow --glob "!.git/*"'
fi
