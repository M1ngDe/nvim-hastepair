## hastepair

Simply pair movement in nvim, less feature, mainly use for enhancing builtin function.

Requires neovim above 0.7

### Install

#### [packer.nvim](https://github.com/wbthomason/packer.nvim)

```lua
use {
    'Moukubi/nvim-hastepair',
    config = require'hastepair'.setup()
}
```

### Usage

```lua
require'hastepair'.setup{
    jump_leftside_pair = '<M-,>',
    jump_rightside_pair = '<M-;>'
}
```
