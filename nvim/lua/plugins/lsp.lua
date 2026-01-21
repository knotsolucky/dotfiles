local servers = {
	lua_ls = {
		Lua = {
			diagnostics = { globals = { "vim" } },
			workspace = { checkThirdParty = false },
			telemetry = { enable = false },
		},
	},
	ts_ls = {},
	pyright = {
		settings = {
			python = {
				analysis = { typeCheckingMode = "basic", autoImportCompletions = true, useLibraryCodeForTypes = true },
			},
		},
	},
	bashls = {},
	jsonls = {},
	yamlls = {},
	tailwindcss = {},
	clangd = {
		cmd = {
			"clangd",
			"--background-index",
			"--clang-tidy",
			"--header-insertion=never",
			"--completion-style=bundled",
		},
	},
	csharp_ls = {},
	harper_ls = {},
	jdtls = {},
}

local tool_installs = {
	"stylua",
	"prettier",
	"eslint_d",
	"tailwindcss-language-server",
	"isort",
	"typescript-language-server",
	"shellcheck",
	"shfmt",
	"yamlfmt",
	"clang-format",
	"csharpier",
	"csharp-language-server",
	"harper-ls",
	"google-java-format",
	"checkstyle",
	"trivy",
	"jdtls",
	"java-debug-adapter",
}

return {
	{
		"neovim/nvim-lspconfig",
		event = { "BufReadPre", "BufNewFile" },
		dependencies = {
			{ "williamboman/mason.nvim", build = ":MasonUpdate" },
			"williamboman/mason-lspconfig.nvim",
			"WhoIsSethDaniel/mason-tool-installer.nvim",
			"hrsh7th/cmp-nvim-lsp",
			{ "folke/neodev.nvim", opts = {} },
		},
		config = function()
			require("mason").setup()
			require("mason-tool-installer").setup({
				ensure_installed = tool_installs,
				auto_update = true,
				run_on_start = true,
				start_delay = 3000,
			})

			local capabilities = require("cmp_nvim_lsp").default_capabilities()
			local function on_attach(client, bufnr)
				local map = function(mode, lhs, rhs, desc)
					vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
				end
				local lmap = function(keys, rhs, desc)
					map("n", "<leader>l" .. keys, rhs, desc)
				end

				if client.name == "ts_ls" or client.name == "lua_ls" then
					client.server_capabilities.documentFormattingProvider = false
					client.server_capabilities.documentRangeFormattingProvider = false
				end

				map("n", "gd", vim.lsp.buf.definition, "Go to definition")
				map("n", "gr", vim.lsp.buf.references, "Go to references")
				map("n", "gD", vim.lsp.buf.declaration, "Go to declaration")
				map("n", "gi", vim.lsp.buf.implementation, "Go to implementation")
				map("n", "K", vim.lsp.buf.hover, "Hover documentation")
				map("n", "[d", vim.diagnostic.goto_prev, "Previous diagnostic")
				map("n", "]d", vim.diagnostic.goto_next, "Next diagnostic")

				lmap("dd", vim.diagnostic.open_float, "Diagnostics (cursor)")
				lmap("dD", vim.diagnostic.setloclist, "Diagnostics list")
				lmap("dn", vim.diagnostic.goto_next, "Diagnostic next")
				lmap("dp", vim.diagnostic.goto_prev, "Diagnostic previous")
				lmap("ar", vim.lsp.buf.rename, "Rename symbol")
				lmap("aa", vim.lsp.buf.code_action, "Code actions")
				lmap("af", function()
					vim.lsp.buf.format({ async = true })
				end, "Format buffer")
				lmap("gs", vim.lsp.buf.document_symbol, "Document symbols")
				lmap("gS", vim.lsp.buf.workspace_symbol, "Workspace symbols")
				lmap("gI", vim.lsp.buf.incoming_calls, "Incoming calls")
				lmap("gO", vim.lsp.buf.outgoing_calls, "Outgoing calls")
				lmap("gd", vim.lsp.buf.definition, "Go to definition")
				lmap("gD", vim.lsp.buf.declaration, "Go to declaration")
				lmap("gr", vim.lsp.buf.references, "Go to references")
				lmap("gi", vim.lsp.buf.implementation, "Go to implementation")
				lmap("gt", vim.lsp.buf.type_definition, "Type definition")
				lmap("gh", vim.lsp.buf.hover, "Hover documentation")
				lmap("gk", vim.lsp.buf.signature_help, "Signature help")
				lmap("wl", function()
					print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
				end, "List workspace folders")
				lmap("wa", vim.lsp.buf.add_workspace_folder, "Add workspace folder")
				lmap("wr", vim.lsp.buf.remove_workspace_folder, "Remove workspace folder")

				local ok, wk = pcall(require, "which-key")
				if ok then
					wk.add({
						{ "<leader>la", group = "Actions" },
						{ "<leader>laa", desc = "Code actions" },
						{ "<leader>laf", desc = "Format buffer" },
						{ "<leader>lar", desc = "Rename symbol" },
						{ "<leader>ld", group = "Diagnostics" },
						{ "<leader>ldd", desc = "Diagnostics (cursor)" },
						{ "<leader>ldD", desc = "Diagnostics list" },
						{ "<leader>ldn", desc = "Next diagnostic" },
						{ "<leader>ldp", desc = "Previous diagnostic" },
						{ "<leader>lg", group = "Navigation" },
						{ "<leader>lgd", desc = "Definition" },
						{ "<leader>lgD", desc = "Declaration" },
						{ "<leader>lgr", desc = "References" },
						{ "<leader>lgi", desc = "Implementation" },
						{ "<leader>lgt", desc = "Type definition" },
						{ "<leader>lgh", desc = "Hover" },
						{ "<leader>lgk", desc = "Signature help" },
						{ "<leader>ls", group = "Symbols" },
						{ "<leader>lss", desc = "Document symbols" },
						{ "<leader>lsS", desc = "Workspace symbols" },
						{ "<leader>lsI", desc = "Incoming calls" },
						{ "<leader>lsO", desc = "Outgoing calls" },
						{ "<leader>lw", group = "Workspace" },
						{ "<leader>lwa", desc = "Add folder" },
						{ "<leader>lwl", desc = "List folders" },
						{ "<leader>lwr", desc = "Remove folder" },
					}, { buffer = bufnr, mode = "n" })
				end
			end

			vim.api.nvim_create_autocmd("LspAttach", {
				callback = function(args)
					local client = vim.lsp.get_client_by_id(args.data.client_id)
					if client then
						vim.bo[args.buf].omnifunc = "v:lua.vim.lsp.omnifunc"
					end
				end,
			})

			require("mason-lspconfig").setup({
				ensure_installed = (function()
					local ensure = {}
					local ok, mapping = pcall(require, "mason-lspconfig.mappings.server")
					local available = ok and (mapping.lspconfig_to_package or {}) or {}
					for server in pairs(servers) do
						if available[server] or not ok then
							table.insert(ensure, server)
						end
					end
					return ensure
				end)(),
				automatic_installation = true,
				handlers = {
					function(server_name)
						if server_name == "jdtls" then
							return
						end
						local opts = vim.tbl_deep_extend("force", {}, servers[server_name] or {})
						opts.capabilities = capabilities
						opts.on_attach = on_attach
						if server_name == "clangd" then
							opts.capabilities = vim.deepcopy(capabilities)
							opts.capabilities.offsetEncoding = { "utf-16" }
						end
						if server_name == "csharp_ls" then
							local dotnet_root = vim.env.DOTNET_ROOT or "/opt/homebrew/opt/dotnet/libexec"
							opts.cmd_env = vim.tbl_deep_extend("force", {}, opts.cmd_env or {}, {
								DOTNET_ROOT = dotnet_root,
								PATH = table.concat({
									dotnet_root,
									(opts.cmd_env or {}).PATH or "",
									vim.env.PATH or "",
								}, ":"),
							})
						end
						require("lspconfig")[server_name].setup(opts)
					end,
				},
			})

			vim.diagnostic.config({
				float = { border = "rounded" },
				severity_sort = true,
				virtual_text = { prefix = "●" },
			})
		end,
	},
}
