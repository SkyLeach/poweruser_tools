""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" JIRA autocompletion for Caregility (this time)
" SkyLeach Note: can be set per-buffer with b: instead of global g:
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" nmap <silent> <unique> <leader>jj <Plug>JiraComplete
" NOTE: if cert issue, change to dict with verify=false {'url': "", 'verify':
" false}
" let g:jiracomplete_url = 'http://https://caregilitycore.atlassian.net/jira/projects/'
" let g:jiracomplete_username = 'mgregory@caregility.com'
" again, [b,g] buffer/global and format for variables is adjustable
" let g:jiracomplete_format = 'v:val.abbr . " -> " . v:val.menu'
" let g:jiracomplete_password = ''  " optional - manual for now?
