" Splits URL in line under cursor
function! requester#SplitUrl() abort
    let request = getline('.')
    let result = requester#urlparse#UrlParse(request)
    let lines = [result.url, '']

    let max_key_len = 0
    for param in result.params
        let max_key_len = max([max_key_len, len(param[0])])
    endfor

    for param in result.params
        let key = requester#utils#RightPad(param[0], max_key_len)
        let value = param[1]
        call add(lines, key . ' = ' . value)
    endfor

    call append(line('.'), lines)
    normal! "_dd
endfunction

" Replaces last selection with URL builded from this selection
function! requester#JoinUrl() abort
    let result = requester#main#ParseRequestLines(line("'<"), line("'>"))
    let a = @a
    let @a = result.url
    normal! gv"ap
    let @a = a
endfunction
