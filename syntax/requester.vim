if exists('b:current_syntax')
    finish
endif

syntax match requesterValue '\S*'
highlight link requesterValue Constant

syntax match requesterParam '^\s*\S*\s*\ze='
highlight link requesterParam Keyword

syntax match requesterDelimiter "\V\zs=\ze"
highlight link requesterDelimiter Delimiter

syntax keyword requesterKeyword @request_cmd @filetype @no_autoformat contained
highlight link requesterKeyword Identifier

syntax match requesterComment "\v#.*$" contains=requesterKeyword
highlight link requesterComment Comment

syntax match requesterURL /^\([a-z]\+:\/\/\)\?\(\w\+\(:\w\+\)\?@\)\?\([A-Za-z0-9][-_0-9A-Za-z]*\.\)\{1,}\(\w\{2,}\.\?\)\{1,}\(:[0-9]\{1,5}\)\?\S*/
syntax match requesterURL /^\/\w\+\S*/
highlight link requesterURL Underlined

let b:current_syntax = 1
