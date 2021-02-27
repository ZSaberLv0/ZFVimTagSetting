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
    return CygpathFix_absPath(g:ZFVimTagSetting_tagsGlobalPath . '/' . g:ZFVimTagSetting_tagsName)
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
    let l:tagfile = substitute(CygpathFix_absPath(g:ZFVimTagSetting_tagsGlobalPath . '/' . g:ZFVimTagSetting_tagsName), '\\', '/', 'g')
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
    let l:tagfile = substitute(CygpathFix_absPath(g:ZFVimTagSetting_tagsGlobalPath . '/' . g:ZFVimTagSetting_tagsName), '\\', '/', 'g')
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
    let l:tagfile = substitute(CygpathFix_absPath(g:ZFVimTagSetting_tagsGlobalPath . '/' . g:ZFVimTagSetting_tagsName), '\\', '/', 'g')
    call delete(l:tagfile)
    let l:tagfile = g:ZFVimTagSetting_tagsName
    call delete(l:tagfile)
    echo "tags removed"
endfunction

function! CygpathFix_absPath(path)
    if len(a:path) <= 0|return ''|endif
    if !exists('g:CygpathFix_isCygwin')
        let g:CygpathFix_isCygwin = has('win32unix') && executable('cygpath')
    endif
    let path = fnamemodify(a:path, ':p')
    if g:CygpathFix_isCygwin
        if 0 " cygpath is really slow
            let path = substitute(system('cygpath -m "' . path . '"'), '[\r\n]', '', 'g')
        else
            if match(path, '^/cygdrive/') >= 0
                let path = toupper(strpart(path, len('/cygdrive/'), 1)) . ':' . strpart(path, len('/cygdrive/') + 1)
            else
                if !exists('g:CygpathFix_cygwinPrefix')
                    let g:CygpathFix_cygwinPrefix = substitute(system('cygpath -m /'), '[\r\n]', '', 'g')
                endif
                let path = g:CygpathFix_cygwinPrefix . path
            endif
        endif
    endif
    return substitute(substitute(path, '\\', '/', 'g'), '\%(\/\)\@<!\/\+$', '', '') " (?<!\/)\/+$
endfunction

