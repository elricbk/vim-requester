if exists('b:current_syntax')
    finish
endif

syntax match requestValue '\S*'
highlight link requestValue Constant

syntax match requestParam '^\s*\S*\s*\ze='
highlight link requestParam Keyword

syntax match requestDelimiter "\V\zs=\ze"
highlight link requestDelimiter Delimiter

syntax keyword requestKeyword @request_cmd @filetype contained
highlight link requestKeyword Identifier

syntax match requestComment "\v#.*$" contains=requestKeyword
highlight link requestComment Comment

syntax match requesterURL /^[a-z]\+:\/\/\(\w\+\(:\w\+\)\?@\)\?\([A-Za-z0-9][-_0-9A-Za-z]*\.\)\{1,}\(\w\{2,}\.\?\)\{1,}\(:[0-9]\{1,5}\)\?\S*/
highlight link requesterURL Underlined

let b:current_syntax = 1
