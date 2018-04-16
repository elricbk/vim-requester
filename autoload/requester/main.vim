function! requester#main#MakeRequest(request_cmd, url, filetype)
    let cmd = substitute(a:request_cmd, '{}', "\\='" . a:url . "'", '')
    let response = system(cmd)
    let lines = split(response, '\n')

    call requester#utils#FindBufferById('vim_requester.response')

    normal ggdG
    call append(0, lines)
    normal gg

    call requester#utils#SetupScratchBuffer()

    let &filetype=a:filetype
endfunction

function! requester#main#ParseRequestLines(begin, end) abort
    let i = a:begin
    let line_count = a:end
    let result = {}
    let url = ''
    let params = []
    while i <= line_count
        let l = getline(i)
        if l =~ '^# \+@request_cmd \+'
            let result.request_cmd = substitute(l, '^# \+@request_cmd \+', '', '')
        elseif l =~ '^# \+@filetype \+'
            let result.filetype = substitute(l,'^# \+@filetype \+', '', '')
        elseif l =~ '://'
            let url = l
        elseif l =~ '^[a-z_]\+\zs *= *'
            call add(params, l)
        endif
        let i += 1
    endwhile
    let result.url = requester#urlparse#UrlUnparse(url, params)
    return result
endfunction

function! requester#main#ParseRequestBuffer() abort
    return requester#main#ParseRequestLines(1, line('$'))
endfunction

function! requester#main#RequesterRun()
    let result = requester#main#ParseRequestBuffer()
    let request_cmd = get(result, 'request_cmd', g:vim_requester_default_cmd)
    let filetype = get(result, 'filetype', g:vim_requester_default_filetype)
    call requester#main#MakeRequest(request_cmd, result.url, filetype)
endfunction

function! requester#main#JoinLines(begin, end) abort
    let result = requester#main#ParseRequestLines(a:begin, a:end)
    let search = @/
    call cursor(1, 1)
    call search('^[^#]')
    call append(line('.') - 1, result.url)
    normal dG
    let @/ = search
endfunction
