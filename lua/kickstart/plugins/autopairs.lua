-- autopairs
-- https://github.com/windwp/nvim-autopairs

return {
  'windwp/nvim-autopairs',
  event = 'InsertEnter',
  config = function()
    local npairs = require 'nvim-autopairs'
    npairs.setup {}
    
    -- Add toggle keybinding
    vim.keymap.set('n', '<leader>tp', function()
      if npairs.state.disabled then
        npairs.enable()
        print('Autopairs enabled')
      else
        npairs.disable()
        print('Autopairs disabled')
      end
    end, { desc = '[T]oggle Auto[P]airs' })
  end,
}
