" Name:         Midnight
" Author:       Niko Pavlinek <niko.pavlinek@gmail.com>
" Maintainer:   Niko Pavlinek <niko.pavlinek@gmail.com>
" License:      Unlicense
" Last Updated: 23 Aug 2022 06:14:51

" Generated by Colortemplate v2.2.0

set background=dark

hi clear
let g:colors_name = 'midnight'

let s:t_Co = exists('&t_Co') ? (&t_Co ?? 0) : -1

if (has('termguicolors') && &termguicolors) || has('gui_running')
  let g:terminal_ansi_colors = ['#0c0c0c', '#ff544e', '#00ff00', '#ffcc00', '#0000ff', '#ac4eff', '#00c4c4', '#cccccc', '#222222', '#ff8581', '#33ff33', '#ffd633', '#3333ff', '#c481ff', '#00f7f7', '#a0a0a0']
endif
hi Comment guifg=#c481ff guibg=#0c0c0c gui=NONE cterm=NONE
hi Constant guifg=#cccccc guibg=#0c0c0c gui=NONE cterm=NONE
hi Cursor guifg=#0c0c0c guibg=#cccccc gui=NONE cterm=NONE
hi CursorLine guifg=NONE guibg=#222222 gui=NONE cterm=NONE
hi Error guifg=#0c0c0c guibg=#ff544e gui=NONE cterm=NONE
hi Identifier guifg=#cccccc guibg=#0c0c0c gui=NONE cterm=NONE
hi MatchParen guifg=#ff544e guibg=#0c0c0c gui=NONE cterm=NONE
hi NonText guifg=#0c0c0c guibg=#0c0c0c gui=NONE cterm=NONE
hi Normal guifg=#a0a0a0 guibg=#0c0c0c gui=NONE cterm=NONE
hi PreProc guifg=#cccccc guibg=#0c0c0c gui=bold cterm=bold
hi Special guifg=#cccccc guibg=#0c0c0c gui=NONE cterm=NONE
hi SpellBad guifg=#ff544e guibg=#0c0c0c gui=NONE cterm=NONE
hi Statement guifg=#cccccc guibg=#0c0c0c gui=NONE cterm=NONE
hi StatusLine guifg=#cccccc guibg=#222222 gui=NONE cterm=NONE
hi StatusLineNC guifg=#cccccc guibg=#0c0c0c gui=NONE cterm=NONE
hi Title guifg=#c481ff guibg=#0c0c0c gui=bold cterm=bold
hi Todo guifg=#ff8581 guibg=#0c0c0c gui=bold cterm=bold
hi Type guifg=#cccccc guibg=#0c0c0c gui=NONE cterm=NONE
hi VertSplit guifg=#0c0c0c guibg=#0c0c0c gui=NONE cterm=NONE
hi Visual guifg=#a0a0a0 guibg=#222222 gui=NONE cterm=NONE
hi WarningMsg guifg=#ff544e guibg=#0c0c0c gui=NONE cterm=NONE

if s:t_Co >= 256
  hi Comment ctermfg=177 ctermbg=232 cterm=NONE
  hi Constant ctermfg=252 ctermbg=232 cterm=NONE
  hi Cursor ctermfg=232 ctermbg=252 cterm=NONE
  hi CursorLine ctermfg=NONE ctermbg=235 cterm=NONE
  hi Error ctermfg=232 ctermbg=203 cterm=NONE
  hi Identifier ctermfg=252 ctermbg=232 cterm=NONE
  hi MatchParen ctermfg=203 ctermbg=232 cterm=NONE
  hi NonText ctermfg=232 ctermbg=232 cterm=NONE
  hi Normal ctermfg=247 ctermbg=232 cterm=NONE
  hi PreProc ctermfg=252 ctermbg=232 cterm=bold
  hi Special ctermfg=252 ctermbg=232 cterm=NONE
  hi SpellBad ctermfg=203 ctermbg=232 cterm=NONE
  hi Statement ctermfg=252 ctermbg=232 cterm=NONE
  hi StatusLine ctermfg=252 ctermbg=235 cterm=NONE
  hi StatusLineNC ctermfg=252 ctermbg=232 cterm=NONE
  hi Title ctermfg=177 ctermbg=232 cterm=bold
  hi Todo ctermfg=210 ctermbg=232 cterm=bold
  hi Type ctermfg=252 ctermbg=232 cterm=NONE
  hi VertSplit ctermfg=232 ctermbg=232 cterm=NONE
  hi Visual ctermfg=247 ctermbg=235 cterm=NONE
  hi WarningMsg ctermfg=203 ctermbg=232 cterm=NONE
  unlet s:t_Co
  finish
endif

" Background: dark
" Color:  black   #0c0c0c ~
" Color:  red     #ff544e ~
" Color:  green   #00ff00 ~
" Color:  yellow  #ffcc00 ~
" Color:  blue    #0000ff ~
" Color:  magenta #ac4eff ~
" Color:  cyan    #00c4c4 ~
" Color:  white   #cccccc ~
" Color:  bright_black    #222222 ~
" Color:  bright_red      #ff8581 ~
" Color:  bright_green    #33ff33 ~
" Color:  bright_yellow   #ffd633 ~
" Color:  bright_blue     #3333ff ~
" Color:  bright_magenta  #c481ff ~
" Color:  bright_cyan     #00f7f7 ~
" Color:  bright_white    #a0a0a0 ~
" Term Colors:  black red green yellow blue magenta cyan white
" Term Colors:  bright_black bright_red bright_green bright_yellow
" Term Colors:  bright_blue bright_magenta bright_cyan bright_white
" vim: et ts=2 sw=2
