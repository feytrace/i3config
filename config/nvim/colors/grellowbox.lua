-- grellowbox.lua
-- vim.cmd("colorscheme grellowbox")

local M = {}

M.colors = {
    bg        = "#1d2021",
    bg_soft   = "#282828",
    bg_alt    = "#32302f",

    fg        = "#ebdbb2",
    fg_soft   = "#d5c4a1",
    fg_dim    = "#bdae93",

    green     = "#b8bb26", -- primary green
    green_br  = "#c5e478",

    yellow    = "#fabd2f", -- primary yellow
    yellow_br = "#ffd75f",

    orange    = "#d79921", -- softened
    red       = "#cc6f6f",

    blue      = "#83a598",
    purple    = "#d3869b",

    gray      = "#928374",
}

function M.apply()
    local c = M.colors
    local set = vim.api.nvim_set_hl

    -- UI
    set(0, "Normal",         { fg = c.fg,      bg = c.bg })
    set(0, "NormalFloat",    { fg = c.fg,      bg = c.bg_soft })
    set(0, "CursorLine",     { bg = "#32361a" }) -- olive tint
    set(0, "CursorLineNr",   { fg = c.yellow_br, bold = true })
    set(0, "LineNr",         { fg = "#7c6f3c" })

    set(0, "StatusLine",     { fg = c.fg, bg = "#4b5632" })
    set(0, "StatusLineNC",   { fg = c.gray, bg = "#3a4127" })

    -- Selection & search
    set(0, "Visual",         { bg = "#3c4423" }) -- muted green
    set(0, "Search",         { fg = c.bg, bg = c.yellow, bold = true })
    set(0, "IncSearch",      { fg = c.bg, bg = c.yellow_br, bold = true })

    -- Syntax
    set(0, "Comment",        { fg = "#7f8350", italic = true }) -- olive comments
    set(0, "String",         { fg = "#a3be47" })
    set(0, "Function",       { fg = c.yellow_br, bold = true }) -- yellow functions
    set(0, "Keyword",        { fg = c.green, bold = true })     -- green keywords
    set(0, "Type",           { fg = c.green })
    set(0, "Constant",       { fg = c.yellow })
    set(0, "Identifier",     { fg = c.fg })
    set(0, "Special",        { fg = c.green })

    -- Diagnostics
    set(0, "DiagnosticError", { fg = c.red })
    set(0, "DiagnosticWarn",  { fg = c.yellow_br })
    set(0, "DiagnosticInfo",  { fg = c.blue })
    set(0, "DiagnosticHint",  { fg = c.green })

    -- Git
    set(0, "DiffAdd",         { bg = "#2f3b1b" })
    set(0, "DiffChange",      { bg = "#3a3f14" })
    set(0, "DiffDelete",      { bg = "#3c1f1f" })

    -- Popup menus
    set(0, "Pmenu",          { bg = c.bg_soft, fg = c.fg })
    set(0, "PmenuSel",       { bg = "#3c4423" })
    set(0, "PmenuThumb",     { bg = c.bg_alt })

    vim.g.colors_name = "grellowbox"
end

M.apply()

return M
