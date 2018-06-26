function! requester#utils#FindBufferById(buffer_id) abort
    if (bufexists(a:buffer_id))
        let mpcwin = bufwinnr(a:buffer_id) 
        if (mpcwin == -1)
            execute "vs | buffer " . bufnr(a:buffer_id)
        else
            execute mpcwin . 'wincmd w'
        endif
    else
        execute "vnew " . a:buffer_id
    endif
endfunction

function! requester#utils#SetupScratchBuffer()
    setlocal buftype=nofile
    setlocal bufhidden=hide
    setlocal noswapfile
endfunction

function! requester#utils#RightPad(str, len)
    if len(a:str) >= a:len
        return a:str
    endif
    return a:str . repeat(' ', a:len - len(a:str))
endfunction

function! requester#utils#GetFileType(lines) abort
    if !exists('g:vim_requester_auto_filetype') || len(a:lines) == 0
        return g:vim_requester_default_filetype
    endif

    let line = a:lines[0]
    if line =~ '^ *{'
        return 'json'
    elseif line =~ '<!DOCTYPE html'
        return 'html'
    elseif line =~ '<?xml'
        return 'xml'
    elseif line =~ '^ *[a-zA-Z0-9]\+ {'
        return 'pb_text'
    else
        return g:vim_requester_default_filetype
    endif
endfunction

