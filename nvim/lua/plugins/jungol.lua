return {
  {
    'jungol-local',
    dir = vim.fn.stdpath 'config',
    lazy = false,
    config = function()
      local function setup_jungol_problem(problem_number)
        local num = tonumber(problem_number)

        if not num then
          vim.notify('Problem number must be a number.', vim.log.levels.ERROR)
          return
        end

        local prefix = math.floor(num / 1000)
        local folder_name = string.format('%02dxxx', prefix)
        local file_name = string.format('%05d.cpp', num)

        local base_dir = vim.fn.expand '~/Code/Jungol'
        local full_dir = base_dir .. '/' .. folder_name
        local full_path = full_dir .. '/' .. file_name

        if vim.fn.isdirectory(full_dir) == 0 then
          vim.fn.mkdir(full_dir, 'p')
        end

        vim.cmd.edit(vim.fn.fnameescape(full_path))

        local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)

        if #lines <= 1 and lines[1] == '' then
          local template = {
            '#include <iostream>',
            'using namespace std;',
            '',
            'void solve(void) {',
            '  ',
            '}',
            '',
            'int main(void) {',
            '  ios::sync_with_stdio(false);',
            '  cin.tie(nullptr);',
            '',
            '  solve();',
            '  return 0;',
            '}',
          }

          vim.api.nvim_buf_set_lines(0, 0, -1, false, template)
          vim.api.nvim_win_set_cursor(0, { 5, 2 })
          vim.cmd 'startinsert!'
        end
      end

      vim.api.nvim_create_user_command('Jungol', function(opts)
        local action = opts.fargs[1]
        local problem_id = opts.fargs[2]

        if action == 'add' and problem_id then
          setup_jungol_problem(problem_id)
        else
          vim.notify('Usage: :Jungol add <problem_number>', vim.log.levels.INFO)
        end
      end, {
        nargs = '*',
      })
    end,
  },
}
