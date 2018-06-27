function! requester#parser#ParseRequestLines(begin, end) abort
    let REQUEST_CMD_RGX = '^# \+@request_cmd \+'
    let FILETYPE_RGX = '^# \+@filetype \+'
    let NO_AUTOFORMAT_RGX = '^# \+@no_autoformat'
    let URL_RGX = '\v^ *(([-a-zA-Z0-9]+\.)+[-a-zA-Z0-9]+|.*://.*|/.*) *$'
    let PARAM_RGX = '^[a-z_]\+\zs *= *'

    let result = {}
    let url = ''
    let params = []
    let i = a:begin
    while i <= a:end
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

