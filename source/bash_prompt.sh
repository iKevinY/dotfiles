if [ -f /usr/local/share/liquidprompt ]; then
    . /usr/local/share/liquidprompt
elif [ -f /usr/local/bin/liquidprompt ]; then
  . /usr/local/bin/liquidprompt
else
  GRY="\[\e[38;5;241m\]"
  BLU="\[\e[0;34m\]"
  RED="\[\e[1;32m\]"
  GRN="\[\e[1;31m\]"
  YLW="\[\e[0;33m\]"
  CLR="\[\e[0m\]"

  # Green $ if previous exit code was 0, else red
  function prompt_exitcode() {
    [[ $1 == 0 ]] && echo " $RED\$$CLR " || echo " $GRN\$$CLR "
  }

  # Git status.
  function prompt_git() {
    local status output flags branch
    status="$(git status 2>/dev/null)"
    [[ $? != 0 ]] && return;
    output="$(echo "$status" | awk '/# Initial commit/ {print "(init)"}')"
    [[ "$output" ]] || output="$(echo "$status" | awk '/# On branch/ {print $4}')"
    [[ "$output" ]] || output="$(git branch | perl -ne '/^\* \(detached from (.*)\)$/ ? print "($1)" : /^\* (.*)/ && print $1')"
    flags="$(
      echo "$status" | awk 'BEGIN {r=""} \
          /^(# )?Changes to be committed:$/        {r=r "+"}\
          /^(# )?Changes not staged for commit:$/  {r=r "!"}\
          /^(# )?Untracked files:$/                {r=r "?"}\
        END {print r}'
    )"
    if [[ "$flags" ]]; then
      output="$output$c1:$c0$flags"
    fi
    echo " $YLW($output)$CLR"
  }

  # Maintain a per-execution call stack.
  prompt_stack=()
  trap 'prompt_stack=("${prompt_stack[@]}" "$BASH_COMMAND")' DEBUG

  function prompt_command() {
    local exit_code=$?
    # If the first command in the stack is prompt_command, no command was run.
    # Set exit_code to 0 and reset the stack.
    [[ "${prompt_stack[0]}" == "prompt_command" ]] && exit_code=0
    prompt_stack=()

    # While the simple_prompt environment var is set, disable the awesome prompt.
    [[ "$simple_prompt" ]] && PS1='\n$ ' && return

    # time [HH:MM:SS]
    PS1="$GRY[\t]"

    # current virtualenv
    if [[ "$VIRTUAL_ENV" ]]; then
      PS1="$PS1 ($(basename "$VIRTUAL_ENV"))"
    fi

    # path
    PS1="$PS1 $BLU\w$CLR"

    # git: [branch:flags]
    PS1="$PS1$(prompt_git)"

    # exit code $
    PS1="$PS1$(prompt_exitcode "$exit_code")"
  }

  PROMPT_COMMAND="prompt_command"
fi

PS2="\[\033[38;5;000m\]⋯\[\033[0m\] "
