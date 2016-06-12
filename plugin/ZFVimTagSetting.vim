" my personal vim utilities
" for https://github.com/ZSaberLv0/zf_vimrc.vim
" Author:  ZSaberLv0 <http://zsaber.com/>

if exists("g:ZFVimTagSetting_loaded") && g:ZFVimTagSetting_loaded != 1
    finish
endif

" ============================================================
" config

" ============================================================
" always use global tags, and manually update local tags
set tags=
set tags+=./tags,tags
set tags+=./.vim_tags,.vim_tags
set tags+=~/.vim_cache/.easytags
augroup ZF_setting_TagsResetForPhp
    autocmd!
    autocmd FileType php
                \ if exists("*ZF_Plugin_EasyTagsOff")|
                \     call ZF_Plugin_EasyTagsOff()|
                \ endif|
                \ set tags=|
                \ set tags+=./tags,tags|
                \ set tags+=./.vim_tags,.vim_tags
    " easytags always override tags, force to reset it
    autocmd CursorHold,InsertEnter {*.php}
                \ set tags=|
                \ set tags+=./tags,tags|
                \ set tags+=./.vim_tags,.vim_tags
augroup END
function! ZF_TagsFileLocal()
    :new
    let l:tagfile = ".vim_tags"
    let dummy = system('rm "' . l:tagfile . '"')
    let dummy = system('ctags -f "' . l:tagfile . '" --tag-relative=yes -R')
    :bd!
endfunction
function! ZF_TagsFileGlobal()
    :new
    let l:tagfile = substitute("" . $HOME . "/.vim_cache/.easytags", '\\', '/', 'g')
    let dummy = system('rm "' . l:tagfile . '"')
    let dummy = system('ctags -f "' . l:tagfile . '" --tag-relative=yes -R')
    :bd!
endfunction
function! ZF_TagsFileGlobalAdd()
    :new
    let l:tagfile = substitute("" . $HOME . "/.vim_cache/.easytags", '\\', '/', 'g')
    let dummy = system('ctags -f "' . l:tagfile . '" --tag-relative=yes -R -a')
    :bd!
endfunction
function! ZF_TagsFileRemove()
    :new
    let l:tagfile = substitute("" . $HOME . "/.vim_cache/.easytags", '\\', '/', 'g')
    let dummy = system('rm "' . l:tagfile . '"')
    let l:tagfile = ".vim_tags"
    let dummy = system('rm "' . l:tagfile . '"')
    :bd!
endfunction

