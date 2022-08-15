# hastepair

Simply pair completion in nvim, less feature, mainly use for enhancing builtin function.

Requires neovim 0.61

## Install

### [packer.nvim](https://github.com/wbthomason/packer.nvim)

```lua
use {
    'Moukubi/hastepair',
    config = require 'hastepair'.setup()
}
```

## Usage

```lua
require'hastepair'.setup{
    jump_leftside_pair = '<M-,>',
    jump_rightside_pair = '<M-;>'
}
```
