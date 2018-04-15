if !has('python')
    echo "vim has to be compiled with '+python' to run this"
    finish
endif

function! MakeRequest(request_cmd, url, filetype)
    let cmd = substitute(a:request_cmd, '{}', "\\='" . a:url . "'", '')
    let response = system(cmd)
    let lines = split(response, '\n')

    let buffer_id = 'vim_requester.response'
    if (bufexists(buffer_id))
        let mpcwin = bufwinnr(buffer_id) 
        if (mpcwin == -1)
            execute "vs | buffer " . bufnr(buffer_id)
        else
            execute mpcwin . 'wincmd w'
        endif
    else
        execute "vnew " . buffer_id
        setlocal buftype=nofile
        setlocal bufhidden=hide
        setlocal noswapfile
    endif
    let &filetype=a:filetype

    normal ggdG
    call append(0, lines)
    normal gg
endfunction

function! UrlParse(request)
    let l:url_wrapper = []
    let l:params = []

python << endpython
import vim
request = vim.eval('a:request')
url_wrapper = vim.bindeval('l:url_wrapper')
params = vim.bindeval('l:params')

import urlparse

parse_result = urlparse.urlparse(request)
url_wrapper.extend([
    urlparse.urlunparse(parse_result._replace(query=''))
])
params.extend(urlparse.parse_qsl(parse_result.query))
endpython

    let result = {}
    let result.url = url_wrapper[0]
    let result.params = params

    return result
endfunction

function! UrlUnparse(url, params) abort
    let result_wrapper = []
python << endpython
import vim
url = vim.eval('a:url')
param_string = vim.eval('a:params')
result_wrapper = vim.bindeval('l:result_wrapper')
params = []
for p in param_string:
    key, value = map(str.strip, p.split('=', 1))
    params.append((key, value))

import urllib

query = urllib.urlencode(params).replace('+', '%20')

if len(query) > 0:
    result_wrapper.extend([url + '?' + query])
else:
    result_wrapper.extend([url])
endpython

    return result_wrapper[0]
endfunction

function! ParseRequestBuffer() abort
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
            let param = substitute(l, '^[a-z_]\+\zs *= *', '=', '')
            call add(params, param)
        endif
        let i += 1
    endwhile
    let result.url = UrlUnparse(url, params)
    return result
endfunction

function! RequesterRun()
    let result = ParseRequestBuffer()
    let request_cmd = get(result, 'request_cmd', 'curl -L --silent "{}"')
    let filetype = get(result, 'filetype', 'html')
    call MakeRequest(request_cmd, result.url, filetype)
endfunction

function! RightPad(str, len)
    if len(a:str) >= a:len
        return a:str
    endif
    return a:str . repeat(' ', a:len - len(a:str))
endfunction

function! SplitLine() abort
    let request = getline('.')
    let result = UrlParse(request)
    let lines = [result.url, '']

    let max_key_len = 0
    for param in result.params
        let max_key_len = max([max_key_len, len(param[0])])
    endfor

    for param in result.params
        let key = RightPad(param[0], max_key_len)
        let value = param[1]
        call add(lines, key . ' = ' . value)
    endfor

    call append(line('.'), lines)
    normal "_dd
endfunction

function! JoinLine() abort
    let result = ParseRequestBuffer()
    call append(line('.'), result.url)
endfunction
