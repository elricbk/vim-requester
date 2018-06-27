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

    let l = line('$')
    while l >= 1
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
