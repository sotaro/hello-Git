set nocompatible
filetype off
  
set rtp+=~/.vim/vundle.git/
call vundle#rc()

Bundle 'Shougo/unite.vim'
Bundle 'Shougo/vimshell'
Bundle 'Shougo/neocomplcache'
Bundle 'Shougo/vimproc'

filetype plugin indent on

set textwidth=0
set nobackup
set ruler
set suffixes=.bak,~,.swp,.o,.out

set tabstop=4
set shiftwidth=4
set cindent
"set autoindent
"set smartindent

syntax on
colorscheme slate

set ignorecase
set showmatch
set laststatus=2
set wildmode=list:longest
set nu
set hlsearch
map <Esc><Esc> :nohlsearch<CR><Esc>
set nolist

au BufRead,BufNewFile *.php set makeprg=php\ -l\ %
au BufRead,BufNewFile *.php set errorformat=%m\ in\ %f\ on\ line\ %l
autocmd FileType php map <c-c><c-c> :make<cr> :cw<cr><cr>

autocmd FileType xhtml,html :compiler tidy
autocmd FileType xhtml,html :setlocal makeprg=tidy\ -raw\ -quiet\ -errors\ --gnu-emacs\ yes\ \"%\"
autocmd FileType xhtml,html map <c-c><c-c> :make<cr> :cw<cr><cr>

autocmd FileType php set omnifunc=phpcomplete#CompletePHP
autocmd FileType javascript set omnifunc=javascriptcomplete#CompleteJS
autocmd FileType html set omnifunc=htmlcomplete#CompleteTags
autocmd FileType xhtml set omnifunc=htmlcomplete#CompleteTags
autocmd FileType css set omnifunc=csscomplete#CompleteCSS


function! GetB()
  let c = matchstr(getline('.'), '.', col('.') - 1)
  let c = iconv(c, &enc, &fenc)
  return String2Hex(c)
endfunction
func! Nr2Hex(nr)
  let n = a:nr
  let r = ""
  while n
    let r = '0123456789ABCDEF'[n % 16] . r
    let n = n / 16
  endwhile
  return r
endfunc
func! String2Hex(str)
  let out = ''
  let ix = 0
  while ix < strlen(a:str)
    let out = out . Nr2Hex(char2nr(a:str[ix]))
    let ix = ix + 1
  endwhile
  return out
endfunc

if winwidth(0) >= 120
  set statusline=%<[%n]%m%r%h%w%{'['.(&fenc!=''?&fenc:&enc).':'.&ff.']'}%y\ %F%=[%{GetB()}]\ %l,%c%V%8P
else
  set statusline=%<[%n]%m%r%h%w%{'['.(&fenc!=''?&fenc:&enc).':'.&ff.']'}%y\ %f%=[%{GetB()}]\ %l,%c%V%8P
endif

set wildmode=list:longest

imap <C-f> <C-x><C-o>

:set complete+=k

" neocomplcache
"
let g:neocomplcache_enable_at_startup = 1
let g:neocomplcache_enable_smart_case = 1
let g:neocomplcache_enable_camel_case_completion = 0
let g:neocomplcache_enable_underbar_completion = 1
let g:neocomplcache_min_syntax_length = 3

" unite
"
let g:unite_enable_start_insert = 1
noremap :uf :<C-u>Unite file<CR>
noremap :ub :<C-u>Unite buffer<CR>
noremap :up :<C-u>call <SID>unite_project('-start-insert')<CR>

"noremap :um :<C-u>Unite file_mru -buffer-name=file_mru<CR>
"noremap :uu :<C-u>Unite buffer file_mru<CR>
"noremap :uo :<C-u>Unite outline<CR>
"noremap :ur :<C-u>Unite -buffer-name=register register<CR>
"noremap :ua :<C-u>UniteWithBufferDir -buffer-name=files buffer file_mru bookmark file<CR>

au FileType unite nnoremap <silent> <buffer> <ESC><ESC> :q<CR>
au FileType unite inoremap <silent> <buffer> <ESC><ESC> <ESC>:q<CR>

function! s:unite_project(...)
  let opts = (a:0 ? join(a:000, ' ') : '')
  let dir = unite#util#path2project_directory(expand('%'))
  execute 'Unite' opts 'file_rec:' . dir
endfunction

" vimshell
"
noremap :ss :VimShell<CR>
