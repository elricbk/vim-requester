if !has('python3')
    echo "vim has to be compiled with '+python3' to run this"
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
    let g:vim_requester_default_filetype = 'txt'
endif
