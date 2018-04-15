# vim-requester
Vim plugin for making requests and editing URLs in Vim

For now basic support for functions:
* `SplitLine()` splits URL into base url and decoded params
* `JoinLine()` reverses last operation
* `RequesterRun()` internally joins request and then runs requester cmd pasting response in scratch buffer
