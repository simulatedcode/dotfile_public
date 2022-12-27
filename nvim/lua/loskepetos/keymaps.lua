local keymap = vim.keymap
local opts = { noremap = true, silent = true }

keymap.set("n", "x", '"_x')

-- Alpha
keymap.set("n", "<F2>", ":Alpha<CR>", opts)

-- Increment/decrement
keymap.set("n", "+", "<C-a>")
keymap.set("n", "-", "<C-x>")

-- Delete a word backwards
keymap.set("n", "dw", 'vb"_d')

-- Select all
keymap.set("n", "<C-a>", "gg<S-v>G")

-- Save with text message
keymap.set("n", ".s", ":w<cr>:echo 'Saved!'<cr>", opts)

-- New tab
keymap.set("n", "te", ":tabedit")

-- Split window
keymap.set("n", "ss", ":split<Return><C-w>w")
keymap.set("n", "sv", ":vsplit<Return><C-w>w")

-- Navigate buffers
keymap.set("n", "<S-h>", ":bnext<CR>", opts)
keymap.set("n", "<S-l>", ":bprevious<CR>", opts)

-- clear search
keymap.set("n", ".h", ":nohl<cr>", opts)

-- Reload nvim
keymap.set("n", "xr", ":source %<CR>:echo 'Reloaded!'<CR>", opts)

-- Move window
keymap.set("n", "<Space>", "<C-w>w")
keymap.set("", "sh", "<C-w>h")
keymap.set("", "sk", "<C-w>k")
keymap.set("", "sj", "<C-w>j")
keymap.set("", "sl", "<C-w>l")

-- close split window
keymap.set("n", "xq", ":q<CR>", opts)

-- Resize window
keymap.set("n", "<C-w><left>", "<C-w><")
keymap.set("n", "<C-w><right>", "<C-w>>")
keymap.set("n", "<C-w><up>", "<C-w>+")
keymap.set("n", "<C-w><down>", "<C-w>-")

-- Visual --
-- Stay in indent mode
keymap.set("v", "<", "<gv", opts)
keymap.set("v", ">", ">gv", opts)

-- Move text up and down
keymap.set("v", "<C-z>", ":m .+0<CR>==", opts)
keymap.set("v", "<C-x", ":m .-3<CR>==", opts)
keymap.set("v", "p", '"_dP', opts)

keymap.set("x", "<C-z>", ":move '>+1<CR>gv-gv", opts)
keymap.set("x", "<C-x>", ":move '<-2<CR>gv-gv", opts)

-- Glance
keymap.set("n", "Gr", "<CMD>Glance references<CR>")
keymap.set("n", "Gd", "<CMD>Glance type_definitions<CR>")

--Chatgpt
keymap.set("n", "<space>gg", "<CMD>ChatGPT<CR>", opts)
keymap.set("n", "<space>ga", "<CMD>ChatGPTActAs<CR>", opts)
keymap.set("n", "<space>ge", "<CMD>ChatGPTEditWithInstructions<CR>", opts)
