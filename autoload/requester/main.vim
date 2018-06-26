function! requester#main#GetFileType(lines) abort
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

function! requester#main#MakeRequest(request, run_cmd, autoformat)
    let request_cmd = get(a:request, 'request_cmd', g:vim_requester_default_cmd)
    let filetype = get(a:request, 'filetype')
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

    if l:filetype != 0
        let &filetype = l:filetype
    else
        let &filetype = requester#main#GetFileType(lines)
    endif

    let should_autoformat = !no_autoformat &&
    \    exists('g:vim_requester_autoformat') &&
    \    has_key(g:vim_requester_autoformat, &filetype)
    if should_autoformat
        call a:autoformat()
    endif
endfunction

function! requester#main#ParseRequestLines(begin, end) abort
    let REQUEST_CMD_RGX = '^# \+@request_cmd \+'
    let FILETYPE_RGX = '^# \+@filetype \+'
    let NO_AUTOFORMAT_RGX = '^# \+@no_autoformat'
    let URL_RGX = '\v^ *(([-a-zA-Z0-9]+\.)+[-a-zA-Z0-9]+|.*://.*|/.*) *$'
    let PARAM_RGX = '^[a-z_]\+\zs *= *'

    let i = a:begin
    let line_count = a:end
    let result = {}
    let url = ''
    let params = []
    while i <= line_count
        let l = getline(i)
        if l =~ REQUEST_CMD_RGX
            let result.request_cmd = substitute(l, REQUEST_CMD_RGX, '', '')
        elseif l =~ FILETYPE_RGX
            let result.filetype = substitute(l, FILETYPE_RGX, '', '')
        elseif l =~ NO_AUTOFORMAT_RGX
            let result.no_autoformat = 1
        elseif l =~ URL_RGX
            let url = l
        elseif l =~ PARAM_RGX
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

function! requester#main#Autoformat() abort
    normal! gg=G
endfunction

function! requester#main#RequesterRun()
    call requester#main#MakeRequest(
    \    requester#main#ParseRequestBuffer(),
    \    function('system'),
    \    function('requester#main#Autoformat'),
    \)
endfunction

function! requester#main#JoinLines(begin, end) abort
    let result = requester#main#ParseRequestLines(a:begin, a:end)
    let l = a:end
    while l >= a:begin
        let line = getline(l)
        let is_comment = (line =~ '^#')
        let is_commented_param = (line =~ '^# *[a-z_]\+\zs *= *')
        if is_comment && !is_commented_param
            break
        endif
        let l -= 1
    endwhile
    execute 'normal! ' . (l + 1) . 'G"_dG'
    call append(l, result.url)
    if l == 0
        normal! dd
    else
        call append(l, '')
        normal! jj
    endif
endfunction
