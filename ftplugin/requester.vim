if !has('python')
    echo "vim has to be compiled with '+python' to run this"
    finish
endif

if exists('g:vim_requester_loaded')
    finish
endif

let g:vim_requester_loaded = 1

if !exists('g:vim_requester_default_cmd')
    let g:vim_requester_default_cmd = 'curl -L --silent "{}"'
endif

if !exists('g:vim_requester_default_filetype')
    let g:vim_requester_default_filetype = 'html'
endif

set iskeyword+=@-@

function! s:MakeRequest(request_cmd, url, filetype)
    let cmd = substitute(a:request_cmd, '{}', "\\='" . a:url . "'", '')
    let response = system(cmd)
    let lines = split(response, '\n')

    call utils#FindBufferById('vim_requester.response')

    normal ggdG
    call append(0, lines)
    normal gg

    call utils#SetupScratchBuffer()

    let &filetype=a:filetype
endfunction

function! s:ParseRequestBuffer() abort
    let line_count = line('$')
    let i = 1
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
    let result.url = urlparse#UrlUnparse(url, params)
    return result
endfunction

function! s:RequesterRun()
    let result = s:ParseRequestBuffer()
    let request_cmd = get(result, 'request_cmd', g:vim_requester_default_cmd)
    let filetype = get(result, 'filetype', g:vim_requester_default_filetype)
    call s:MakeRequest(request_cmd, result.url, filetype)
endfunction

function! s:SplitLine() abort
    let request = getline('.')
    let result = urlparse#UrlParse(request)
    let lines = [result.url, '']

    let max_key_len = 0
    for param in result.params
        let max_key_len = max([max_key_len, len(param[0])])
    endfor

    for param in result.params
        let key = utils#RightPad(param[0], max_key_len)
        let value = param[1]
        call add(lines, key . ' = ' . value)
    endfor

    call append(line('.'), lines)
    normal "_dd
endfunction

function! s:JoinLine() abort
    let result = s:ParseRequestBuffer()
    let search = @/
    call cursor(1, 1)
    call search('^[^#]')
    call append(line('.') - 1, result.url)
    normal dG
    let @/ = search
endfunction

nnoremap <Plug>(requester-split-line)
    \ :<C-u>call <SID>SplitLine()<CR>
nnoremap <Plug>(requester-join-line)
    \ :<C-u>call <SID>JoinLine()<CR>
nnoremap <Plug>(requester-do-request)
    \ :<C-u>call <SID>RequesterRun()<CR>

if exists('g:vim_requester_no_mappings')
    finish
endif

nmap <buffer> <Leader>r <Plug>(requester-do-request)
nmap <buffer> <Leader>s <Plug>(requester-split-line)
nmap <buffer> <Leader>j <Plug>(requester-join-line)
