return {
	{
		"hardhackerlabs/theme-vim",
		name = "hardhacker",
		lazy = false,
		priority = 1000,
		config = function()
			vim.g.hardhacker_darker = 0
			vim.g.hardhacker_hide_tilde = 1
			vim.g.hardhacker_keyword_italic = 1
			-- vim.cmd("colorscheme hardhacker")
		end,
	},
	{
		"folke/tokyonight.nvim",
		lazy = false,
		priority = 1000,
		config = function()
			-- vim.cmd("colorscheme tokyonight-storm")
		end,
	},
	{ 
        "catppuccin/nvim",
		name = "catppuccin",
		lazy = false,
		priority = 1000,
		config = function()
			require("catppuccin").setup({
              flavour = "mocha",
			  color_overrides = {
				mocha = {
					base = "#161616",
					mantle = "#161616",
					crust = "#161616",
				},
              },
			  integrations = {
				cmp = true,
				gitsigns = true,
				nvimtree = true,
				telescope = true,
				treesitter = true,
				notify = false,
				mini = false,
			  }
			})
            vim.cmd.colorscheme "catppuccin"
		end,
    },
}
