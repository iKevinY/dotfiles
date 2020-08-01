if [ -f ~/.bashrc ]; then
  source ~/.bashrc
fi

export PATH="$HOME/.cargo/bin:$PATH"
if command -v pyenv 1>/dev/null 2>&1; then
  eval "$(pyenv init -)"
fi

[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*

export PATH="$HOME/.poetry/bin:$PATH"

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/ikeviny/src/google-cloud-sdk/path.bash.inc' ]; then . '/Users/ikeviny/src/google-cloud-sdk/path.bash.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/ikeviny/src/google-cloud-sdk/completion.bash.inc' ]; then . '/Users/ikeviny/src/google-cloud-sdk/completion.bash.inc'; fi
