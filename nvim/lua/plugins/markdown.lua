return {
  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    ft = { "markdown" },
    build = "cd app && npm install && npm run build",
  },
  {
    "jakewvincent/mkdnflow.nvim",
    ft = { "markdown", "rmd" },
    opts = {},
  },
}
