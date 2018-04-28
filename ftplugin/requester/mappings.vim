nnoremap <Plug>(requester-split-line)
    \ :<C-u>call requester#SplitUrl()<CR>
nnoremap <Plug>(requester-join-line)
    \ :<C-u>call requester#main#JoinLines(1, line('$'))<CR>
nnoremap <Plug>(requester-do-request)
    \ :<C-u>call requester#main#RequesterRun()<CR>

if exists('g:vim_requester_no_mappings')
    finish
endif

nmap <buffer> <Leader>r <Plug>(requester-do-request) |
nmap <buffer> <Leader>s <Plug>(requester-split-line) |
nmap <buffer> <Leader>j <Plug>(requester-join-line)
