" my personal vim utilities
" for https://github.com/ZSaberLv0/zf_vimrc.vim
" Author:  ZSaberLv0 <http://zsaber.com/>

let g:ZFVimTagSetting_loaded=1

" ============================================================
" config
if !exists('g:ZFVimTagSetting_tagsName')
    let g:ZFVimTagSetting_tagsName='.vim_tags'
endif
if !exists('g:ZFVimTagSetting_tagsGlobalPath')
    if exists('g:zf_vim_cache_path')
        let g:ZFVimTagSetting_tagsGlobalPath=g:zf_vim_cache_path
    else
        let g:ZFVimTagSetting_tagsGlobalPath='~/.vim_cache'
    endif
endif

" ============================================================
" always use global tags, and manually update local tags
set tags=
set tags+=./tags,tags
if g:ZFVimTagSetting_tagsName != 'tags'
    execute 'set tags+=./' . g:ZFVimTagSetting_tagsName
    execute 'set tags+=' . g:ZFVimTagSetting_tagsName
    execute 'set tags+=' . g:ZFVimTagSetting_tagsGlobalPath . '/' . g:ZFVimTagSetting_tagsName
endif

function! ZF_TagsFileGlobalPath()
    return fnamemodify(g:ZFVimTagSetting_tagsGlobalPath . '/' . g:ZFVimTagSetting_tagsName, ':p')
endfunction
function! s:ZF_TagsExcludePattern(cmd)
    let list = split(&wildignore, ',')
    let cmd = a:cmd
    for item in list
        execute "let cmd.=' --exclude=" . '"' . item . '"' . "'"
    endfor
    return cmd
endfunction
function! ZF_TagsFileLocal()
    let l:tagfile = g:ZFVimTagSetting_tagsName
    call delete(l:tagfile)
    let cmd = 'ctags -f "' . l:tagfile . '" --tag-relative=yes -R --fields=+l'
    let cmd = s:ZF_TagsExcludePattern(cmd)
    try
        redraw!
        echo "generating tags in background"
        execute "call ZFAsyncRun('" . cmd . "', 'ZF_TagsFileLocal')"
    catch
        redraw!
        echo "generating tags"
        call system(cmd)
        redraw!
        echo "generating tags finished"
    endtry
endfunction
function! ZF_TagsFileGlobal()
    let l:tagfile = substitute(fnamemodify(g:ZFVimTagSetting_tagsGlobalPath . '/' . g:ZFVimTagSetting_tagsName, ':p'), '\\', '/', 'g')
    call delete(l:tagfile)
    let cmd = 'ctags -f "' . l:tagfile . '" --tag-relative=yes -R --fields=+l'
    let cmd = s:ZF_TagsExcludePattern(cmd)
    try
        redraw!
        echo "generating tags in background"
        execute "call ZFAsyncRun('" . cmd . "', 'ZF_TagsFileGlobal')"
    catch
        redraw!
        echo "generating tags"
        call system(cmd)
        redraw!
        echo "generating tags finished"
    endtry
endfunction
function! ZF_TagsFileGlobalAdd()
    let l:tagfile = substitute(fnamemodify(g:ZFVimTagSetting_tagsGlobalPath . '/' . g:ZFVimTagSetting_tagsName, ':p'), '\\', '/', 'g')
    let cmd = 'ctags -f "' . l:tagfile . '" --tag-relative=yes -R -a --fields=+l'
    let cmd = s:ZF_TagsExcludePattern(cmd)
    try
        execute "call ZFAsyncRun('" . cmd . "', 'ZF_TagsFileGlobal')"
    catch
        redraw!
        echo "generating tags"
        call system(cmd)
        redraw!
        echo "generating tags finished"
    endtry
endfunction
function! ZF_TagsFileRemove()
    let l:tagfile = substitute(fnamemodify(g:ZFVimTagSetting_tagsGlobalPath . '/' . g:ZFVimTagSetting_tagsName, ':p'), '\\', '/', 'g')
    call delete(l:tagfile)
    let l:tagfile = g:ZFVimTagSetting_tagsName
    call delete(l:tagfile)
    echo "tags removed"
endfunction

