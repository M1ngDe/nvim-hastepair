local api = vim.api
local keymap = api.nvim_set_keymap
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

local function get_current_buf_lines(start_row, end_row)
    return api.nvim_buf_get_lines(0, start_row, end_row or start_row + 1, false)
end

local function set_current_buf_texts(texts, start_row, start_col, end_row, end_col)
	api.nvim_buf_set_text(0, start_row, start_col, end_row or start_row, end_col or start_col, texts or {})
end


function M.insert_pair(str)
    local row, col = unpack(api.nvim_win_get_cursor(0))
    local line = api.nvim_get_current_line()
    set_current_buf_texts(line:sub(col, col) == "\\" and {str} or {str .. pair[str]}, row -1, col)
    api.nvim_win_set_cursor(0, {row, col + 1})
end

local function index_left_pair(row, col)
    local line = get_current_buf_lines(row - 1)[1]:reverse()
    local length = #line
    local idx = length + 1
    for l in pairs(pair) do
        local newidx = string.find(line, "%" .. l, col == 0 and 1 or length - col + 1 + 1)
        if newidx and newidx < idx then idx = newidx end
    end
    if idx ~= length + 1 then return {row, length - idx + 1} end
    if row > 1 then return index_left_pair(row - 1, 0) end
end

local function index_right_pair(row, col)
    local line = get_current_buf_lines(row - 1)[1]
    local idx = #line + 1
    for _, r in pairs(pair) do
        local newidx = string.find(line, "%" .. r, col+1)
        if newidx and  idx > newidx then
            idx = newidx
        end
    end
    if idx ~= #line + 1 then return {row, idx} end
    if row < vim.api.nvim_buf_line_count(0) then
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

for key in pairs(pair) do
    keymap("i", key, string.format([[<cmd>lua require"briefpair".insert_pair("%s")<cr>]], key:gsub('"', '\\"')), opts)
end

function M.setup(key)
    M.keymapping.jump_leftside_pair = key.jump_leftside_pair
    M.keymapping.jump_rightside_pair = key.jump_rightside_pair
end

keymap("i", M.keymapping.jump_leftside_pair, [[<cmd>lua require"briefpair".jump_pair()<cr>]], opts)
keymap("i", M.keymapping.jump_rightside_pair, [[<cmd>lua require"briefpair".jump_pair(1)<cr>]], opts)

return M
