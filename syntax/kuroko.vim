" Vim syntax file
" Language:	Kuroko

" quit when a syntax file was already loaded.
if exists("b:current_syntax")
  finish
endif

" We need nocompatible mode in order to continue lines with backslashes.
" Original setting will be restored.
let s:cpo_save = &cpo
set cpo&vim

if exists("kuroko_no_doctest_highlight")
  let kuroko_no_doctest_code_highlight = 1
endif

if exists("kuroko_highlight_all")
  if exists("kuroko_no_builtin_highlight")
    unlet kuroko_no_builtin_highlight
  endif
  if exists("kuroko_no_doctest_code_highlight")
    unlet kuroko_no_doctest_code_highlight
  endif
  if exists("kuroko_no_doctest_highlight")
    unlet kuroko_no_doctest_highlight
  endif
  if exists("kuroko_no_exception_highlight")
    unlet kuroko_no_exception_highlight
  endif
  if exists("kuroko_no_number_highlight")
    unlet kuroko_no_number_highlight
  endif
  let kuroko_space_error_highlight = 1
endif

" Keep Kuroko keywords in alphabetical order inside groups for easy
" The list can be checked using:
"
syn keyword kurokoStatement	False None True
syn keyword kurokoStatement	as assert break continue del global let
syn keyword kurokoStatement	lambda nonlocal pass return with yield
syn keyword kurokoStatement	class def nextgroup=kurokoFunction skipwhite
syn keyword kurokoConditional	elif else if
syn keyword kurokoRepeat	for while
syn keyword kurokoOperator	and in is not or
syn keyword kurokoException	except finally raise try
syn keyword kurokoInclude	from import
syn keyword kurokoAsync		async await

" Decorators
" A dot must be allowed because of @MyClass.myfunc decorators.
syn match   kurokoDecorator	"@" display contained
syn match   kurokoDecoratorName	"@\s*\h\%(\w\|\.\)*" display contains=kurokoDecorator

" Single line multiplication.
syn match   kurokoMatrixMultiply
      \ "\%(\w\|[])]\)\s*@"
      \ contains=ALLBUT,kurokoDecoratorName,kurokoDecorator,kurokoFunction,kurokoDoctestValue
      \ transparent
" Multiplication continued on the next line after backslash.
syn match   kurokoMatrixMultiply
      \ "[^\\]\\\s*\n\%(\s*\.\.\.\s\)\=\s\+@"
      \ contains=ALLBUT,kurokoDecoratorName,kurokoDecorator,kurokoFunction,kurokoDoctestValue
      \ transparent
" Multiplication in a parenthesized expression over multiple lines with @ at
syn match   kurokoMatrixMultiply
      \ "^\s*\%(\%(>>>\|\.\.\.\)\s\+\)\=\zs\%(\h\|\%(\h\|[[(]\).\{-}\%(\w\|[])]\)\)\s*\n\%(\s*\.\.\.\s\)\=\s\+@\%(.\{-}\n\%(\s*\.\.\.\s\)\=\s\+@\)*"
      \ contains=ALLBUT,kurokoDecoratorName,kurokoDecorator,kurokoFunction,kurokoDoctestValue
      \ transparent

syn match   kurokoFunction	"\h\w*" display contained

syn match   kurokoComment	"#.*$" contains=kurokoTodo,@Spell
syn keyword kurokoTodo		FIXME NOTE NOTES TODO XXX contained

" Triple-quoted strings can contain doctests.
syn region  kurokoString matchgroup=kurokoQuotes
      \ start=+[uU]\=\z(['"]\)+ end="\z1" skip="\\\\\|\\\z1"
      \ contains=kurokoEscape,@Spell
syn region  kurokoString matchgroup=kurokoTripleQuotes
      \ start=+[uU]\=\z('''\|"""\)+ end="\z1" keepend
      \ contains=kurokoEscape,kurokoSpaceError,kurokoDoctest,@Spell
syn region  kurokoRawString matchgroup=kurokoQuotes
      \ start=+[uU]\=[rR]\z(['"]\)+ end="\z1" skip="\\\\\|\\\z1"
      \ contains=@Spell
syn region  kurokoRawString matchgroup=kurokoTripleQuotes
      \ start=+[uU]\=[rR]\z('''\|"""\)+ end="\z1" keepend
      \ contains=kurokoSpaceError,kurokoDoctest,@Spell

syn match   kurokoEscape	+\\[abfnrtv'"\\]+ contained
syn match   kurokoEscape	"\\\o\{1,3}" contained
syn match   kurokoEscape	"\\x\x\{2}" contained
syn match   kurokoEscape	"\%(\\u\x\{4}\|\\U\x\{8}\)" contained
" Python allows case-insensitive Unicode IDs: http://www.unicode.org/charts/
syn match   kurokoEscape	"\\N{\a\+\%(\s\a\+\)*}" contained
syn match   kurokoEscape	"\\$"

" It is very important to understand all details before changing the
" regular expressions below or their order.
" The word boundaries are *not* the floating-point number boundaries
" because of a possible leading or trailing decimal point.
" The expressions below ensure that all valid number literals are
" highlighted, and invalid number literals are not.  For example,
"
" - a decimal point in '4.' at the end of a line is highlighted,
" - a second dot in 1.0.0 is not highlighted,
" - 08 is not highlighted,
" - 08e0 or 08j are highlighted,
"
if !exists("kuroko_no_number_highlight")
  " numbers (including longs and complex)
  syn match   kurokoNumber	"\<0[oO]\=\o\+[Ll]\=\>"
  syn match   kurokoNumber	"\<0[xX]\x\+[Ll]\=\>"
  syn match   kurokoNumber	"\<0[bB][01]\+[Ll]\=\>"
  syn match   kurokoNumber	"\<\%([1-9]\d*\|0\)[Ll]\=\>"
  syn match   kurokoNumber	"\<\d\+[jJ]\>"
  syn match   kurokoNumber	"\<\d\+[eE][+-]\=\d\+[jJ]\=\>"
  syn match   kurokoNumber
	\ "\<\d\+\.\%([eE][+-]\=\d\+\)\=[jJ]\=\%(\W\|$\)\@="
  syn match   kurokoNumber
	\ "\%(^\|\W\)\zs\d*\.\d\+\%([eE][+-]\=\d\+\)\=[jJ]\=\>"
endif

" built-ins
if !exists("kuroko_no_builtin_highlight")
  " built-in constants
  " 'False', 'True', and 'None' are also reserved words in Python 3
  syn keyword kurokoBuiltin	False True None
  syn keyword kurokoBuiltin	NotImplemented Ellipsis __debug__
  " constants added by the `site` module
  syn keyword kurokoBuiltin	quit exit copyright credits license
  " built-in functions
  syn keyword kurokoBuiltin	abs all any ascii bin bool breakpoint bytearray
  syn keyword kurokoBuiltin	bytes callable chr classmethod compile complex
  syn keyword kurokoBuiltin	delattr dict dir divmod enumerate eval exec
  syn keyword kurokoBuiltin	filter float format frozenset getattr globals
  syn keyword kurokoBuiltin	hasattr hash help hex id input int isinstance
  syn keyword kurokoBuiltin	issubclass iter len list locals map max
  syn keyword kurokoBuiltin	memoryview min next object oct open ord pow
  syn keyword kurokoBuiltin	print property range repr reversed round set
  syn keyword kurokoBuiltin	setattr slice sorted staticmethod str sum super
  syn keyword kurokoBuiltin	tuple type vars zip __import__
  " avoid highlighting attributes as builtins
  syn match   kurokoAttribute	/\.\h\w*/hs=s+1
	\ contains=ALLBUT,kurokoBuiltin,kurokoFunction,kurokoAsync
	\ transparent
endif

" From the 'Python Library Reference' class hierarchy at the bottom.
" http://docs.kuroko.org/library/exceptions.html
if !exists("kuroko_no_exception_highlight")
  " builtin base exceptions (used mostly as base classes for other exceptions)
  syn keyword kurokoExceptions	BaseException Exception
  syn keyword kurokoExceptions	ArithmeticError BufferError LookupError
  " builtin exceptions (actually raised)
  syn keyword kurokoExceptions	AssertionError AttributeError EOFError
  syn keyword kurokoExceptions	FloatingPointError GeneratorExit ImportError
  syn keyword kurokoExceptions	IndentationError IndexError KeyError
  syn keyword kurokoExceptions	KeyboardInterrupt MemoryError
  syn keyword kurokoExceptions	ModuleNotFoundError NameError
  syn keyword kurokoExceptions	NotImplementedError OSError OverflowError
  syn keyword kurokoExceptions	RecursionError ReferenceError RuntimeError
  syn keyword kurokoExceptions	StopAsyncIteration StopIteration SyntaxError
  syn keyword kurokoExceptions	SystemError SystemExit TabError TypeError
  syn keyword kurokoExceptions	UnboundLocalError UnicodeDecodeError
  syn keyword kurokoExceptions	UnicodeEncodeError UnicodeError
  syn keyword kurokoExceptions	UnicodeTranslateError ValueError
  syn keyword kurokoExceptions	ZeroDivisionError
  " builtin exception aliases for OSError
  syn keyword kurokoExceptions	EnvironmentError IOError WindowsError
  " builtin OS exceptions in Python 3
  syn keyword kurokoExceptions	BlockingIOError BrokenPipeError
  syn keyword kurokoExceptions	ChildProcessError ConnectionAbortedError
  syn keyword kurokoExceptions	ConnectionError ConnectionRefusedError
  syn keyword kurokoExceptions	ConnectionResetError FileExistsError
  syn keyword kurokoExceptions	FileNotFoundError InterruptedError
  syn keyword kurokoExceptions	IsADirectoryError NotADirectoryError
  syn keyword kurokoExceptions	PermissionError ProcessLookupError TimeoutError
  " builtin warnings
  syn keyword kurokoExceptions	BytesWarning DeprecationWarning FutureWarning
  syn keyword kurokoExceptions	ImportWarning PendingDeprecationWarning
  syn keyword kurokoExceptions	ResourceWarning RuntimeWarning
  syn keyword kurokoExceptions	SyntaxWarning UnicodeWarning
  syn keyword kurokoExceptions	UserWarning Warning
endif

if exists("kuroko_space_error_highlight")
  " trailing whitespace
  syn match   kurokoSpaceError	display excludenl "\s\+$"
  " mixed tabs and spaces
  syn match   kurokoSpaceError	display " \+\t"
  syn match   kurokoSpaceError	display "\t\+ "
endif

" Do not spell doctests inside strings.
" Notice that the end of a string, either ''', or """, will end the contained
" doctest too.  Thus, we do *not* need to have it as an end pattern.
if !exists("kuroko_no_doctest_highlight")
  if !exists("kuroko_no_doctest_code_highlight")
    syn region kurokoDoctest
	  \ start="^\s*>>>\s" end="^\s*$"
	  \ contained contains=ALLBUT,kurokoDoctest,kurokoFunction,@Spell
    syn region kurokoDoctestValue
	  \ start=+^\s*\%(>>>\s\|\.\.\.\s\|"""\|'''\)\@!\S\++ end="$"
	  \ contained
  else
    syn region kurokoDoctest
	  \ start="^\s*>>>" end="^\s*$"
	  \ contained contains=@NoSpell
  endif
endif

" Sync at the beginning of class, function, or method definition.
syn sync match kurokoSync grouphere NONE "^\%(def\|class\)\s\+\h\w*\s*[(:]"

" The default highlight links.  Can be overridden later.
hi def link kurokoStatement		Statement
hi def link kurokoConditional		Conditional
hi def link kurokoRepeat		Repeat
hi def link kurokoOperator		Operator
hi def link kurokoException		Exception
hi def link kurokoInclude		Include
hi def link kurokoAsync			Statement
hi def link kurokoDecorator		Define
hi def link kurokoDecoratorName		Function
hi def link kurokoFunction		Function
hi def link kurokoComment		Comment
hi def link kurokoTodo			Todo
hi def link kurokoString		String
hi def link kurokoRawString		String
hi def link kurokoQuotes		String
hi def link kurokoTripleQuotes		kurokoQuotes
hi def link kurokoEscape		Special
if !exists("kuroko_no_number_highlight")
  hi def link kurokoNumber		Number
endif
if !exists("kuroko_no_builtin_highlight")
  hi def link kurokoBuiltin		Function
endif
if !exists("kuroko_no_exception_highlight")
  hi def link kurokoExceptions		Structure
endif
if exists("kuroko_space_error_highlight")
  hi def link kurokoSpaceError		Error
endif
if !exists("kuroko_no_doctest_highlight")
  hi def link kurokoDoctest		Special
  hi def link kurokoDoctestValue	Define
endif

let b:current_syntax = "kuroko"

let &cpo = s:cpo_save
unlet s:cpo_save

" vim:set sw=2 sts=2 ts=8 noet:
