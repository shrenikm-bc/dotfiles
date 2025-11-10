function map(mode, shortcut, command, noremap, unique)
  vim.api.nvim_set_keymap(mode, shortcut, command,
    { noremap = noremap, unique = unique, silent = true }
  )
end

function unmap(mode, shortcut)
  vim.api.nvim_del_keymap(mode, shortcut)
end

function buf_map(bufnr, mode, shortcut, command, noremap, unique)
  vim.api.nvim_buf_set_keymap(bufnr, mode, shortcut, command,
    { noremap = noremap, unique=unique, silent = true }
  )
end

function buf_unmap(bufnr, mode, shortcut)
  vim.api.nvim_buf_del_keymap(bufnr, mode, shortcut)
end


-- Unique nmap
function nmap_u(shortcut, command)
  map('n', shortcut, command, false, true)
end

-- Non unique nmap
function nmap_nu(shortcut, command)
  map('n', shortcut, command, false, false)
end

-- Unique nnoremap
function nnoremap_u(shortcut, command)
  map('n', shortcut, command, true, true)
end

-- Non unique nnoremap
function nnoremap_nu(shortcut, command)
  map('n', shortcut, command, true, false)
end

-- Unique nnoremap
function buf_nnoremap_u(bufnr, shortcut, command)
  buf_map(bufnr, 'n', shortcut, command, true, true)
end

-- Non unique nnoremap
function buf_nnoremap_nu(bufnr, shortcut, command)
  buf_map(bufnr, 'n', shortcut, command, true, false)
end

