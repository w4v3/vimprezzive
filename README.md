# Vimprezzive

A very simple presentation plugin for Vim (tested only with neovim).
Supports bird-style literate Haskell.

## Installation

`git clone` this repository into your plugin directory. Run `:helptags ALL`.

## Usage

To create the presentation, edit a new file with a `.vimprezmd.lhs` extension.
(I haven't found a way to convince `haskell-language-server` that a file not
ending in `.lhs` might be literate Haskell; if you have an idea, please open an
issue).

See [this example](doc/example.vimprezmd.lhs) for an explanation of the
available features. Using `:Compile` will then create a `.vimprez.lhs` file
using the current window dimensions and open it. This is the presentation. You
can navigate it using the arrow keys, quit presentation mode with `q`, and
resume with `:Resume`.

Bird-style Haskell code can be used and `haskell-language-server` will be
active in both `vimprezmd` and `vimprez` files.

See [the help file](doc/vimprezzive.txt) for more information.

## License

Public domain.
