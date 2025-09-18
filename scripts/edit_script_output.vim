" vim commands for doing weird stuff
:redir @">|silent messages|redir END|enew|put
" replace repeated number in columnar mode with incremental values.
g+<ctrl-a>
" example below is \= right after replace starts `s//\=` then submatch([0-9]) and printf("%d") and line('.') for line number etc...
" Go to start
" let i=line('.')
" then ...
" so %s/test/\=submatch(0).printf("_%d", 1+line('.')-i)/
" or %s/test/\=printf("%s_%d", submatch(10), 1+line('.')-i)/
