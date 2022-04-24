local api = vim.api
local M = {}

function M.get_indent()
    return vim.bo.expandtab and string.rep(" ", vim.bo.shiftwidth) or "\t"
end

return M
