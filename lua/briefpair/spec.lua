local ut = require "utils"

local row, col  = unpack(vim.api.nvim_win_get_cursor(0))
print(row, col)
local line = ut.get_current_buf_lines(row -1)[1]

print(line)
