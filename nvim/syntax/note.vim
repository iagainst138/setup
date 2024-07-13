syntax match NoteHeader /^\*\*\* .* \*\*\*$/
syntax match NoteBullet /^\s.\{-}[-\*] /
syntax match NoteQuestion /^[a-zA-Z].*?$/

highlight NoteHeader ctermfg=green guifg=#00ff00 "ctermbg=white guibg=#eefbfd
"highlight NoteBullet ctermfg=cyan guifg=#00ffff "ctermbg=white guibg=#eefbfd
highlight NoteBullet ctermfg=magenta guifg=#ff00ff "ctermbg=white guibg=#eefbfd
"highlight NoteQuestion ctermfg=magenta guifg=#ff00ff "ctermbg=white guibg=#eefbfd
highlight NoteQuestion ctermfg=yellow guifg=#ffff00 "ctermbg=white guibg=#eefbfd
