highlight BannerCommands cterm=bold ctermbg=239 ctermfg=108 gui=bold guibg=#504945 guifg=#8ec07c
highlight BannerQuit cterm=bold ctermbg=239 ctermfg=167 gui=bold guibg=#504945 guifg=#fb4934
highlight BannerDesc ctermbg=239 ctermfg=245 guibg=#504945 guifg=#928374
highlight BannerArea ctermbg=239 guibg=#504945
highlight BannerSep ctermfg=239 guifg=#504945


syntax match BannerCommands '\[\zs[eioHsF]\ze\]'
syntax match BannerQuit '\[\zsq\ze\]'
syntax match BannerDesc ' <\zs\(.\{-}\)\ze> '

silent exec 'syntax match BannerSep "['.g:banner_right_sep.g:banner_left_sep.']"'

silent exec 'syntax region BannerArea start="\zs'.g:banner_right_sep.'" end="\ze'.g:banner_left_sep.'" contains=ALL'
