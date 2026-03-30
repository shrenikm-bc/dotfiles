return {
  "mfussenegger/nvim-dap",
  optional = true,
  opts = function()
    local dap = require("dap")

    if not dap.adapters.python then
      dap.adapters.python = {
        type = "executable",
        command = "python3",
        args = { "-m", "debugpy.adapter" },
      }
    end

    dap.configurations.python = dap.configurations.python or {}

    table.insert(dap.configurations.python, {
      type = "python",
      request = "attach",
      name = "Attach to Sandbox (Port 5678)",
      connect = {
        host = "localhost",
        port = 5678,
      },
      pathMappings = {
        {
          localRoot = vim.fn.expand("~/shining_software/src"),
          remoteRoot = "/opt/shining_software",
        },
      },
      justMyCode = false,
    })
  end,
}
