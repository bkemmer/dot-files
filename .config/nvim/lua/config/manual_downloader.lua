local MD = {}
local H = {}

-- Utils from MiniDeps
H.error = function(msg) error('(manual_downloader) ' .. msg, 0) end

H.check_type = function(name, val, ref, allow_nil)
  if type(val) == ref or (ref == 'callable' and vim.is_callable(val)) or (allow_nil and val == nil) then return end
  H.error(string.format('`%s` should be %s, not %s', name, ref, type(val)))
end

H.setup_config = function(config)
  H.check_type('config', config, 'table', true)
  config = vim.tbl_deep_extend('force', vim.deepcopy(MD.config), config or {})

  H.check_type('paths', config.paths, 'table')
  H.check_type('path.download', config.path.download, 'string')
  H.check_type('github_zip_base_str_pattern', config.github_zip_base_str_pattern, 'string')
  H.check_type('wait_seconds', config.wait_seconds, 'integer')
  H.check_type('max_retries_for_zip_file', config.max_retries_for_zip_file, 'integer')
  -- H.check_type('silent', config.silent, 'boolean')

  return config
end

-- end helpers

MD.config = {
  paths = {
    download = vim.env.HOME .. "/Downloads"
  },
  github_zip_base_str_pattern = "https://codeload.github.com/%s/zip/refs/heads/%s",
  wait_seconds = 5,
  max_retries_for_zip_file = 5,
  -- silent = false,
}


MD.setup = function(config)
  MD.config = H.setup_config(config)
end

MD.get_branch_url = function(author_repo_name, branch)
  return string.format(MD.config.github_zip_base_str_pattern, author_repo_name, branch)
end

MD.test_url_exists = function(url)
  local curl_cmd = {
    'curl', '--head', '-s', url
  }
  local grep_for_str = 'HTTP.* 200'
  local r_ = vim.fn.system(curl_cmd):find(grep_for_str)
  if r_ ~= nil and r_ > 0 then
    return true
  end
end

MD.wait_for_file = function(filename)
  local full_path = vim.fs.joinpath(MD.config.paths.download, filename)
  local i = 0

  local function check_file()
    if vim.loop.fs_stat(full_path) then
      vim.notify("File found: " .. full_path)
      return
    end

    if i >= MD.config.max_retries_for_zip_file then
      vim.notify("Max retries reached. File not found: " .. full_path, vim.log.levels.ERROR)
      return
    end

    vim.notify(i .. ": File not present in: " .. full_path .. " waiting " .. MD.config.wait_seconds .. "s")
    i = i + 1

    vim.defer_fn(check_file, MD.config.wait_seconds * 1000)
  end

  check_file()
  return full_path
end

MD.unzip_file = function(zip_path, output_dir)
  local handle
  handle = vim.loop.spawn("unzip", {
    args = { zip_path, "-d", output_dir },
    stdio = {nil, nil, nil}
  }, function(code, signal)
    if code ~= 0 then
      vim.notify("Unzip finished with exit code: " .. code, vim.log.levels.ERROR)
    end
    handle:close()
  end)
end

-- tests
-- local full_path = MD.wait_for_file('obs2.png')

local full_path = MD.wait_for_file("enel.zip")
MD.unzip_file(full_path, MD.config.paths.download)
return MD

