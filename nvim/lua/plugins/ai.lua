return {
  "zbirenbaum/copilot.lua",
  cmd = "Copilot",
  event = "InsertEnter",
  config = function()
    require("copilot").setup({
      suggestion = {
        enabled = true,
        auto_trigger = true,
        hide_during_completion = true,
        keymap = {
          -- Tab is handled by blink.cmp's handler in coding.lua: it accepts
          -- this inline suggestion when visible, else the completion menu,
          -- else inserts a tab. Previously bound only to <M-l>, which is why
          -- pressing Tab appeared "stuck".
          accept = false,
        },
      },
      panel = { enabled = false },
    })
  end,
}
