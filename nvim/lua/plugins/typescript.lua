return {
  -- Ensure TypeScript/TSX treesitter parsers are always installed
  -- (LazyVim base includes them, but this makes it explicit)
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed or {}, {
        "javascript",
        "typescript",
        "tsx",
        "jsdoc",
      })
    end,
  },
}
