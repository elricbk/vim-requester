function! requester#request#MakeRequest(request, run_cmd, autoformat)
    let request_cmd = get(a:request, 'request_cmd', g:vim_requester_default_cmd)
    let filetype = get(a:request, 'filetype', '')
    let url = a:request.url
    let no_autoformat = get(a:request, 'no_autoformat')

    let cmd = substitute(l:request_cmd, '{}', "\\='" . l:url . "'", '')
    let response = a:run_cmd(cmd)
    let lines = split(response, '\n')

    call requester#utils#FindBufferById('vim_requester.response')
    call requester#utils#SetupScratchBuffer()

    normal! ggdG
    call append(0, lines)
    normal! gg

    if l:filetype != ''
        let &filetype = l:filetype
    else
        let &filetype = requester#utils#GetFileType(lines)
    endif

    let should_autoformat = !no_autoformat &&
    \    exists('g:vim_requester_autoformat') &&
    \    has_key(g:vim_requester_autoformat, &filetype)
    if should_autoformat
        call a:autoformat()
    endif
endfunction

