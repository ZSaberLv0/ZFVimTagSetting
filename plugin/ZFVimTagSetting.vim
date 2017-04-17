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
set tags+=~/.vim_cache/.vim_tags

function! s:ZF_TagsExcludePattern(cmd)
    let list = split(&wildignore, ',')
    let cmd = a:cmd
    for item in list
        execute "let cmd.=' --exclude=" . '"' . item . '"' . "'"
    endfor
    return cmd
endfunction
function! ZF_TagsFileLocal()
    let l:tagfile = ".vim_tags"
    call system('rm "' . l:tagfile . '"')
    let cmd = 'ctags -f "' . l:tagfile . '" --tag-relative=yes -R'
    let cmd = s:ZF_TagsExcludePattern(cmd)
    try
        redraw!
        echo "generating tags in background"
        execute 'AsyncRun ' . cmd
    catch
        redraw!
        echo "generating tags"
        call system(cmd)
        redraw!
        echo "generating tags finished"
    endtry
endfunction
function! ZF_TagsFileGlobal()
    let l:tagfile = substitute("" . $HOME . "/.vim_cache/.vim_tags", '\\', '/', 'g')
    call system('rm "' . l:tagfile . '"')
    let cmd = 'ctags -f "' . l:tagfile . '" --tag-relative=yes -R'
    let cmd = s:ZF_TagsExcludePattern(cmd)
    try
        redraw!
        echo "generating tags in background"
        execute 'AsyncRun ' . cmd
    catch
        redraw!
        echo "generating tags"
        call system(cmd)
        redraw!
        echo "generating tags finished"
    endtry
endfunction
function! ZF_TagsFileGlobalAdd()
    let l:tagfile = substitute("" . $HOME . "/.vim_cache/.vim_tags", '\\', '/', 'g')
    let cmd = 'ctags -f "' . l:tagfile . '" --tag-relative=yes -R -a'
    let cmd = s:ZF_TagsExcludePattern(cmd)
    try
        execute 'AsyncRun ' . cmd
    catch
        redraw!
        echo "generating tags"
        call system(cmd)
        redraw!
        echo "generating tags finished"
    endtry
endfunction
function! ZF_TagsFileRemove()
    let l:tagfile = substitute("" . $HOME . "/.vim_cache/.vim_tags", '\\', '/', 'g')
    call system('rm "' . l:tagfile . '"')
    let l:tagfile = ".vim_tags"
    call system('rm "' . l:tagfile . '"')
    echo "tags removed"
endfunction

" special setting for easytags
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

