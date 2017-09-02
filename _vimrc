"----------------------------
"-Author:easy               -
"-Time:2016/10/10           -
"----------------------------

"Judge current system
if has("win32") || has("win32unix")
    let g:OS#name = "win"
    let g:OS#win = 1
    let g:OS#mac = 0
    let g:OS#unix = 0
elseif has("mac")
    let g:OS#name = "mac"
    let g:OS#mac = 1
    let g:OS#win = 0
    let g:OS#unix = 0
elseif has("unix")
    let g:OS#name = "unix"
    let g:OS#unix = 1
    let g:OS#win = 0
    let g:OS#mac = 0
endif
if has("gui_running")
    let g:OS#gui = 1
else
    let g:OS#gui = 0
endif

"Set user path
if g:OS#win
    "let $VIUMFILES = $VIM.'/vimfiles'
    "let $HOME = $VIUMFILES
elseif g:OS#unix
    let $VIM = $HOME
    let $VIMFILES = $HOME.'~/.vim'
elseif g:OS#mac
    let $VIM = $HOME
    let $VIMFILES = $HOME.'~/.vim'
endif


if g:OS#win
	 " MyDiff 
	set diffexpr=MyDiff()
	function! MyDiff()
		  let opt = '-a --binary '
		  if &diffopt =~ 'icase' | let opt = opt . '-i ' | endif
		  if &diffopt =~ 'iwhite' | let opt = opt . '-b ' | endif
		  let arg1 = v:fname_in
		  if arg1 =~ ' ' | let arg1 = '"' . arg1 . '"' | endif
		  let arg2 = v:fname_new
		  if arg2 =~ ' ' | let arg2 = '"' . arg2 . '"' | endif
		  let arg3 = v:fname_out
		  if arg3 =~ ' ' | let arg3 = '"' . arg3 . '"' | endif
		  let eq = ''
		  if $VIMRUNTIME =~ ' '
			if &sh =~ '\<cmd'
			  let cmd = '""' . $VIMRUNTIME . '\diff"'
			  let eq = '"'
			else
			  let cmd = substitute($VIMRUNTIME, ' ', '" ', '') . '\diff"'
			endif
		  else
			let cmd = $VIMRUNTIME . '\diff'
		  endif
		  silent execute '!' . cmd . ' ' . opt . arg1 . ' ' . arg2 . ' > ' . arg3 . eq
	endfunction
endif

" Win平台下窗口全屏组件 gvimfullscreen.dll
" Alt + Enter 全屏切换
" Shift + t 降低窗口透明度
" Shift + y 加大窗口透明度
" Shift + r 切换Vim是否总在最前面显示
" Vim启动的时候自动使用当前颜色的背景色以去除Vim的白色边框
if has('gui_running') && has('gui_win32') && has('libcall')
    let g:MyVimLib = 'gvimfullscreen.dll'
    function! ToggleFullScreen()
        call libcall(g:MyVimLib, 'ToggleFullScreen', 1)
    endfunction

    let g:VimAlpha = 255
    function! SetAlpha(alpha)
        let g:VimAlpha = g:VimAlpha + a:alpha
        if g:VimAlpha < 180
            let g:VimAlpha = 180
        endif
        if g:VimAlpha > 255
            let g:VimAlpha = 255
        endif
        call libcall(g:MyVimLib, 'SetAlpha', g:VimAlpha)
    endfunction

    let g:VimTopMost = 0
    function! SwitchVimTopMostMode()
        if g:VimTopMost == 0
            let g:VimTopMost = 1
        else
            let g:VimTopMost = 0
        endif
        call libcall(g:MyVimLib, 'EnableTopMost', g:VimTopMost)
    endfunction

    "Map Alt+Enter switch to all screen
    map <a-enter> <esc>:call ToggleFullScreen()<cr>
    
    "Map Shift+r switch to if the Vim is topmost
    nmap <s-r> <esc>:call SwitchVimTopMostMode()<cr>

    "Add the alpha of Vim's window
    nmap <s-t> <esc>:call SetAlpha(10)<cr>

    "Add the alpha of Vim's window
    nmap <s-y> <esc>:call SetAlpha(-10)<cr>
    
    " Set the alpha defult
    autocmd GUIEnter * call libcallnr(g:MyVimLib, 'SetAlpha', g:VimAlpha)
endif

"---vundle
"------------------------------------------------------------------
set nocompatible 
filetype on
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'VundleVim/Vundle.vim'

"my vundle 
Plugin 'tpope/vim-fugitive'
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
Plugin 'eugeii/consolas-powerline-vim'
Plugin 'scrooloose/nerdtree'

"Color schemes
Plugin 'tomasr/molokai'
Plugin 'Lucius'
Plugin 'altercation/solarized'
Plugin 'NLKNguyen/papercolor-theme'
Plugin 'flazz/vim-colorschemes'

"YouCompleteMe
Plugin 'Valloric/YouCompleteMe'

"OmniSharp
Plugin 'OmniSharp/omnisharp-vim'
Plugin 'tpope/vim-dispatch'
Plugin 'SirVer/ultisnips'

"Syntastic
Plugin 'scrooloose/syntastic'

"Markdown
Plugin 'iamcco/markdown-preview.vim'

"GLSL syntax"
Plugin 'tikhomirov/vim-glsl'
call vundle#end()
filetype plugin indent on

"------------------------------------------------------------------
"----Plugin Airline
"------------------------------------------------------------------
"theme
let g:airline_theme="luna"
"enable tabline
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#buffer_nr_show = 1

let g:airline_powerline_fonts = 1
let g:Powerline_symbols = 'fancy'

"font
"set guifont=Droid_Sans_Mono_Slashed_for_Pow:h11:cANSI:qDRAFT
"set guifont=Inconsolata\ for\ Powerline
"set guifont=arial\ monospaced\ for\ sap
set guifont=Ubuntu\ Mono\ derivative\ Powerline

"must set after install fonts
"solve garbage characters and show fonts
set encoding=utf-8
set langmenu=zh_CN.UTF-8
set fileencodings=ucs-bom,utf-8,utf-16,gbk,cp936,gb18030,big5,euc-jp,euc-kr,latin1
"set ambiwidth=double
set laststatus=2

"buffer map
nnoremap <C-tab> :bn<CR>
nnoremap <C-s-tab> :bp<CR>

"config powerline symbols
if !exists('g:airline_symbols')
    let g:airline_symbols = {}
endif
let g:airline_left_sep = ''
let g:airline_left_alt_sep = ''
let g:airline_right_sep = ''
let g:airline_right_alt_sep = ''
let g:airline_symbols.branch = ''
let g:airline_symbols.readonly = ''
let g:airline_symbols.linenr = ''

"-------------------------------------------------------
"-----Vim Enter
"-------------------------------------------------------
function s:ReadSession()
    let s:session_file = 'Session.vim'
    if filereadable(s:session_file)
        source Session.vim
    endif
endfunction
function s:ReadViminfo()
    let s:viminfo_file = 'Viminfo.viminfo'
    if filereadable(s:viminfo_file)
        rviminfo Viminfo.viminfo
    endif
endfunction
"autocmd VimEnter * :call s:ReadSession()
"autocmd VimEnter * :call s:ReadViminfo()

map <leader>nt :NERDTreeToggle<cr>
map <leader>pj :source Session.vim<cr>

"-------------------------------------------------------
"-----Vim Exit
"-------------------------------------------------------
set sessionoptions=buffers,sesdir,folds,help,options,tabpages,winsize
"autocmd VimLeave * mks! ./Session.vim
"autocmd VimLeave * wviminfo! Viminfo.viminfo
map <leader>ws :mks! Session.vim<cr>

"-------------------------------------------------------
"-----Plugin Ycm
"-------------------------------------------------------
let g:ycm_global_ycm_extra_conf = "~/.vim/bundle/YouCompleteMe/third_party/ycmd/cpp/ycm/.ycm_extra_conf.py"
let g:ycm_autoclose_preview_window_after_insertion = 1
let g:ycm_warning_symbol = '>'
let g:ycm_enable_diagnostic_signs = 0
set completeopt-=preview

"-------------------------------------------------------
"-----Plugin OmniSharp
"-------------------------------------------------------
filetype plugin on
"set splitbelow
"let g:syntastic_cs_checkers = ['syntax', 'semantic', 'issues']
let g:OmniSharp_selector_ui = 'ctrlp'


augroup omnisharp_commands
    autocmd!

    "Set autocomplete function to OmniSharp (if not using YouCompleteMe completion plugin)
    autocmd FileType cs setlocal omnifunc=OmniSharp#Complete

    " Synchronous build (blocks Vim)
    "autocmd FileType cs nnoremap <F5> :wa!<cr>:OmniSharpBuild<cr>
    " Builds can also run asynchronously with vim-dispatch installed
    autocmd FileType cs nnoremap <leader>b :wa!<cr>:OmniSharpBuildAsync<cr>
    " automatic syntax check on events (TextChanged requires Vim 7.4)
    autocmd BufEnter,TextChanged,InsertLeave *.cs SyntasticCheck

    " Automatically add new cs files to the nearest project on save
    autocmd BufWritePost *.cs call OmniSharp#AddToProject()

    "show type information automatically when the cursor stops moving
    autocmd CursorHold *.cs call OmniSharp#TypeLookupWithoutDocumentation()

    "The following commands are contextual, based on the current cursor position.

    autocmd FileType cs nnoremap gd :OmniSharpGotoDefinition<cr>
    autocmd FileType cs nnoremap <leader>fi :OmniSharpFindImplementations<cr>
    autocmd FileType cs nnoremap <leader>ft :OmniSharpFindType<cr>
    autocmd FileType cs nnoremap <leader>fs :OmniSharpFindSymbol<cr>
    autocmd FileType cs nnoremap <leader>fu :OmniSharpFindUsages<cr>
    "finds members in the current buffer
    autocmd FileType cs nnoremap <leader>fm :OmniSharpFindMembers<cr>
    " cursor can be anywhere on the line containing an issue
    autocmd FileType cs nnoremap <leader>x  :OmniSharpFixIssue<cr>
    autocmd FileType cs nnoremap <leader>fx :OmniSharpFixUsings<cr>
    autocmd FileType cs nnoremap <leader>tt :OmniSharpTypeLookup<cr>
    autocmd FileType cs nnoremap <leader>dc :OmniSharpDocumentation<cr>
    "navigate up by method/property/field
    autocmd FileType cs nnoremap <C-K> :OmniSharpNavigateUp<cr>
    "navigate down by method/property/field
    autocmd FileType cs nnoremap <C-J> :OmniSharpNavigateDown<cr>

augroup END

" this setting controls how long to wait (in ms) before fetching type / symbol information.
set updatetime=500
" Remove 'Press Enter to continue' message when type information is longer than one line.
set cmdheight=2

" Contextual code actions (requires CtrlP or unite.vim)
nnoremap <leader><space> :OmniSharpGetCodeActions<cr>
" Run code actions with text selected in visual mode to extract method
vnoremap <leader><space> :call OmniSharp#GetCodeActions('visual')<cr>

" rename with dialog
nnoremap <leader>nm :OmniSharpRename<cr>
nnoremap <F2> :OmniSharpRename<cr>
" rename without dialog - with cursor on the symbol to rename... ':Rename newname'
command! -nargs=1 Rename :call OmniSharp#RenameTo("<args>")

" Force OmniSharp to reload the solution. Useful when switching branches etc.
nnoremap <leader>rl :OmniSharpReloadSolution<cr>
nnoremap <leader>cf :OmniSharpCodeFormat<cr>
" Load the current .cs file to the nearest project
nnoremap <leader>tp :OmniSharpAddToProject<cr>

" (Experimental - uses vim-dispatch or vimproc plugin) - Start the omnisharp server for the current solution
nnoremap <leader>ss :OmniSharpStartServer<cr>
nnoremap <leader>sp :OmniSharpStopServer<cr>

" Add syntax highlighting for types and interfaces
nnoremap <leader>th :OmniSharpHighlightTypes<cr>
"Don't ask to save when changing buffers (i.e. when jumping to a type definition)
set hidden

" Enable snippet completion, requires completeopt-=preview
let g:OmniSharp_want_snippet=1

"-------------------------------------------
"------Plugin ultisnips
"-------------------------------------------
" Trigger configuration. Do not use <tab> if you use https://github.com/Valloric/YouCompleteMe.
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<c-b>"
let g:UltiSnipsJumpBackwardTrigger="<c-z>"

" If you want :UltiSnipsEdit to split your window.
let g:UltiSnipsEditSplit="vertical"

"===============Not Plugin===================
"Set template
"Autocmd BufNewFile *.txt or ~/.vim/template/txt.tlp
"Let g:Timestamp = .strftime("%Y-%m-%d %H:%M")
"sh
function LoadShellScriptTemplate()
	call append(0,"#!/bin/bash")
	call append(1,"#Program:")
	call append(2,"#======>")
	call append(3,"#Author: easy")
	call append(4,"#Data: ".strftime("%Y-%m-%d %H:%M"))
	call append(5,"#Update: ".strftime("%Y-%m-%d %H:%M"))
	call append(6,"PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin")
	call append(7,"export PATH")
	call append(8,"#===========")
endf
autocmd BufNewFile *.sh call LoadShellScriptTemplate()

"cs
function LoadCSharpTemplate()
	call append(0,"//================================")
	call append(1,"//===Author: easy")
	call append(2,"//===Email: gopiny@live.com")
	call append(3,"//===Date: ".strftime("%Y-%m-%d %H:%M"))
	call append(4,"//================================")
endf
autocmd BufNewFile *.cs call LoadCSharpTemplate()
function UpdataCSharpTemplate()
	call append(4,"//===Update: ".strftime("%Y-%m-%d %H:%M"))
endf
"autocmd BufRead *.cs call UpdataCSharpTemplate()

"txt
function InputTimestamp()
	call append(0,"Timestamp: ".strftime("%Y-%m-%d %H:%M"))
endf
autocmd BufNewFile *.txt call InputTimestamp()

"markdown
function LoadMarkdownTemplate()
    call append(0,"title: ")
    call append(1,"date: ".strftime("%Y-%m-%d %H:%M"))
    call append(2,"update: ".strftime("%Y-%m-%d %H:%M"))
    call append(3,"comments: true")
    call append(4,"tags: ")
    call append(5,"categories: ")
    call append(6,"---")
endf
autocmd BufNewFile *.md call LoadMarkdownTemplate()

"glsl
function SetFsFile()
    set filetype=glsl
endf
autocmd BufNewFile,BufRead *.fs,*.vs call SetFsFile()

"Lua
"C
"Cpp
"Js

"-------------------------------------------
"------Set Map
"-------------------------------------------
function SetMap_F5()
	if &filetype == 'text'
		call InputTimestamp()
	endif
endf
noremap <f5> :call SetMap_F5() <CR>

"Set fullscreen
if g:OS#unix
    let g:fullscreen = 0
    function! ToggleFullscreen()
        if g:fullscreen == 1
            let g:fullscreen = 0
            let mod = "remove"
        else		
            let g:fullscreen = 1
            let mod = "add"
        endif
        call system("wmctrl -ir" . v:windowid . " -b " . mod . ",fullscreen")
    endfunction
    function SetMap_F11()
        call ToggleFullscreen()
    endf
    map <silent> <F11> :call SetMap_F11()<CR>
endif

function SetTxtMap()
    "Timestamp
    noremap <f5> :call InputTimestamp() <CR>
    "Operation for git
    noremap <f1> :Git add .<cr>
    noremap <f2> :Git commit -m "update"<cr>
    noremap ,<f3> :Git push -u origin master<cr>
    noremap <f4> :Git status<cr>
    noremap ,<f1> :Git pull origin master<cr>
endf
autocmd BufRead *.txt call SetTxtMap()

"post my blog
autocmd BufWrite *.md noremap ,<f3> :!hexo g -d<cr>

"fast write
imap w/ <esc>:w!<cr>

"line feed
nmap j gj
nmap k gk
"-------------------------------------------
"------Others
"-------------------------------------------
"Set colorschemes
"colorscheme molokai
"colorscheme Lucius
colorscheme solarized
"colorscheme PaperColor

"set copy paste
nmap ,v "+p
vmap ,c "+yy
nmap ,c "+yy
"enable syntax light
syntax enable
syntax on
"set tab length
set tabstop=4
"set auto indentation
set shiftwidth=4
set softtabstop=4
set autoindent
set expandtab
"set line number
set number
"hide menu
set guioptions-=m
"hide toolbar
set guioptions-=T
"hide left scroll bar
set guioptions-=L
"hide right scroll bar
set guioptions-=r
"hide bottom scroll bar
set guioptions-=b
"hide tabline
"set showtabline=0
"set no undo file
set noundofile
"set no ~ file
set nobackup
"set no swapfile
set noswapfile

"set no ^M
if g:OS#win
    set fileformats=dos
endif

"set auto fill
function! AutoPair(open, close)
  let line = getline('.')
  if col('.') > strlen(line) || line[col('.') - 1] == ' '
    return a:open.a:close."\<ESC>i"
  else
    return a:open
  endif
endf
function ClosePair(char)
    if getline('.')[col('.') - 1] == a:char
        return "\<Right>"
    else
        return a:char
    endif
endf
inoremap ( <c-r>=AutoPair('(', ')')<CR>
inoremap ) <c-r>=ClosePair(')')<CR>
inoremap { {}<ESC>i
inoremap } <c-r>=ClosePair('}')<CR>
inoremap [ []<ESC>i
inoremap ] <c-r>=ClosePair(']')<CR>
inoremap < <><ESC>i
inoremap > <c-r>=ClosePair('>')<CR>

"set up down left right disabled
noremap <Up> <NOP>
noremap <Down> <NOP>
noremap <Left> <NOP>
noremap <Right> <NOP>

"set winpos
winpos 800 335

"set search
set hlsearch
set incsearch
set ignorecase

"set color
highlight YcmWarningSection guifg=#808080
"highlight Comment ctermfg=green guifg=green
highlight Comment ctermfg=green guifg=#228B22
