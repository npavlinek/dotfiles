" Name:         Midnight
" Author:       Niko Pavlinek <niko.pavlinek@gmail.com>
" Maintainer:   Niko Pavlinek <niko.pavlinek@gmail.com>
" License:      Unlicense
" Last Updated: 12 Aug 2022 11:20:21

" Generated by Colortemplate v2.2.0

set background=dark

hi clear
let g:colors_name = 'midnight'

let s:t_Co = exists('&t_Co') && !empty(&t_Co) && &t_Co > 1 ? &t_Co : 1

if (has('termguicolors') && &termguicolors) || has('gui_running')
  let g:terminal_ansi_colors = ['#0c0c0c', '#ff8581', '#00ff00', '#0c0c0c', '#0c0c0c', '#c481ff', '#0c0c0c', '#cccccc', '#0c0c0c', '#ff8581', '#00ff00', '#0c0c0c', '#0c0c0c', '#c481ff', '#0c0c0c', '#cccccc']
endif
hi Comment guifg=#c481ff guibg=#0c0c0c gui=NONE cterm=NONE
hi Constant guifg=#cccccc guibg=#0c0c0c gui=NONE cterm=NONE
hi Cursor guifg=#000000 guibg=#cccccc gui=NONE cterm=NONE
hi CursorLine guifg=#a0a0a0 guibg=#222222 gui=NONE cterm=NONE
hi Error guifg=#0c0c0c guibg=#ff8581 gui=NONE cterm=NONE
hi Identifier guifg=#cccccc guibg=#0c0c0c gui=NONE cterm=NONE
hi IncSearch guifg=#0c0c0c guibg=#c481ff gui=NONE cterm=NONE
hi MatchParen guifg=#ff8581 guibg=#0c0c0c gui=NONE cterm=NONE
hi NonText guifg=#0c0c0c guibg=#0c0c0c gui=NONE cterm=NONE
hi Normal guifg=#a0a0a0 guibg=#0c0c0c gui=NONE cterm=NONE
hi PreProc guifg=#cccccc guibg=#0c0c0c gui=NONE cterm=NONE
hi Special guifg=#cccccc guibg=#0c0c0c gui=NONE cterm=NONE
hi SpellBad guifg=#ff8581 guibg=#0c0c0c gui=underline cterm=underline
hi Statement guifg=#cccccc guibg=#0c0c0c gui=NONE cterm=NONE
hi StatusLine guifg=#cccccc guibg=#000000 gui=NONE cterm=NONE
hi StatusLineNC guifg=#cccccc guibg=#0c0c0c gui=NONE cterm=NONE
hi Title guifg=#c481ff guibg=#0c0c0c gui=bold cterm=bold
hi Todo guifg=#ff8581 guibg=#0c0c0c gui=bold cterm=bold
hi Type guifg=#cccccc guibg=#0c0c0c gui=NONE cterm=NONE
hi VertSplit guifg=#0c0c0c guibg=#0c0c0c gui=NONE cterm=NONE
hi Visual guifg=#a0a0a0 guibg=#222222 gui=NONE cterm=NONE
hi WarningMsg guifg=#ff8581 guibg=#0c0c0c gui=NONE cterm=NONE

if s:t_Co >= 256
  hi Comment ctermfg=177 ctermbg=232 cterm=NONE
  hi Constant ctermfg=252 ctermbg=232 cterm=NONE
  hi Cursor ctermfg=16 ctermbg=252 cterm=NONE
  hi CursorLine ctermfg=247 ctermbg=235 cterm=NONE
  hi Error ctermfg=232 ctermbg=210 cterm=NONE
  hi Identifier ctermfg=252 ctermbg=232 cterm=NONE
  hi IncSearch ctermfg=232 ctermbg=177 cterm=NONE
  hi MatchParen ctermfg=210 ctermbg=232 cterm=NONE
  hi NonText ctermfg=232 ctermbg=232 cterm=NONE
  hi Normal ctermfg=247 ctermbg=232 cterm=NONE
  hi PreProc ctermfg=252 ctermbg=232 cterm=NONE
  hi Special ctermfg=252 ctermbg=232 cterm=NONE
  hi SpellBad ctermfg=210 ctermbg=232 cterm=underline
  hi Statement ctermfg=252 ctermbg=232 cterm=NONE
  hi StatusLine ctermfg=252 ctermbg=16 cterm=NONE
  hi StatusLineNC ctermfg=252 ctermbg=232 cterm=NONE
  hi Title ctermfg=177 ctermbg=232 cterm=bold
  hi Todo ctermfg=210 ctermbg=232 cterm=bold
  hi Type ctermfg=252 ctermbg=232 cterm=NONE
  hi VertSplit ctermfg=232 ctermbg=232 cterm=NONE
  hi Visual ctermfg=247 ctermbg=235 cterm=NONE
  hi WarningMsg ctermfg=210 ctermbg=232 cterm=NONE
  unlet s:t_Co
  finish
endif

" Background: dark
" Color:          black           #000000     ~
" Color:          dark_gray       #a0a0a0     ~
" Color:          darker_gray     #222222     ~
" Color:          gray            #0c0c0c     ~
" Color:          green           #00ff00     ~
" Color:          magenta         #c481ff     ~
" Color:          orange          #ff8581     ~
" Color:          white           #cccccc     ~
" Term Colors:    gray orange green gray gray magenta gray white
" Term Colors:    gray orange green gray gray magenta gray white
" vim: et ts=2 sw=2
