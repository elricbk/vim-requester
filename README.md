# vim-requester

Vim plugin for making requests and editing URLs in Vim.

## Requirements

`+python`
As URL decoding and encoding are done with Python.

## Filetype

Used filetype is `requester` and file extensions is `request`.
I.e. `some_service.request`
Simple syntax highlighting is provided for files (comments, uri and query params).

## Mappings

Following mappings are provided by default

* `nmap <buffer> <Leader>s <Plug>(requester-split-line)` – splits URL into base url and unescaped params (operates on current line). This allows simple editing of params.
* `nmap <buffer> <Leader>j <Plug>(requester-join-line)` – reverses last operations, i.e. for use in browser or sharing with someone. Operates on **whole buffer** (finds first non-comment line, deletes all lines to the end of buffer and inserts composed request).
* `nmap <buffer> <Leader>r <Plug>(requester-do-request)` – run request from buffer (runs join-line operation internally, without modifying buffer and apply `request_cmd` to it)

## Supported options

* `g:vim_requester_default_cmd` – default command to run on provided URL. By default `curl -L --silent "{}"`. Can be overridden with `@request_cmd` keyword in file comments. 
* `g:vim_requester_default_filetype` – default filetype to set on response buffer. By default `html`. Can be overridden with `@filetype` keyword in file comments.
* `g:vim_requester_no_mappings` – disable default mappings. If you are unhappy with default mappings you can use plugin mappings with your keys.
