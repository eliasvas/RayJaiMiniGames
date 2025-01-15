### Description
raylib + Jai minigames made for learning purposes. </br>
I should make some sort of menu to be able to select which, right now we just 'multiplex' in a switch case, </br>
each minigame is its own source file, just uncomment #load snek.jai, it has init(), update() and render() which is all thats needed </br>
Its a pretty good reference if you want to see simple Jai code. </br>


### Building
Generally, you can:
```sh
jai -quiet build.jai
.build/game.exe
```

If you want to setup a simple and effective dev enviroment you can:
```
visit https://github.com/nvim-lua/kickstart.nvim and follow the instructions for your OS to install neovim + kickstart.nvim
Add this new keymap to your init.lua, the path to which you can find by typing :echo stdpath('config') inside neovim

-- init.lua
vim.opt.expandtab = true
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.smarttab = true

...

vim.api.nvim_set_keymap('n', '<C-b>', ':w<CR>:!jai -quiet build.jai && cd .build && game && cd .. && echo "Press any key to continue..." && pause<CR>', { noremap = true, silent = true })

Now you can build while inside neovim by pressing CTRL+B and a terminal will spawn for the whole build/run for debug info
It just works.
```
