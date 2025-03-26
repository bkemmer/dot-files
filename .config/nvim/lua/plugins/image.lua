-- display images
-- image nvim options table. Pass to `require('image').setup`
require("image").setup(
{
  backend = "kitty", -- Kitty will provide the best experience, but you need a compatible terminal
  integrations = {
    markdown = {
      enabled = true,
      clear_in_insert_mode = false,
      download_remote_images = true,
      only_render_image_at_cursor = false,
      floating_windows = false, -- if true, images will be rendered in floating markdown windows
      filetypes = { "markdown", "vimwiki" }, -- markdown extensions (ie. quarto) can go here
    },
    html = {
      enabled = false,
    },
    css = {
      enabled = false,
    },
  }, -- do whatever you want with image.nvim's integrations
  max_width = 100, -- tweak to preference
  max_height = 12, -- ^
  max_height_window_percentage = math.huge, -- this is necessary for a good experience
  max_width_window_percentage = math.huge,
  window_overlap_clear_enabled = true,
  -- window_overlap_clear_ft_ignore = { "cmp_menu", "cmp_docs", "" },
  window_overlap_clear_ft_ignore = { "cmp_menu", "cmp_docs", "snacks_notif", "scrollview", "scrollview_sign" },
  hijack_file_patterns = { "*.png", "*.jpg", "*.jpeg", "*.gif", "*.webp", "*.avif" }, -- render image files as images when opened
})

