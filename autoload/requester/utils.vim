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

