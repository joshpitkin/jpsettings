return {
  -- Magit-style git UI for status, staging, committing
  {
    "NeogitOrg/neogit",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "sindrets/diffview.nvim", -- richer diff integration
    },
    cmd = "Neogit",
    keys = {
      { "<leader>gg", "<cmd>Neogit<cr>", desc = "Neogit" },
      { "<leader>gc", "<cmd>Neogit commit<cr>", desc = "Git Commit" },
    },
    opts = {
      integrations = {
        diffview = true, -- use Diffview for diffs inside Neogit
      },
    },
  },

  -- Best-in-class diff viewer; also handles commit/file history
  {
    "sindrets/diffview.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    cmd = { "DiffviewOpen", "DiffviewFileHistory", "DiffviewClose" },
    keys = {
      -- Browse full history of current branch with diffs
      { "<leader>gh", "<cmd>DiffviewFileHistory<cr>", desc = "Git Branch History" },
      -- History for just the current file
      { "<leader>gH", "<cmd>DiffviewFileHistory %<cr>", desc = "Git File History" },
      -- Open diff against HEAD (staged/unstaged changes)
      { "<leader>gd", "<cmd>DiffviewOpen<cr>", desc = "Git Diff (HEAD)" },
      -- Close diffview panel
      { "<leader>gx", "<cmd>DiffviewClose<cr>", desc = "Close Diffview" },
    },
    opts = {
      enhanced_diff_hl = true,
      view = {
        -- Show diffs in a horizontal split
        default = { layout = "diff2_horizontal" },
        file_history = { layout = "diff2_horizontal" },
      },
    },
  },
}
