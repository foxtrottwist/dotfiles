return {
	"goolord/alpha-nvim",
	event = "VimEnter",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function()
		local alpha = require("alpha")
		local dashboard = require("alpha.themes.dashboard")

		dashboard.section.header.val = {
			"                                                                                                                                             ",
			"          n@@@@@@@@@@@@@@@@@@@@@@@@@@@-                                                                                                      ",
			"          @@@@@@@@@@@@@@@@@@@@@@@@@@@@                                                                                                       ",
			"         <@@@@r-----------------f@@@@s                                                                                                       ",
			"         @@@@@                  )@@@@                                                                                                        ",
			"        ,@@@@;                  @@@@@                                                                                                        ",
			"        @@@@@                  ,@@@@;      fyk*v           >2k**_      -P*k1           P*VP           *ykP      fP*Vv           >yk**_       ",
			"        @@@@n                  @@@@@       @@@@]         :@@@@@@       @@@@V          4@@@@          L@@@@      @@@@]         :@@@@@@        ",
			"       c@@@@                   @@@@u      !@@@@         h@@@@@@@       @@@@           @@@@,          @@@@)     !@@@@         x@@@@@@@        ",
			"       @@@@@                  ?@@@@       @@@@o       r@@@d@@@@:      1@@@@          +@@@@          ,@@@@      @@@@*       r@@@@@@@@:        ",
			"      :@@@@:                  @@@@@       @@@@       @@@@,(@@@@       @@@@!          @@@@c          @@@@4      @@@@       @@@@,(@@@@         ",
			"      @@@@@                  :@@@@_      s@@@@     <@@@>  @@@@c      (@@@@          .@@@@           @@@@.     7@@@@     <@@@c  @@@@c         ",
			"      @@@@?                  @@@@@       @@@@'   .@@@@`  ,@@@@       @@@@n          @@@@@          >@@@@      @@@@'   ,@@@@'  ,@@@@          ",
			"     [@@@@                   @@@@?      '@@@@   u@@@+    @@@@@      '@@@@           @@@@-          @@@@)     '@@@@   u@@@+    @@@@@          ",
			"     @@@@@                  n@@@@       @@@@[ !@@@@      @@@@.      3@@@@          ]@@@@          :@@@@      @@@@[ !@@@@      @@@@.          ",
			"    _@@@@-                  @@@@@       @@@@!k@@@r      c@@@@       @@@@!          @@@@c          @@@@y      @@@@!P@@@r      ]@@@@           ",
			"    @@@@@                  ;@@@@-      F@@@@@@@o        @@@@L      L@@@@          -@@@@           @@@@`     F@@@@@@@2        @@@@+           ",
			"    @@@@]                  @@@@@       @@@@@@@!        -@@@@       @@@@Y          @@@@@          7@@@@      @@@@@@@_        -@@@@            ",
			"   x@@@@                   @@@@c      +@@@@@s          @@@@V      -@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@r     +@@@@@I          @@@@4            ",
			"   @@@@Y                  L@@@@       @@@@@-           @@@@`      n@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@      @@@@@,           @@@@`            ",
		}

		dashboard.section.buttons.val = {
			dashboard.button("f", "  > Find File", ":Telescope find_files<CR>"),
			dashboard.button("m", "  > Marks", ":lua require('harpoon').ui:toggle_quick_menu(require('harpoon'):list())<CR>"),
			dashboard.button("r", "  > Recent", ":Telescope oldfiles<CR>"),
		}

		-- Send config to alpha
		alpha.setup(dashboard.opts)

		-- Disable folding on alpha buffer
		vim.cmd([[autocmd FileType alpha setlocal nofoldenable]])
	end,
}
