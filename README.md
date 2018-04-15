# vim-requester

Vim plugin for making requests and editing URLs in Vim.

## Rationale

This plugin does two rather different but connected things.

**First**, it allows you to conveniently edit long and encoded URLs.
If you from time to time need to debug some requests to (usually) internal services you know that URLs may get ugly.
They may be huge, may use percent encoding, may contain some unnecessary (or sensitive) information.
And editing of these URL is not very easy.
I've tried a couple of browser extensions and was unhappy with results.
So here we have a couple of bindings to split request (all query parameters go to separate line each) and join request (reverse last operation).
This allows you to quickly delete/modify/add query parameters.

**Second**, it allows you to run resulting request via some command.
The simplest (and default) case is getting URL with `curl -L --silent "{}"`.
Curly braces are replaced with resulting URL.
The output of command is placed in a scratch buffer.
You may set filetype for response (to have nicely highlighted HTML/XML/JSON/whatever).
You can customize command and/or resulting filetype as you wish.
I.e. use `curl -L --silent "{}" | jq . -` for JSON or `curl -L --silent "{}" | xmllint --format -` for XML.
This gives you all the power of Vim for editing, navigating and folding of resulting response.
Also it allows you to debug some internal binary protocols if they have some textual representations (ProtoBuf/Thrift/etc.).

## Requirements

`+python`
As URL decoding and encoding are done with Python.

## Filetype

Used filetype is `requester` and file extensions is `request`.
I.e. `some_service.request`
Simple syntax highlighting is provided for files (comments, URL and query parameters).

## Mappings

Following mappings are provided by default

* `nmap <buffer> <Leader>s <Plug>(requester-split-line)` – splits URL into base URL and unescaped parameters (operates on current line).
* `nmap <buffer> <Leader>j <Plug>(requester-join-line)` – reverses last operations, i.e. for use in browser or sharing with someone. Operates on **whole buffer** (finds first non-comment line, deletes all lines to the end of buffer and inserts composed request).
* `nmap <buffer> <Leader>r <Plug>(requester-do-request)` – run request from buffer (runs join-line operation internally, without modifying buffer and apply `request_cmd` to it)

## Supported options

* `g:vim_requester_default_cmd` – default command to run on provided URL. By default `curl -L --silent "{}"`. Can be overridden with `@request_cmd` keyword in file comments. 
* `g:vim_requester_default_filetype` – default filetype to set on response buffer. By default `html`. Can be overridden with `@filetype` keyword in file comments.
* `g:vim_requester_no_mappings` – disable default mappings. If you are unhappy with default mappings you can use plugin mappings with your keys.
