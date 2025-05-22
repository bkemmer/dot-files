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

---@param author_repo_name string The repository name in the pattern: bkemmer/dot-files
---@param branch string The branch name
---@return string success Return the url with the author/repository_name/branch
MD.get_branch_url = function(author_repo_name, branch)
  return string.format(MD.config.github_zip_base_str_pattern, author_repo_name, branch)
end

---@param url string The URL
---@return boolean|nil
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

---@return string|nil ,string|nil
MD.get_valid_url = function(author_repo_name, custom_branch)

  local function test_url(author_repo_name, branch)
    local url = MD.get_branch_url(author_repo_name, branch)
    local exists = MD.test_url_exists(url)
    if exists then return url, branch
      else return nil, nil end
  end

  if custom_branch ~= nil then
    return test_url(author_repo_name, custom_branch)
  else
    local branchs = {'main', 'master'}
    for i=1, #branchs do
      local url, branch = test_url(author_repo_name, branchs[i])
      if url ~= nil then return url, branch end
    end
  end
end

MD.download_using_external_program = function(url)
  local download_program = 'xdg-open'
  if vim.fn.has('macunix') == 1 then download_program = 'open' end
  vim.fn.system({
    download_program, url
  })
end

---@param filename string Filename to wait under download folder
---@return boolean, string R true|false and file_path
MD.wait_for_file = function(filename)
  local full_path = vim.fs.joinpath(MD.config.paths.download, filename)
  local i = 0
  local found = false
  local function check_file()
    if vim.loop.fs_stat(full_path) then
      vim.notify("File found: " .. full_path)
      return true
    end

    if i >= MD.config.max_retries_for_zip_file then
      vim.notify("Max retries reached. File not found: " .. full_path, vim.log.levels.ERROR)
      return false
    end

    vim.notify(i .. ": File not present in: " .. full_path .. " waiting " .. MD.config.wait_seconds .. "s")
    i = i + 1

    vim.defer_fn(check_file, MD.config.wait_seconds * 1000)
  end
  found = check_file()
  return found, full_path
end

---@param zip_path string Full path to zip file
---@param output_dir string Output folder to extract the zip file
---@return nil
MD.unzip_file = function(full_zip_path, output_dir)
  local handle
  handle = vim.loop.spawn("unzip", {
    args = { full_zip_path, "-d", output_dir },
    stdio = {nil, nil, nil}
  }, function(code, signal)
    if code ~= 0 then
      vim.notify("Unzip finished with exit code: " .. code, vim.log.levels.ERROR)
    end
    handle:close()
  end)
end

MD.get_repo_name = function(author_repo_name)
  local parts = vim.split(author_repo_name, "/", { plain = true })
  return parts[#parts]
end

MD.get_zip_file_name = function(repo_name, branch)
  return string.format('%s-%s.zip', repo_name, branch)
end


---@param author_repo_name string The repository name in the pattern: bkemmer/dot-files
---@param custom_branch string|nil Specific branch to be used
MD.downloader = function(author_repo_name, output_dir, custom_branch)
  H.check_type('ops', custom_branch, 'string', true)

  -- check if this branch hierarchy exists
  local repo_name = MD.get_repo_name(author_repo_name)
  local url, branch  = MD.get_valid_url(author_repo_name, custom_branch)
  if url ~= nil then
    -- MD.download_using_external_program(url)
    print(url, branch)
    local zip_file_name = MD.get_zip_file_name(repo_name, branch)
    MD.download_using_external_program(url)
    local found, full_file_path = MD.wait_for_file(zip_file_name)
    print("found:")
    vim.wait(10)
    print(found)
    if found then
      vim.notify("Unzipping file: " .. full_file_path .. " to " .. output_dir)
      MD.unzip_file(full_file_path, '.')

    else
        print("not")
    end
  end
end

-- tests

MD.downloader("bkemmer/dot-files")
-- MD.downloader("Olivine-Labs/lua-style-guide")
-- local full_path = MD.wait_for_file('obs2.png')

-- local full_path = MD.wait_for_file("enel.zip")
-- MD.unzip_file(full_path, MD.config.paths.download)
return MD

