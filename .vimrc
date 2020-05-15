"======== UI ================
set ruler
set number
set showmatch

"======== Search ============
set ignorecase
set smartcase
set hlsearch
set incsearch
set magic

"======== Color =============
syntax enable
set background=dark
colorscheme distinguished

"======== Whitespace ========
set noexpandtab
set shiftwidth=4
set tabstop=4
highlight ExtraWhitespace ctermbg=red guibg=red
match ExtraWhitespace /\s\+$/
set list listchars=tab:>-,trail:.,extends:>,precedes:<,space:.


"======== Backups ===========
set nobackup
set nowb
set noswapfile

"======== Responsiveness ====
set timeoutlen=1000 ttimeoutlen=0


"======== Status ============
set laststatus=2
set cmdheight=1
set statusline=
set statusline+=\ %F%m%r%h\ %w
set statusline+=%=Line:\ %l\ \ Column:\ %c\ \ 
