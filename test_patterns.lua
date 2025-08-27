-- Test the current and proposed regex patterns for clojure namespace extraction

-- Current problematic pattern (same as in init.lua)
local current_pattern = '%(ns%s+%^?[^%s]*%s*([%w%.%-/]+)'

-- Original working pattern
local original_pattern = '%(ns%s+([%w%.%-/]+)'

-- Ordered improved patterns to support:
-- 1) map metadata: (ns ^{:k v} my.ns)
-- 2) simple metadata token: (ns ^:private my.ns)
-- 3) no metadata: (ns my.ns)
local improved_patterns = {
  '%(ns%s+%^%b{}%s*([%w%.%-/]+)', -- map metadata
  '%(ns%s+%^%S+%s*([%w%.%-/]+)',  -- simple metadata token
  '%(ns%s+([%w%.%-/]+)',          -- no metadata
}

local function extract_with_patterns(s, patterns)
  for _, p in ipairs(patterns) do
    local m = s:match(p)
    if m then
      return m, p
    end
  end
  return nil, nil
end

-- Test cases and expected namespaces
local cases = {
  { '(ns my.namespace)', 'my.namespace' },
  { '(ns my-app.core)', 'my-app.core' },
  { '(ns com.example.utils)', 'com.example.utils' },
  { '(ns ^{:author "John"} my.namespace)', 'my.namespace' },
  { '(ns ^:private my.namespace)', 'my.namespace' },
  { '(ns ^{:doc "Main namespace"} my.app.core)', 'my.app.core' },
  { '(ns my.namespace.with-dashes)', 'my.namespace.with-dashes' },
  { '(ns my.namespace/subns)', 'my.namespace/subns' },
  { '(ns ^{:meta {:nested true}} complex.namespace)', 'complex.namespace' },
}

local function run(name, fn)
  print('\n=== ' .. name .. ' ===')
  local failures = 0
  for _, case in ipairs(cases) do
    local input, expected = case[1], case[2]
    local ok, got, detail = fn(input)
    local status = ok and 'OK ' or 'ERR'
    print(string.format('[%s] %s -> expected=%s got=%s%s', status, input, expected, tostring(got), detail and (' via ' .. detail) or ''))
    if not ok then failures = failures + 1 end
  end
  return failures
end

-- 1) Current pattern
local failures_current = run('Current Pattern', function(s)
  local got = s:match(current_pattern)
  local expected
  for _, case in ipairs(cases) do if case[1] == s then expected = case[2]; break end end
  return got == expected, got
end)

-- 2) Original pattern
local failures_original = run('Original Pattern', function(s)
  local got = s:match(original_pattern)
  local expected
  for _, case in ipairs(cases) do if case[1] == s then expected = case[2]; break end end
  return got == expected, got
end)

-- 3) Improved ordered patterns
local failures_improved = run('Improved Patterns', function(s)
  local got, pat = extract_with_patterns(s, improved_patterns)
  local expected
  for _, case in ipairs(cases) do if case[1] == s then expected = case[2]; break end end
  return got == expected, got, pat
end)

print(string.format('\nSummary: current=%d failures, original=%d failures, improved=%d failures', failures_current, failures_original, failures_improved))

if failures_improved > 0 then
  print('Improved patterns did not pass all tests')
  os.exit(1)
else
  os.exit(0)
end
