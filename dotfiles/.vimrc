""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"
" Some referance for more information about how to setup the .vimrc file
"       The Vim Editor - http://www.vim.org
"       Vim Recipes - http://vim.runpaint.org/toc/
"
" Much of this .vimrc file was taken from:
"       http://www.terminally-incoherent.com/blog/2012/03/26/how-to-configure-vim/
"       http://amix.dk/blog/post/19691#The-ultimate-Vim-configuration-on-Github
"       http://hackr.se/vim/vimrc/
"
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""



""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"       General
"
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" set lines=80          " number of lines in the terminal window when vi opens
" set columns=100               " number of columns in the terminal window when vi opens
set nocompatible        " not compatible with the old-fashion vi mode
set bs=2                        " allow backspacing over everything in insert mode
set autoread            " auto read when file is changed from outside
set hidden                      " buffers can exist in background

set ruler                       " show the cursor position all the time
"set number                     " enable numbers
"set cursorline         " show line marker
"set cursorcolumn       " show column markers

" use colored highlighting for file types recognized
syntax on                       " Enable syntax highlighting
filetype on                     " Enable filetype detection
filetype indent on      " Enable filetype-specific indenting
filetype plugin on      " Enable filetype-specific plugins
filetype plugin indent on

set history=200         " Sets how many command line history VIM has to remember



""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"  Spell Checking
"
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"set spell                      " enable inline spell check; 'z=' will provide spelling
"set spelllang=en
"map <leader>ss :setlocal spell!<cr> " Pressing ,ss will toggle and untoggle spell checking



""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"       VIM User Interface
"
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" vim will show a block cursor in normal mode and a line cursor in insert mode
let &t_ti.="\e[1 q"
let &t_SI.="\e[5 q"
let &t_EI.="\e[1 q"
let &t_te.="\e[0 q"

set mouse=a                     " Enable mouse usage; to paste, press shift while seleting with the mouse

" Configure backspace so it acts as it should act
set backspace=eol,start,indent
set whichwrap+=<,>,h,l

set lazyredraw          " Don't redraw while executing macros
set magic                       " For regular expressions turn magic on
set showcmd                     " Show (partual) commands in status line

set showmatch           " Show matching brackets when text indicator is over them
set mat=2                       " tenths of a second to blink when matching brackets

set title                                                                       "Show info in the window title
set titlestring=Cygwin\ Vim\ Editor:\ %F        "Automatically set screen title

" No annoying sound ot flashing on errors
" set noerrorbells              " turn of beeping when errors occure
" set novisualbell              " turn off screen flashing when errors occure
" set t_vb=                             " If 't_vb' is cleared, Vim will never flash the screen
" set tm=500



""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"       Searching
"
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set hlsearch            " Highlight search results, to clear type :noh and hit enter
set incsearch           " incremental search
set ignorecase          " Do case insensitive matching
set smartcase           " Do smart case matching
nmap <silent> <leader><space> :nohlsearch<CR>   "pressing \<space> clears the search highlights



""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"  Indentation
"
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set copyindent          " copy previous indent on enter

"Indent only if the file is of type cpp,c,java,sh,pl,php,asp
au FileType cpp,c,java,sh,pl,php,asp  set autoindent
au FileType cpp,c,java,sh,pl,php,asp  set smartindent
au FileType cpp,c,java,sh,pl,php,asp  set cindent               " C type indentation



""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"  Text and Tabs
"
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"set expandtab          " Use spaces instead of tabs
"set shiftwidth=4       " 1 tab equals 4 spaces
set smarttab            " Be smart when using tabs
set tabstop=4           " set tab stops ever 4 character spaces

" Cool tab completion stuff
set wildmenu
set wildmode=list:longest,full

set wrap                        " Wrap lines
set tw=500                      " Linebreak on 500 characters
set lbr
set formatoptions=1



""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"  Colors and Fonts
"
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"set guifont=Times_New_Roman:h11:cANSI
"set guifont=courier_new:h11:b
set guifont=Lucida_Console:h8:cDEFAULT

colorscheme desert
set background=dark

" Set extra options when running in GUI mode
if has("gui_running")
        set guioptions-=T
        set guioptions+=e
        set t_Co=256
        set guitablabel=%M\ %t
endif

" Set utf8 as standard encoding and en_US as the standard language
set encoding=utf8

" Use Unix as the standard file type
set ffs=unix,dos,mac



""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"   Files, Backups, and Undo
"
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" set nobackup
" set nowb                      " Prevents automatic write backup before overwritng file
" set nobk                      " Prevents keeping of backup after overwriting the file
" set noswapfile

" Keep temporary and backup files (make sure to create these directories first)
set backup
set backupdir=~/.vim/backup
set directory=~/.vim/tmp



""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"  Abbreviations
"
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
ab #c /****************************************************************************/
ab #v """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
ab #s ##############################################################################



""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"   Mapping Keys
"
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""



""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"  Status Line
"
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Format the status line
set statusline=\ %{HasPaste()}%F%m%r%h\ %w\ \ CWD:\ %r%{getcwd()}%h\ \ \ Line:\ %l\ \ \ Column:\ %c
set laststatus=2 " Always show the status line



""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"  Helper Functions
"
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Returns true if paste mode is enabled
function! HasPaste()
    if &paste
          return 'PASTE MODE  '
    en
    return ''
endfunction
