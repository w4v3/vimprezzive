First, resize your window to the desired size, in this case                               |
up to the border:                                                                         |
                                                                                          |
                                                                                          |
                                                                                          |
                                                                                          |
                                                                                          |
                                                                                          |
                                                                                          |
                                                                                          |
                                                                                          |
                                                                                          |
                                                                                          |
                                                                                          |
                                                                                          |
                                                                                          |
                                                                                          |
                                                                                          |
                                                                                          |
                                                                                          |
——————————————————————————————————————————————————————————————————————————————————————————|

~~~
                                                                  *vimprezzive-markdown*
By using `:Compile`, this document will be turned into a presentation with
the current window dimensions.

Everything you type will be centered vertically on the slide,
with whitespace at the beginning and end removed.

(If you don't want it to be centered, use lines with spaces for balance :p).

Slides that are too long simply overflow.

Also, everything is indented four spaces, except code after ~~>~~, which
is indented by eight spaces.

A new slide is started like this:

~~~

(this is on a new slide now)

A frame title can be given by

Frame title
-----------

This will only come into effect when starting a new slide, though.

~~~

A heading on its own slide (for a higher order heading) is made like this:

Big Heading
===========

You can use the following markdown things:

* * *italics*
* * * **boldface**
* * * * ***bold italics***
* ~ ~strikethrough~
* _ _ __underline__

* `use your colorscheme's Type font with backticks`
* ~~use your colorscheme's String font with double tildes~~
* °use your colorscheme's Special font with degree characters°

The degree characters are useful to create a line like this°                     °

Also
=> and
-> have a special highlight.

~~~
Pauses
------

To uncover things piecewise use =pause.

This symbol will be removed from the text, and a new slide is created with the
text that is on the page up to =pause. The following slide will then also have
the content following the =pause.

~~~
Code
----

You can write Haskell code prefixed with ~~>~~:

> fac :: Integer -> Integer
> fac = product . enumFromTo 1

Code will be indented four more spaces than the rest, the ~~>~~ will be invisible.

Say `:help vimprezzive` for more information on how to navigate the presentation.

~~~
Specials
--------

By saying
  duration=[number]
you can specify the intended duration of your presentation in minutes.
A circle will move in the command line to reach its end after the specified
number of minutes.

With
  title="string in quotes"
you can specify a title to be displayed in the statusline.

Both directives need to be used without spaces in front of them (unlike above)
and without anything else on the line. They also **have to be at the beginning
of the file** or things ~~will~~ break.

vim:ft=vimprezmd
