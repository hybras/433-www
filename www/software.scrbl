#lang scribble/manual
@(require scribble/core racket/list)
@(require (for-label racket))
@(require redex/reduction-semantics
          redex/pict (only-in pict scale))

@(require scribble/examples racket/sandbox)

@(require "defns.rkt")

@(define core-racket
  (parameterize ([sandbox-output 'string]
                 [sandbox-error-output 'string]
                 [sandbox-memory-limit 50])
    (make-evaluator 'racket/base)))

@(core-racket '(require racket/match))

@(define-syntax-rule (ex e ...) (examples #:eval core-racket #:label #f e ...))



@(define-syntax-rule (render-grammar L)
   (scale (render-language L) 1))

@(define-syntax-rule (render-grammar/nts L nts)
   (scale (render-language L #:nts nts) 1))



@title[#:style 'unnumbered]{Software}

This course will make use of the following software:

@itemlist[

 @item{Operating system: Linux and MacOS will work right out of the box. Windows users will require WSL2.}

 @item{GHC and Cabal: the Haskell implementation and a package manager for Haskell code. }

]

Instruction for using each system are below:

@itemlist[
@item{@secref{Linux}}
@item{@secref{mac}}
@item{@secref{Windows}}
]


@section[#:tag "Linux"]{Using Linux}

If you have an ARM-based machine, you will need to use
@seclink["GRACE"]{GRACE} or potentially setup an x86 VM.

For x86-based Linux machines, you will need to
@seclink["install-racket"]{install Racket} and the
@seclink["langs-package"]{langs package}.  Finally, install @tt{nasm}.
You can use your favorite package manager; they should all have
@tt{nasm}.


@section[#:tag "mac"]{Using macOS}

If you are using a macOS computer, the setup will be different
depending on whether you have an Intel-based CPU or an Apple Silicon
CPU.  If you're unsure which you have, click the Apple icon in the
top-left and select "About This Mac".  Under CPU, you will see
a chip name containing either Intel or Apple.

@subsection[#:tag "intel-mac"]{Using macOS on Intel}

Intel-based Macs are fairly straightforward to set up.  You will need
to @seclink["install-racket"]{install Racket} and the
@seclink["langs-package"]{langs package}.  You will also need to
install @tt{nasm}.  It's probably easiest to use a package manager
such as @link["https://brew.sh/"]{Homebrew} to install with @tt{brew
install nasm}.

You will also want to make sure your Racket installation is visible
from your @tt{PATH} environment variable.  Assuming Racket was
installed in the usual location, you can run:

@verbatim|{   PATH=$PATH:"/Applications/Racket v8.6/bin"}|

You can add this line to the @tt{.zprofile} file in your home
directory so that it is available every time you start the Terminal.

@subsection[#:tag "apple-silicon-mac"]{Using macOS on Apple Silicon}

It's also possible to run everything we need on an Apple Silicon Mac
even though it doesn't use an x86 CPU and instead uses an ARM
processor. That's because Apple provides a compability layer called Rosetta
that will allow you run x86 programs on your ARM CPU.

The set up is basically the same as when @secref{intel-mac}, except
that when you install Racket you need to select the installer for
@bold{Mac OS (Intel 64-bit)} when
@link["https://download.racket-lang.org/"]{downloading Racket}.  Do
not use Apple Silicon 64-bit installer.  This will work thanks to
Rosetta.

Otherwise, follow the steps given above.

@section[#:tag "Windows"]{Using Windows}

For Windows users, using WSL for testing is highly recommended. Beyond 
the first few assignments, the projects will require generating and 
executing assembly code using the nasm package. Students in the past 
have had trouble trying to configure this in the Windows environment, 
so an easier workaround is simply to enable WSL and run your tests through 
some Linux Distribution. Here is a breakdown of the steps:

@itemlist[
 #:style 'ordered
 @item{Following the instructions at
  @link["https://docs.microsoft.com/en-us/windows/wsl/install-win10"]{
   this link}, install a Linux Distro of your choice (e.g.,
  Ubuntu). The instructions include a suggestion to upgrade to
  WSL2; this is not necessary but will improve efficiency in
  general.}

 @item{Open your installed Linux distribution of choice and
  make any initial configurations necessary (user, pass,
  etc.). Run @tt{sudo apt update} and follow with @tt{sudo apt
   upgrade}. These two may take some time. }

 @item{Run @tt{sudo apt install racket} and @tt{
   sudo apt install nasm}. These two should cover the necessary
  installations for this course.}

 @item{Here is where to determine which IDE you would like to
  use.

@itemlist[
  @item{Using vim (or Emacs as mentioned in the previous section) is simple. Copy assignment files into WSL. Modify files.}
  @item{Previous students preferred installing VSCode (outside of WSL) from @link["https://code.visualstudio.com/download"]{this link}. 
  For each assignment, copy assignment files somewhere on your Linux distro. For some .rkt file, call 'code some-rkt-file.rkt' and 
  after some automatic set up, VSCode should load up the file. Install Racket extensions from the VSCode 
  Marketplace (a suggestion will also pop up once you open a .rkt file) to have colorized syntax, bracket matching, 
  inteliSense, etc. }
  @item{If you are intent on using DrRacket, you would also need to install Racket on your local machine 
  (outside WSL). For each assignment, copy assignment files into your normal file system and use DrRacket to edit files 
  accordingly. To access from your Linux subsystem, create a soft symbolic link in your Linux distro to the
  project directory (or the parent directory so you do not need to make links with each new project).}
]}

]

Regardless of the IDE used, you can now run your tests from your Linux 
subsystem by entering the project directory and using the raco command.

@section[#:tag "install-racket"]{Installing Racket}

Racket is available for all major operating systems from:

@centered{@link["https://racket-lang.org/"]{@tt{https://racket-lang.org/}}}

We will be using Racket @racket-version, but any version from the past several
years should work fine.

There are two essential references:

@itemlist[
@item{@link["https://docs.racket-lang.org/guide/"]{The Racket Guide} - intended for those new to Racket, i.e. @emph{you!}}
@item{@link["https://docs.racket-lang.org/reference/"]{The Racket Reference} - the definitive, comprehensive manual for Racket}
]

Racket is a large, full-featured, batteries-included language
platform.  However, we will be using only a small subset of Racket.
This subset should be easy to pick up for anyone familiar with
functional programming.  If you're comfortable with basic OCaml,
Haskell, or even JavaScript, you shouldn't have much trouble learning
the Racket bits we will be using.

@section[#:tag "langs-package"]{The @tt{langs} package}

After installing Racket, install the @tt{langs} package
which includes course utilities such as the @secref{a86}
library.

To install, run the following command:

@verbatim|{raco pkg install 'https://github.com/cmsc430/www.git?path=langs#main'}|

To test the package works as expected, run:

@verbatim|{raco test -p langs}|

All of the tests should pass; if they don't, consult course staff.

The package source is hosted on Github. To check for and
install updates, run:

@verbatim|{raco pkg update langs}|

@section{IDE}

Racket comes with it's own IDE: DrRacket, which is the recommended way
to edit Racket files.  We will also be running Racket and its
associated tools from the command line.

If you'd like to use Emacs, there's a good
@link["https://www.racket-mode.com/"]{Racket mode}, but we recommend
using DrRacket for a while before switching to Emacs.  Using any other
editor is fine, too.

@;{
@section{Detailed compatiblity list}

The course software has been successfully tested with the
following:

@itemlist[
 @item{Operating systems:
  @itemlist[@item{Ubuntu 20.04}
            @item{Ubuntu 18.04}
            @item{Red Hat Enterprise Linux 7.7}
            @item{macOS 11.0 (Big Sur)}
            @item{macOS 10.15 (Catalina)}]}
  
 @item{Racket:
  @itemlist[@item{Racket 8.1 [cs]}
            @item{Racket 8.1 [bc]}
	    @item{Racket 8.0 [cs]}
            @item{Racket 8.0 [bc]}
	    @item{Racket 7.9 [cs]}
            @item{Racket 7.9 [bc]}
            @item{Racket 7.8 [cs]}
            @item{Racket 7.8 [bc]}]}

 @item{NASM:
  @itemlist[@item{NASM version 2.13.02}
            @item{NASM version 2.15.05}]}

 @item{GCC:
  @itemlist[@item{gcc 9.3.0}
            @item{gcc 7.5.0}
            @item{Clang/LLVM 12.0.0}]}]

@; DVH: I'm not sure this is useful.  The OCaml to Racket notes are better.
@;{

@section{Grammar}

A program is a sequence of definitions or expressions.

@(define unquote "whatever") @;{Needed to make redex happy with unquote in grammar}
@(define-language R0
  (d ::= (define x e) (define (x x ...) e))
  (e ::= (e e ...) (δ e ...) sv x (λ (x ...) e) (quasiquote qq) (match e [p e] ...))
  (qq ::= (qq ...) sv x (unquote e))
  (sv ::= b n s)
  (p ::= (quasiquote r) b n x s (cons p p))
  (r ::= b n x s (unquote p))
  (s ::= string)
  (b ::= #t #f)
  (n ::= integer)
  (x ::= variable)
  (δ ::= add1 sub1 = * + - list cons))

The grammar for the subset of Racket we will use is:

@(with-unquote-rewriter
  (lambda (lw) 
    (build-lw (list (build-lw "(" (lw-line lw) (lw-line-span lw) (lw-column lw) 1)
                    (build-lw 'unquote (lw-line lw) (lw-line-span lw) (+ 1 (lw-column lw)) 7)
                    (build-lw " " (lw-line lw) (lw-line-span lw) (+ 2 (lw-column lw)) 1)
                    (build-lw (lw-e lw) (lw-line lw) (lw-line-span lw) (+ 3 (lw-column lw)) (lw-column-span lw))
                    (build-lw ")" (lw-line lw) (lw-line-span lw) (lw-column lw) 1))
               (lw-line lw)
               (lw-line-span lw)
               (lw-column lw)
               (+ 8 (lw-column-span lw))))

	       
  (render-grammar R0))

@section{Built-In Datatypes}

We will use:

@itemize[
@item{Booleans}
@item{Numbers}
@item{Strings}
@item{Symbols}
@item{Pairs and Lists}
]

We will make extensive use of @link["https://docs.racket-lang.org/guide/quote.html"]{@tt{quote}}.

@section{Definitions}

A definition takes the form:

@render-grammar/nts[R0 '(d)]

A definition @render-term[R0 (define x e)] defines @render-term[R0 x]
to stand for the value produced by evaluating @render-term[R0 e].

The @render-term[R0 (define (x_0 x_1 ...) e)] form is shorthand for
@render-term[R0 (define x_0 (λ (x_1 ...) e))].

@;{
@section{Style}

TODO: write style guidelines.
}

@section{Examples}

Here are some examples of writing various functions in our subset of Racket.

@#reader scribble/comment-reader
(ex

;; compute the product of a list of numbers
(define (prod xs)
  (match xs
    ['() 1]
    [(cons x xs) (* x (prod xs))]))

(prod '(1 2 3 4 5))

;; reverse a list
(define (rev xs)
  (rev/acc xs '()))

(define (rev/acc xs a)
  (match xs
    ['() a]
    [(cons x xs) (rev/acc xs (cons x a))]))

(rev '(1 2 3 4 5))
)

}

}
