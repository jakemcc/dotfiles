syntax on
filetype on

"sets shell title to correct thing
set title

" bump up command history
set history=1000

" does good stuff with buffers
set hidden

" keep a bit of context around current cursor position
set scrolloff=5

set backupdir=/tmp
set directory=/tmp

if has('gui_running')
  " set default color scheme
  set background=light
  colorscheme desert 

  " turn off scrollbar
  set guioptions-=rL
endif

" make completion better
set wildmenu
set wildmode=list:longest
set wildignore+=*.o,*.obj,.git,.svn,*.jar,"help/**"

" invisible characters
set listchars=trail:.,tab:>-,eol:$
set nolist
:noremap ,i :set list!<CR> " Toggle invisible chars

" ignore case in searches, except if you type a capital letter
set ignorecase
set smartcase
set nohlsearch
set incsearch

" easy to source / edit this file
map ,s :source ~/.vimrc<CR>
map ,v :e ~/.vimrc<CR>

set go-=T " hide the toolbar by default
set nu " show line numbers
filetype plugin on " figure out filetype automatically
filetype indent on " indent based on filetype
set ruler " show ruler
set autoread " auto read updates to file from outside vim

" remove tabs for 2 spaces
set autoindent
set smartindent
set tabstop=2
set softtabstop=2
set shiftwidth=2
set expandtab
set smarttab
set cindent

" ack integration
set grepprg=ack\ -a
set swb=newtab " switch buffer mode opens a new tab

set showmatch
set matchtime=1

" rebuild ctags
map <silent> <LocalLeader>rt :!ctags -R --exclude=".git\|.svn\|log\|tmp\|db\|pkg" --extra=+f<CR> 

" show trailing whitespace
set listchars=tab:>-,trail:·,eol:$
nmap <silent> <leader>s :set nolist!<CR>

" turn off annoying messages
set shortmess=atI
