function! requester#main#Autoformat() abort
    normal! gg=G
endfunction

function! requester#main#RequesterRun() abort
    call requester#request#MakeRequest(
    \    requester#parser#ParseRequestLines(1, line('$')),
    \    function('system'),
    \    function('requester#main#Autoformat'),
    \)
endfunction

function! requester#main#JoinLines() abort
    let result = requester#parser#ParseRequestLines(1, line('$'))
    let l = requester#utils#FindLastCommentLine()
    execute 'normal! ' . (l + 1) . 'G"_dG'
    call append(l, result.url)
    if l == 0
        normal! dd
    else
        call append(l, '')
        normal! jj
    endif
endfunction
