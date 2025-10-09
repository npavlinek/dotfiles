function use_space_indent(indent)
    vim.opt_local.expandtab = true
    vim.opt_local.shiftwidth = indent
    vim.opt_local.softtabstop = indent
end

function use_tab_indent(indent)
    vim.opt_local.expandtab = false
    vim.opt_local.shiftwidth = indent
    vim.opt_local.softtabstop = 0
    vim.opt_local.tabstop = indent
end
