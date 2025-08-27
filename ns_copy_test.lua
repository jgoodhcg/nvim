-- Minimal headless verifier for FindClojureNamespaceAndCopy behavior

local function FindClojureNamespaceAndCopy()
  local ns_patterns = {
    '%(ns%s+%^%b{}%s*([%w%.%-/]+)', -- map metadata
    '%(ns%s+%^%S+%s*([%w%.%-/]+)',  -- simple metadata
    '%(ns%s+([%w%.%-/]+)',          -- no metadata
  }

  local function extract_namespace(s)
    for _, p in ipairs(ns_patterns) do
      local m = s:match(p)
      if m then return m end
    end
    return nil
  end

  local current_line = vim.api.nvim_get_current_line()
  local namespace = extract_namespace(current_line)
  if namespace then
    vim.fn.setreg('+', namespace)
    print('Copied to clipboard: ' .. namespace)
    return
  end

  local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
  for _, line in ipairs(lines) do
    namespace = extract_namespace(line)
    if namespace then
      vim.fn.setreg('+', namespace)
      print('Copied to clipboard: ' .. namespace)
      return
    end
  end

  print('No Clojure namespace declaration found')
end

local function set_buffer_lines(lines, current_line_index)
  vim.api.nvim_buf_set_lines(0, 0, -1, false, {}) -- clear
  vim.api.nvim_buf_set_lines(0, 0, -1, false, lines)
  vim.api.nvim_win_set_cursor(0, { current_line_index or 1, 0 })
end

local tests = {
  { name = 'no-metadata', lines = { '(ns my.namespace)' }, cur = 1, want = 'my.namespace' },
  { name = 'simple-metadata', lines = { '(ns ^:private my.namespace)' }, cur = 1, want = 'my.namespace' },
  { name = 'map-metadata', lines = { '(ns ^{:author "John"} my.namespace)' }, cur = 1, want = 'my.namespace' },
  { name = 'subns', lines = { '(ns my.namespace/subns)' }, cur = 1, want = 'my.namespace/subns' },
  { name = 'scan-buffer', lines = { '; comment', '(ns my.scanned.ns)' }, cur = 1, want = 'my.scanned.ns' },
}

local failures = 0
for _, t in ipairs(tests) do
  set_buffer_lines(t.lines, t.cur)
  vim.fn.setreg('+', '')
  FindClojureNamespaceAndCopy()
  local got = vim.fn.getreg('+')
  local ok = got == t.want
  print(string.format('[%s] %-14s expected=%s got=%s', ok and 'OK ' or 'ERR', t.name, t.want, got))
  if not ok then failures = failures + 1 end
end

if failures > 0 then
  print(string.format('Failures: %d', failures))
  os.exit(1)
else
  print('All tests passed')
  os.exit(0)
end

