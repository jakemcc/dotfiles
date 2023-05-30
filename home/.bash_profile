if [ -h $HOME/.bashrc ]; then
  source $HOME/.bashrc
fi

if which jenv > /dev/null ; then
    export PATH="$HOME/.jenv/bin:$PATH"
    eval "$(jenv init -)"
fi

# if command -v pyenv >/dev/null; then 
#     export PYENV_ROOT="${HOME}/.pyenv"
#     export PATH="${PYENV_ROOT}/bin:$PATH"
#     eval "$(pyenv init -)"
# fi

# from https://github.com/rcaloras/bash-preexec
# shellcheck source=/dev/null
[[ -f "$HOME/.bash-preexec.sh" ]] && source "$HOME/.bash-preexec.sh"

[ -s "/Users/jmccrary/.scm_breeze/scm_breeze.sh" ] && source "/Users/jmccrary/.scm_breeze/scm_breeze.sh"
