function! requester#urlparse#UrlParse(request)
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
params.extend(
    urlparse.parse_qsl(
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

