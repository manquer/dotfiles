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
  local lspconfig = require("lspconfig")
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

  lspconfig.yamlls.setup({
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
end
