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

setlocal iskeyword+=@-@
setlocal commentstring=\#\%s

nnoremap <Plug>(requester-split-line)
    \ :<C-u>call requester#SplitUrl()<CR>
nnoremap <Plug>(requester-join-line)
    \ :<C-u>call requester#main#JoinLines(1, line('$'))<CR>
nnoremap <Plug>(requester-do-request)
    \ :<C-u>call requester#main#RequesterRun()<CR>

if exists('g:vim_requester_no_mappings')
    finish
endif

nmap <buffer> <Leader>r <Plug>(requester-do-request)
nmap <buffer> <Leader>s <Plug>(requester-split-line)
nmap <buffer> <Leader>j <Plug>(requester-join-line)
