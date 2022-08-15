local api = vim.api
local M = {}

M.keymapping = {
    jump_leftside_pair = "<M-,>",
    jump_rightside_pair = "<M-;>"
}

local pair = {
    ["("] = ")",
    ["{"] = "}",
    ["["] = "]",
    ["'"] = "'",
    ['"'] = '"',
    ["`"] = "`"
}

local rex = "[%(%{%[%]%}%)%`%'%\"]"

local function get_current_buf_lines(start_row, end_row)
    return api.nvim_buf_get_lines(0, start_row, end_row or start_row + 1, false)
end

local function index_left_pair(row, col)
    if col == 0 then return index_left_pair(row - 1, -1) end
    local line = get_current_buf_lines(row - 1)[1]:reverse()
    local length = #line
    local idx = string.find(line, rex, col == -1 and 1 or length - col + 1 + 1)
    -- if idx ~= length + 1 then return {row, length - idx + 1} end
    if idx then return {row, length - idx + 1} end
    if row > 1 then return index_left_pair(row - 1, -1) end
end

local function index_right_pair(row, col)
    local line = get_current_buf_lines(row - 1)[1]
    local idx = string.find(line, rex, col + 1)
    if idx then return {row, idx} end
    if row < api.nvim_buf_line_count(0) then
        return index_right_pair(row + 1, 0)
    end
end

function M.jump_pair(dir)
    local row, col = unpack(api.nvim_win_get_cursor(0))
    local pos
    if dir then
        pos = index_right_pair(row, col)
    else
        pos = index_left_pair(row, col)
    end
    if pos then api.nvim_win_set_cursor(0, pos) end
end

local opts = {noremap = true, silent = true}

function M.setup(key)
    M.keymapping.jump_leftside_pair = key.jump_leftside_pair
    M.keymapping.jump_rightside_pair = key.jump_rightside_pair
end

vim.keymap.set("i", M.keymapping.jump_leftside_pair, [[<cmd>lua require"briefpair".jump_pair()<cr>]], opts)
vim.keymap.set("i", M.keymapping.jump_rightside_pair, [[<cmd>lua require"briefpair".jump_pair(1)<cr>]], opts)

return M
