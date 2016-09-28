# -*- mode: Shell-script; -*-

# environment -------------------------------------------------

# scm
export EDITOR='emacs'

# setup some completions
source "$HOME/.bash/lein_bash_completion.bash"

# setup MYOS env variable, some colors defined
source "$HOME/.bash/environment"

# get some useful functions
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

# aliases -----------------------------------------------------

alias realias="$EDITOR $HOME/.aliases; source $HOME/.aliases"
source ~/.aliases


# paths -------------------------------------------------------

my_pathmunge "/usr/local/sbin"
my_pathmunge "/usr/local/bin"
my_pathmunge "$HOME/bin"
my_pathmunge "$HOME/.bin"
my_pathmunge "$HOME/opt/bin"


# load OS specific stuff --------------------------------------

[[ -f "$HOME/.bash/$MACHINENAME" ]] && source "$HOME/.bash/$MACHINENAME"
[[ -f "$HOME/.bash/$MACHINENAME.private" ]] && source "$HOME/.bash/$MACHINENAME.private"
[[ -f "$HOME/.bash/$MYOS" ]] && source "$HOME/.bash/$MYOS"

function timer_start {
  timer=${timer:-$SECONDS}
}

function timer_stop {
  timer_show=$(($SECONDS - $timer))
  unset timer
}


trap 'timer_start' DEBUG

if [ "$PROMPT_COMMAND" == "" ]; then
  PROMPT_COMMAND="timer_stop"
else
  PROMPT_COMMAND="$PROMPT_COMMAND; timer_stop"
fi

# History stuff from http://unix.stackexchange.com/questions/200225/search-history-from-multiple-bash-session-only-when-ctrl-r-is-used-not-when-a
# Whenever a command is executed, write it to a global history
PROMPT_COMMAND="history -a ~/.bash_history.global; $PROMPT_COMMAND"

# On C-r run the history.sh script
bind -x '"\C-r": "~/.bin/history.sh"'

# set PS1 with git completions --------------------------------
GIT_PS1_SHOWDIRTYSTATE=true
GIT_COMPLETION=$HOME/.bash/bash_completion.d/git-completion.bash
if [ -f $GIT_COMPLETION ]; then
  . $GIT_COMPLETION
  export PS1='\[\033[00m\]$? [last: ${timer_show}s] \[\033[0;31m\]$(date +%T) \[\033[01;34m\]\w\[\033[00m\]\[\033[01;32m\]$(__git_ps1 " (%s)")\[\033[00m\] $OUTPACE_ENV\n$ '
fi

[[ -f "$HOME/.scm_breeze/scm_breeze.sh" ]] && source "$HOME/.scm_breeze/scm_breeze.sh"

[[ -f "/usr/local/opt/chruby/share/chruby/chruby.sh" ]] && source /usr/local/opt/chruby/share/chruby/chruby.sh
[[ -f "/usr/local/share/chruby/auto.sh" ]] && source /usr/local/share/chruby/auto.sh
function_exists chruby && chruby ruby-2.3.0


# Script for ensuring only one instance of gpg-agent is running
# and if there is not one, start an instance of gpg-agent.
if test -f $HOME/.gpg-agent-info && kill -0 `cut -d: -f 2 $HOME/.gpg-agent-info` 2>/dev/null; then
  GPG_AGENT_INFO=`cat $HOME/.gpg-agent-info`
  #SSH_AUTH_SOCK=`cat $HOME/.ssh-auth-sock`
  #SSH_AGENT_PID=`cat $HOME/.ssh-agent-pid`
  export GPG_AGENT_INFO
  #export SSH_AUTH_SOCK
  #export SSH_AGENT_PID
else
  if hash gpg-agent 2> /dev/null; then
    eval `gpg-agent --daemon --write-env-file "$HOME/.gpg-agent-info"`
    echo $GPG_AGENT_INFO >$HOME/.gpg-agent-info
    #echo $SSH_AUTH_SOCK > $HOME/.ssh-auth-sock
    #echo $SSH_AGENT_PID > $HOME/.ssh-agent-pid
  fi
fi
# Imperative that this environment variable always reflects the output
# of the tty command.
GPG_TTY=`tty`
export GPG_TTY

export ANSIBLE_COW_SELECTION=small

if which pyenv > /dev/null; then eval "$(pyenv init -)"; fi

if [ -d "$HOME/.homesick" ]; then
  source "$HOME/.homesick/repos/homeshick/homeshick.sh"
  source "$HOME/.homesick/repos/homeshick/completions/homeshick-completion.bash"
else
  echo "Install homeshick https://github.com/andsens/homeshick"
fi
source /usr/local/bin/virtualenvwrapper.sh
