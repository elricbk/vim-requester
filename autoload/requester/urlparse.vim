function! requester#urlparse#UrlParse(request)
    let l:url_wrapper = []
    let l:params = []

python3 << endpython
import vim
request = vim.eval('a:request')
url_wrapper = vim.bindeval('l:url_wrapper')
params = vim.bindeval('l:params')

import urllib.parse

parse_result = urllib.parse.urlparse(request)
url_wrapper.extend([
    urllib.parse.urlunparse(parse_result._replace(query=''))
])
params.extend(
    urllib.parse.parse_qsl(
        parse_result.query.replace(';', '%3B'),
        keep_blank_values=True
    )
)
endpython

    let result = {}
    let result.url = url_wrapper[0]
    let result.params = params

    return result
endfunction

function! requester#urlparse#UrlUnparse(url, params) abort
    let result_wrapper = []
python3 << endpython
import vim
url = vim.eval('a:url')
param_string = vim.eval('a:params')
result_wrapper = vim.bindeval('l:result_wrapper')
params = []
for p in param_string:
    key, value = map(str.strip, p.split('=', 1))
    params.append((key, value))

import urllib.parse

query = urllib.parse.urlencode(params).replace('+', '%20')

if len(query) > 0:
    result_wrapper.extend([url + '?' + query])
else:
    result_wrapper.extend([url])
endpython

    return result_wrapper[0]
endfunction

