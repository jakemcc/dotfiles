# Bootstrap my dotfiles (instructions for OSX)

1. Install [homebrew](https://brew.sh/)
1. `brew install mr`
1. Install KeePassX
1. Setup ssh keys
1. `mr --trust-all bootstrap https://raw.githubusercontent.com/jakemcc/dotfiles/master/home/.mrconfig`
1. `$HOME/.homesick/repos/homeshick/bin/homeshick link`

## Steps for new OS X machine post above steps

1. `open ~/.fonts/Inconsolata.otf`
1. Download [iterm2](https://www.iterm2.com/)
1. Download [Solarized colors](http://ethanschoonover.com/solarized)
1. Setup iTerm2 to use Solarized + Inconsolata
1. Install JDK
1. [Docker for Mac](https://www.docker.com/docker-mac) and bump up memory settings
1. Turn on FileVault encryption
1. Get secrets from backup

```
brew install hh
brew cask install emacs
brew install gnupg2
brew install fasd
brew install aspell
brew install awscli
brew install bash-completion
brew install chruby
brew install clojure
brew install git-crypt
brew install gnu-sed
brew install multimarkdown
brew install pgcli
brew install phantomjs
brew install reattach-to-user-namespace
brew install ruby-install
brew install selecta
brew install shellcheck
brew install siege
brew install ssh-copy-id
brew install terminal-notifier
brew install the_silver_searcher
brew install tmate
brew install wget
ruby-install ruby-2.3 # or something like this
homeshick cd dotfiles && git-crypt unlock
```



