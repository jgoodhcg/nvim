-- autopairs
-- https://github.com/windwp/nvim-autopairs

vim.pack.add { 'https://github.com/windwp/nvim-autopairs' }
local npairs = require 'nvim-autopairs'
npairs.setup {}

vim.keymap.set('n', '<leader>tp', function()
  if npairs.state.disabled then
    npairs.enable()
    print 'Autopairs enabled'
  else
    npairs.disable()
    print 'Autopairs disabled'
  end
end, { desc = '[T]oggle Auto[P]airs' })
