# vim-requester

Vim plugin for editing long URLs and running them through external commands.

## Rationale

This plugin tries to solve two rather different but related issues.

**First**, it allows you to conveniently edit long URLs.
If you ever tried to debug requests with many query parameters you know that these URLs may be rather ugly.
They may be huge, may use percent encoding, may contain some unnecessary (or sensitive) information.
And editing of these URL isn't as simple as you want it to be.
I've tried a couple of browser extensions and was unhappy with the results.
This plugin provides mappings (and functions) to split URLs (all query parameters go to separate line each) and join URLs (reverse last operation).
This allows you to quickly delete/modify/add query parameters.

**Second**, it allows you to run URLs via external commands.
The simplest (and default) case is getting URL with `curl -L --silent "{}"`.
Curly braces are replaced with URL resulting from join in the first step.
Command output is placed in a scratch buffer.
You can customize command and/or response filetype as you wish.
I.e. use `curl -L --silent "{}" | jq . -` for JSON or `curl -L --silent "{}" | xmllint --format -` for XML.
This gives you all the power of Vim for editing, navigating and folding of resulting response.

## Requirements

`+python`
As URL decoding and encoding are done with Python.

## Functions

These functions can be used with any file type:

* `requester#SplitUrl()` replaces URL in current line with its parsed variant
* `requester#JoinUrl()` replaces visual selection with joined URL

You may want to add some mappings for these functions like:

    nnoremap <Leader>rs :<C-u>call requester#SplitUrl()<CR>
    vnoremap <Leader>rj :<C-u>call requester#JoinUrl()<CR>

## Filetype

Special filetype used is `requester` and corresponding file extension is `request`.
I.e. `some_service.request`
Simple syntax highlighting is provided for files (comments, URL and query parameters).

## Mappings

Following mappings are provided by default for `requester` filetype:

* `nmap <buffer> <Leader>s <Plug>(requester-split-line)` – splits URL into base URL and unescaped parameters (operates on current line).
* `nmap <buffer> <Leader>j <Plug>(requester-join-line)` – reverses split operation. Operates on **whole buffer** (finds first non-comment line, deletes all lines to the end of buffer and inserts composed request).
* `nmap <buffer> <Leader>r <Plug>(requester-do-request)` – run request from buffer (runs join-line operation internally, without modifying buffer and applies `request_cmd` to it)

## Supported options

* `g:vim_requester_default_cmd` – default command to run on provided URL. By default `curl -L --silent "{}"`. Can be overridden with `@request_cmd` keyword in file comments. 
* `g:vim_requester_default_filetype` – default filetype to set on response buffer. By default `html`. Can be overridden with `@filetype` keyword in file comments.
* `g:vim_requester_no_mappings` – disable default mappings. If you are unhappy with default mappings you can use plugin mappings with your keys.
