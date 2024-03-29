# -*- mode: Shell-script; -*-

# environment -------------------------------------------------

if [ -f "/Applications/Emacs.app/Contents/MacOS/Emacs" ]; then
  export EMACS="/Applications/Emacs.app/Contents/MacOS/Emacs"
  alias emacs="$EMACS -nw"
fi

if [ -f "/Applications/Emacs.app/Contents/MacOS/bin/emacsclient" ]; then
  alias emacsclient="/Applications/Emacs.app/Contents/MacOS/bin/emacsclient"
fi

# scm
export EDITOR='emacs -nw'

# setup MYOS env variable, some colors defined
# shellcheck source=/dev/null
source "$HOME/.bash/environment"

# get some useful functions
# shellcheck source=/dev/null
source "$HOME/.bash/functions"

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# ignore some directories
export FIGNORE=.svn:.svp:.bak:~
shopt -u force_fignore

# fix typos
shopt -s cdspell

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# color the terminal
export CLICOLOR=1
export LSCOLORS=gxfxcxdxbxegedabagacad

export HISTFILESIZE=10000
export HISTIGNORE="&:[ ]*:exit"
shopt -s histappend

alias hh=hstr                    # hh to be alias for hstr
export HSTR_CONFIG=hicolor       # get more colors
shopt -s histappend              # append new history items to .bash_history
export HISTCONTROL=ignorespace   # leading space hides commands from history
export HISTFILESIZE=10000        # increase history file size (default is 500)
export HISTSIZE=${HISTFILESIZE}  # increase history size (default is 500)

# if this is interactive shell, then bind hstr to Ctrl-r (for Vi mode check doc)
if [[ $- =~ .*i.* ]]; then bind '"\C-r": "\C-a HISTFILE=~/.bash_history.global hstr -- \C-j"'; fi
# if this is interactive shell, then bind 'kill last command' to Ctrl-x k
if [[ $- =~ .*i.* ]]; then bind '"\C-xk": "\C-a HISTFILE=~/.bash_history.global hstr -k \C-j"'; fi

# aliases -----------------------------------------------------

alias realias="\$EDITOR \$HOME/.aliases; source \$HOME/.aliases"
# shellcheck source=/dev/null
source ~/.aliases


# paths -------------------------------------------------------

my_pathmunge "/usr/local/sbin"
my_pathmunge "/usr/local/bin"
my_pathmunge "$HOME/bin"
my_pathmunge "$HOME/.bin"
my_pathmunge "$HOME/opt/bin"
my_pathmunge "$HOME/local/bin"
my_pathmunge "/opt/homebrew/bin"

[[ -r "/opt/homebrew/etc/profile.d/bash_completion.sh" ]] && . "/opt/homebrew/etc/profile.d/bash_completion.sh"

# load OS specific stuff --------------------------------------

# shellcheck source=/dev/null
[[ -f "$HOME/.bash/$MACHINENAME" ]] && source "$HOME/.bash/$MACHINENAME"
# shellcheck source=/dev/null
[[ -f "$HOME/.bash/$MACHINENAME.private" ]] && source "$HOME/.bash/$MACHINENAME.private"
# shellcheck source=/dev/null
[[ -f "$HOME/.bash/$MYOS" ]] && source "$HOME/.bash/$MYOS"

show_pair() {
    if test -f ~/.pair-state.edn
    then
        output=$(wc -m ~/.pair-state.edn | awk '{print $1}')
        if [[ "$output" != "2" ]]; then
            echo -n "👥"
        fi
    fi
    echo -n ""
}

# Using https://github.com/rcaloras/bash-preexec
preexec() {
  _last_command=$1
  if [ "UNSET" == "${_timer}" ]; then
    _timer=$SECONDS
  else 
    _timer=${_timer:-$SECONDS}
  fi 
}

_maybe_speak() {
    local elapsed_seconds=$1
    # if (( elapsed_seconds > 30 )); then
    #     local c
    #     c=$(echo "${_last_command}" | cut -d' ' -f1)
    #     ( say "finished ${c}" & )
    # fi
}

precmd() {
  if [ "UNSET" == "${_timer}" ]; then
     timer_show="0s"
  else 
    elapsed_seconds=$((SECONDS - _timer))
    _maybe_speak ${elapsed_seconds}
    timer_show="$(format-duration seconds $elapsed_seconds)"
  fi
  _timer="UNSET"

  # History stuff from http://unix.stackexchange.com/questions/200225/search-history-from-multiple-bash-session-only-when-ctrl-r-is-used-not-when-a
  # Whenever a command is executed, write it to a global history
  history -a ~/.bash_history.global
  echo -ne "\033]0;${PWD##*/}\007"
}

# set PS1 with git completions --------------------------------
GIT_PS1_SHOWDIRTYSTATE=true
GIT_COMPLETION="${HOME}/.bash/bash_completion.d/git-completion.bash"
GIT_PROMPT="${HOME}/.bash/git-prompt.sh"
PROMPT_DIRTRIM=2
if [ -e "$GIT_COMPLETION" ]; then
  # shellcheck source=/dev/null
  . "$GIT_COMPLETION"
  if [ -e "$GIT_PROMPT" ]; then
      # shellcheck source=/dev/null
      . "$GIT_PROMPT"
      export PS1='\[\033[00m\]$? [last: ${timer_show}] \[\033[0;31m\]$(date +%T) \[\033[01;34m\]\w\[\033[00m\]\[\033[01;32m\]$(__git_ps1 " (%s)")\[\033[00m\] $(show_pair)\n$ '
  fi
else
    echo "${GIT_COMPLETION} does not exist?"
fi

# Makefile completions
complete -W "\`grep -oE '^[a-zA-Z0-9_.-]+:([^=]|$)' Makefile | sed 's/[^a-zA-Z0-9_.-]*$//'\`" make

# shellcheck source=/dev/null
[[ -f "$HOME/.scm_breeze/scm_breeze.sh" ]] && source "${HOME}/.scm_breeze/scm_breeze.sh"

# shellcheck source=/dev/null
[[ -f "/usr/local/opt/chruby/share/chruby/chruby.sh" ]] && source /usr/local/opt/chruby/share/chruby/chruby.sh
# shellcheck source=/dev/null
[[ -f "/usr/local/share/chruby/auto.sh" ]] && source /usr/local/share/chruby/auto.sh
function_exists chruby && chruby ruby-2.6.3

# Imperative that this environment variable always reflects the output
# of the tty command.
GPG_TTY=$(tty)
export GPG_TTY

if [ -d "$HOME/.homesick" ]; then
  # shellcheck source=/dev/null
  source "$HOME/.homesick/repos/homeshick/homeshick.sh"
  # shellcheck source=/dev/null
  source "$HOME/.homesick/repos/homeshick/completions/homeshick-completion.bash"
else
  echo "Install homeshick https://github.com/andsens/homeshick"
fi

# shellcheck source=/dev/null
[ -f /usr/local/etc/bash_completion ] && source /usr/local/etc/bash_completion

# shellcheck source=/dev/null
for f in ~/.bash/bash_completion.d/*; do source "${f}"; done

export RIPGREP_CONFIG_PATH="$HOME/.ripgreprc"

[ -s "/Users/jmccrary/.scm_breeze/scm_breeze.sh" ] && source "/Users/jmccrary/.scm_breeze/scm_breeze.sh"

export LSP_USE_PLISTS=true
