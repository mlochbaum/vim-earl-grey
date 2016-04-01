" Vim syntax file
" Language:	Earl Grey
" Maintainer:	Marshall Lochbaum <mwlochbaum@gmail.com>
" Last Change:	2016 Mar 31
"

if version < 600
    syntax clear
elseif exists("b:current_syntax")
    finish
endif

" We need nocompatible mode in order to continue lines with backslashes.
" Original setting will be restored.
let s:cpo_save = &cpo
set cpo&vim

" Alphabetic, numeric, - $ _
syn iskeyword @,48-57,-,$,_

" Regexes which can be reused
" Identifier
" [a-zA-Z$_][a-zA-Z$_\-0-9]*
let s:id_regex  = "[a-zA-Z$_][a-zA-Z$_\\-0-9]*"
" Character operator
" [+\\\-*/~\^<>=%&|?!@#:]\+
let s:op1_regex = "[+\\\\\\-*/~\\^<>=%&|?!@#:]\\+"
" Keyword operator
" \(as\|and\|each\|in\|is\|mod\|not\|of\|or\|when\|where\|with\)[+\*/\~\^<>=%&|?!@#.:]*[^a-zA-Z$_\-0-9]\@=
let s:op2_words = "\\(as\\|and\\|each\\|in\\|is\\|mod\\|not\\|of\\|or\\|when\\|where\\|with\\)"
let s:op2_regex = s:op2_words ."[+\\*/\\~\\^<>=%&|?!@#.:]*[^a-zA-Z$_\\-0-9]\\@="


" Earl Grey groups
" Note that the order is opposite to that used by the lexer
" (Although this only matters for a few groups)

" Error (any unmatched character other than a space or newline
syn match   egError "[^ \r\n]\+"

" Punctuation
" Semicolon
syn match   egSemicolon ";"
" Brackets
syn match   egBracket "[([{}\])]"
" Comma
syn match   egComma ","
" Dots
syn match   egDots "\.\+"
" Line continuation
syn match   egLineContinue "^\\"

" Comment
syn match   egComment ";;.*$" contains=egTodo
syn keyword egTodo FIXME TODO XXX contained

" Hashbang
syn match   egHashBang "!#.*$"

" Quasiquote
" Single quote
syn region  egQuasi matchgroup=egQuasiQuote
      \ start="`" end="`" skip="\\\\\|\\`"
" Triple quote
syn region  egQuasi matchgroup=egTripleQuasiQuote
      \ start="```" end="```" keepend

" Strings
" Single quotes may contain interpolations
syn match   egInterp "{.*}" contained
syn region  egString matchgroup=egSingleQuote
      \ start=+'+ end=+'+ skip=+\\\\\|\\\'+
      \ contains=egInterp
" Double quote
syn region  egString matchgroup=egDoubleQuote
      \ start=+"+ end=+"+ skip=+\\\\\|\\\"+
" Triple quote
syn region  egString matchgroup=egTripleQuote
      \ start=+\z('''\|"""\)+ end="\z1" keepend
" Dotstring
exec "syn match egDotString `\\.". s:id_regex ."`"
" Regular expressions
"syn region  egRegexp matchgroup=egDoubleQuote
"      \ start=+R"+ end=+"+ skip=+\\\\\|\\\"+

" Number
syn match   egNumber "\d[0-9_]*\(\.\d\+\)\?\([eE][+-]\?\d\+\)\?"
" Arbitrary base
syn match   egNumber "\d\+[rR][a-zA-Z0-9_]*\(\.[0-9_]\+\)\?"


" Identifier
exec "syn match egIdentifier `". s:id_regex ."`"
" Identifier followed by :
" Used to suppress function: after an operator or function
exec "syn match egIdentifierColon `". s:id_regex ."\\ze:`"
hi link egIdentifierColon egIdentifier

" Function
" Keywords
syn keyword egFunction await break chain continue else expr-value match return yield
  \ skipwhite nextgroup=egIdentifierColon
" Identifier followed by identifier, number, or string
exec "syn match egFunction `". s:id_regex ."\\ze\\s\\+[a-zA-Z0-9$_'\".({[]`"
  \ ." skipwhite nextgroup=egIdentifierColon"
" Identifier followed by character operator
" (operator followed by space is suppressed later)
exec "syn match egFunction `". s:id_regex ."\\ze\\s\\+". s:op1_regex ."`"
" Identifier followed by colon
exec "syn match egFunction `". s:id_regex ."\\ze:`"

" An identifier followed by a keyword operator or operator with space
" is not a function
exec "syn match egIdentifier `". s:id_regex ."\\ze\\s\\+"
  \ ."\\(". s:op2_regex ."\\|". s:op1_regex ."\\s\\)`"


" Operator
exec "syn match egOperator `\\(". s:op1_regex ."\\|". s:op2_regex ."\\)`"
  \ ." skipwhite nextgroup=egIdentifierColon"
" Low-precedence operators don't have nextgroup clause
syn match   egOperator `\(->\|=>\|%\)\ze[^+\\\-*/~\^<>=%&|?!@#:]`
syn match   egOperator `\(each\|each\*\|where\|with\)\ze\s`
" Operator ending in =
syn match   egOperator `[+\\\-*/~\^<>=%&|?!@#:]*=\ze[^+\\\-*/~\^<>=%&|?!@#:]`
exec "syn match egOperator `". s:op2_words ."[+\\*/\\~\\^<>=%&|?!@#.:]*=\\ze\\s`"

" Chain
exec "syn match egChain `@\\(". s:id_regex ."\\)\\?`"

" Various functions
exec "syn match egHash `#". s:id_regex ."`"

unlet s:id_regex s:op1_regex s:op2_regex s:op2_words


if !exists("did_eg_syntax_inits")
  let did_eg_syn_inits = 1
  hi link egError               Error
  hi link egSemicolon           Delimiter
  hi link egBracket             Delimiter
  hi link egComma               Delimiter
  hi link egDots                Delimiter
  hi link egLineContinue        Delimiter
  hi link egComment             Comment
  hi link egTodo                Todo
  hi link egHashBang            Comment
  hi link egQuasi               Macro
  hi link egQuasiQuote          Macro
  hi link egTripleQuasiQuote    Macro
  hi link egInterp              Special
  hi link egString              String
  hi link egSingleQuote         String
  hi link egDoubleQuote         String
  hi link egTripleQuote         String
  hi link egDotString           Special
  hi link egNumber              Number
  hi link egIdentifier          Normal
  hi link egFunction            Type
  hi link egOperator            Operator
  hi link egChain               Constant
  hi link egHash                Type
endif

let b:current_syntax = "earlgrey"

let &cpo = s:cpo_save
unlet s:cpo_save

" vim:set sw=2 sts=2 ts=8 noet:
