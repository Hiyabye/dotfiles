local opt = vim.opt

opt.mouse = "a"
opt.clipboard = "unnamedplus"
opt.wrap = false
opt.cursorline = true
opt.scrolloff = 8
opt.undofile = true

-- Let arrow keys cross line boundaries in Normal and Insert modes.
opt.whichwrap:append("<,>,[,]")
