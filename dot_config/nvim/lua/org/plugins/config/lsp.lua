local function join_path(...)
  local ok, path = pcall(vim.fs.joinpath, ...)
  if ok then
    return path
  end
  local segments = { ... }
  return table.concat(segments, "/")
end

local function file_exists(path)
  return vim.fn.filereadable(path) == 1
end

return function()
  local schemastore = require("schemastore")

  local schema_root = join_path(vim.fn.stdpath("config"), "schema")
  local table_schema = join_path(schema_root, "metadata", "TableYAML.schema.json")

  local custom_schemas = {}
  if file_exists(table_schema) then
    custom_schemas[table_schema] = {
      "**/tables/**/*.yaml",
      "**/tables/**/*.yml",
    }
  end

  -- nvim 0.11+ native LSP config (replaces lspconfig framework)
  vim.lsp.config('yamlls', {
    cmd = { 'yaml-language-server', '--stdio' },
    filetypes = { 'yaml', 'yaml.docker-compose', 'yaml.gitlab' },
    root_dir = function(fname)
      return vim.fs.root(fname, { '.git', '.yamllint', 'package.json' })
    end,
    settings = {
      yaml = {
        schemas = vim.tbl_extend("force", schemastore.yaml.schemas(), custom_schemas),
        schemaStore = {
          enable = false,
          url = "",
        },
      },
    },
  })
  vim.lsp.enable('yamlls')
end
