set listchars=tab:▸\ ,eol:¬,extends:❯
colorscheme solarized
let g:airline#extensions#tabline#enabled = 1
nmap <leader>h :bprev<cr>
nmap <leader>l :bnext<cr>
set shell=bash

let g:airline_powerline_fonts = 1
let g:airline_theme = 'solarized'

set shiftwidth=2

set colorcolumn=80
set spell
set spelllang=en_ca

set synmaxcol=800
set nowrap
set mouse=a

" Save when losing focus
au FocusLost * :silent! wall

" Return to last the line your were last on in Vim. 
augroup line_return
    au!
    au BufReadPost *
        \ if line("'\"") > 0 && line("'\"") <= line("$") |
        \     execute 'normal! g`"zvzz' |
        \ endif
augroup END

" Very magic RegEx
nnoremap / //\v<left><left><left>

set ignorecase
set smartcase
set incsearch
set showmatch
set hlsearch


" Focus current line
nnoremap <c-z> mzzMzvzz15<c-e>`z:<cr>

set foldlevelstart=0

" Keep search matches in the middle of the window.
nnoremap n nzzzv
nnoremap N Nzzzv

" Make zO recursively open whatever fold we're in, even if it's partially open.
nnoremap zO zczO


" Highlight Word {{{
"
" This mini-plugin provides a few mappings for highlighting words temporarily.
"
" Sometimes you're looking at a hairy piece of code and would like a certain
" word or two to stand out temporarily.  You can search for it, but that only
" gives you one color of highlighting.  Now you can use <leader>N where N is
" a number from 1-6 to highlight the current word in a specific color.

function! HiInterestingWord(n) " {{{
    " Save our location.
    normal! mz

    " Yank the current word into the z register.
    normal! "zyiw

    " Calculate an arbitrary match ID.  Hopefully nothing else is using it.
    let mid = 86750 + a:n

    " Clear existing matches, but don't worry if they don't exist.
    silent! call matchdelete(mid)

    " Construct a literal pattern that has to match at boundaries.
    let pat = '\V\<' . escape(@z, '\') . '\>'

    " Actually match the words.
    call matchadd("InterestingWord" . a:n, pat, 1, mid)

    " Move back to our original location.
    normal! `z
endfunction " }}}
"}}}
" Mappings {{{

nnoremap <silent> <leader>1 :call HiInterestingWord(1)<cr>
nnoremap <silent> <leader>2 :call HiInterestingWord(2)<cr>
nnoremap <silent> <leader>3 :call HiInterestingWord(3)<cr>
nnoremap <silent> <leader>4 :call HiInterestingWord(4)<cr>
nnoremap <silent> <leader>5 :call HiInterestingWord(5)<cr>
nnoremap <silent> <leader>6 :call HiInterestingWord(6)<cr>

" }}}
" Default Highlights {{{

hi def InterestingWord1 guifg=#000000 ctermfg=16 guibg=#ffa724 ctermbg=214
hi def InterestingWord2 guifg=#000000 ctermfg=16 guibg=#aeee00 ctermbg=154
hi def InterestingWord3 guifg=#000000 ctermfg=16 guibg=#8cffba ctermbg=121
hi def InterestingWord4 guifg=#000000 ctermfg=16 guibg=#b88853 ctermbg=137
hi def InterestingWord5 guifg=#000000 ctermfg=16 guibg=#ff9eb8 ctermbg=211
hi def InterestingWord6 guifg=#000000 ctermfg=16 guibg=#ff2c4b ctermbg=195

noremap <silent> <leader><space> :noh<cr>:call clearmatches()<cr>


" Space to toggle folds.
nnoremap <Space> za
vnoremap <Space> za
function! MyFoldText() " {{{
  let line = getline(v:foldstart)

  let nucolwidth = &fdc + &number * &numberwidth
  let windowwidth = winwidth(0) - nucolwidth - 3
  let foldedlinecount = v:foldend - v:foldstart

  " expand tabs into spaces
  let onetab = strpart('          ', 0, &tabstop)
  let line = substitute(line, '\t', onetab, 'g')

  let line = strpart(line, 0, windowwidth - 2 -len(foldedlinecount))
  let fillcharcount = windowwidth - len(line) - len(foldedlinecount)
  return line . '…' . repeat(" ",fillcharcount) . foldedlinecount . '…' . ' '
endfunction " }}}
set foldtext=MyFoldText()

command! ScratchToggle call ScratchToggle()

function! ScratchToggle()
    if exists("w:is_scratch_window")
        unlet w:is_scratch_window
        exec "q"
    else
        exec "normal! :Sscratch\<cr>\<C-W>L"
        let w:is_scratch_window = 1
    endif
endfunction

" hello there this is a test
nnoremap Q gqip

nnoremap * *N

nnoremap <silent> <leader><tab> :ScratchToggle<cr>

ino <leader>C <C-O>yiW<End>=<C-R>=<C-R>0<CR>

" Sudo to write
cnoremap w!! w !sudo tee % >/dev/null

" AAAAAAAGH GET RID OF THE FOLD LEVEL BAR UUAUHAH
set foldcolumn=0

" Ack motions

" Motions to Ack for things.  Works with pretty much everything, including:
"
"   w, W, e, E, b, B, t*, f*, i*, a*, and custom text objects
"
" Awesome.
"
" Note: If the text covered by a motion contains a newline it won't work.  Ack
" searches line-by-line.

nnoremap <silent> <leader>A :set opfunc=<SID>AckMotion<CR>
xnoremap <silent> <leader>A :<C-U>call <SID>AckMotion(visualmode())<CR>

nnoremap <bs> :Ack! '\b<c-r><c-w>\b'<cr>
xnoremap <silent> <bs> :<C-U>call <SID>AckMotion(visualmode())<CR>

function! s:CopyMotionForType(type)
    if a:type ==# 'v'
        silent execute "normal! `<" . a:type . "`>y"
    elseif a:type ==# 'char'
        silent execute "normal! `[v`]y"
    endif
endfunction

function! s:AckMotion(type) abort
    let reg_save = @@

    call s:CopyMotionForType(a:type)

    execute "normal! :Ack! --literal " . shellescape(@@) . "\<cr>"

    let @@ = reg_save
endfunction


nnoremap <leader><space> :silent !myctags >/dev/null 2>&1 &<cr>:redraw!<cr>

let Tlist_Ctags_Cmd='/usr/local/ctags'

nnoremap H :bprev<cr>
nnoremap L :bnext<cr>

inoremap jj <esc>

iabbrev ldis ಠ_ಠ
iabbrev lsad ಥ_ಥ
iabbrev lhap ಥ‿ಥ
iabbrev lmis ಠ‿ಠ

set tabstop=2

" HTML linting
let g:syntastic_html_tidy_ignore_errors = [ '<input> proprietary attribute "role"' ]
let g:syntastic_html_tidy_ignore_errors = [ '<input> proprietary attribute "spellcheck"' ]
