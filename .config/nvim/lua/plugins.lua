local execute = vim.api.nvim_command
local fn = vim.fn

local install_path = fn.stdpath('data') .. '/site/pack/packer/opt/packer.nvim'

if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({'git', 'clone', 'https://github.com/wbthomason/packer.nvim', install_path})
    execute 'packadd packer.nvim'
end

vim.cmd "autocmd BufWritePost plugins.lua PackerCompile" -- Auto compile when there are changes in plugins.lua

return require("packer").startup(function()
    -- Packer can manage itself
    use "wbthomason/packer.nvim"

    -- Theme
    use 'Rigellute/rigel'

    -- Language Client
    use {
        'neoclide/coc.nvim',
        branch = 'release'
    }

    -- Language support ~ Front-End
    use 'yuezk/vim-js'
    use 'HerringtonDarkholme/yats.vim'
    use 'maxmellon/vim-jsx-pretty'
    use 'jparise/vim-graphql'

    use {
        'styled-components/vim-styled-components',
        branch = 'main'
    }

    -- Language support ~ Elixir
    use 'elixir-editors/vim-elixir'
    use 'slashmili/alchemist.vim'
    use 'mhinz/vim-mix-format'

    -- Language support ~ Ruby
    use 'vim-ruby/vim-ruby'

    -- Language support ~ Rust
    use 'rust-lang/rust.vim'

    -- Language support ~ Swift
    use 'toyamarinyon/vim-swift'

    -- Navigation
    use {
        'nvim-telescope/telescope.nvim',
        requires = {{'nvim-lua/popup.nvim'}, {'nvim-lua/plenary.nvim'}}
    }

    use 'kyazdani42/nvim-tree.lua'
    use 'phaazon/hop.nvim'

    -- Session Management
    use 'rmagatti/auto-session'
    use 'rmagatti/session-lens'

    -- Version Control
    use 'airblade/vim-gitgutter'

    -- Status bar
    use 'vim-airline/vim-airline'
    use 'vim-airline/vim-airline-themes'

    -- Treesitter
    use {
        "nvim-treesitter/nvim-treesitter",
        run = ":TSUpdate"
    }

    use "windwp/nvim-ts-autotag"

    -- Snazzy tabs
    use {
        'akinsho/nvim-bufferline.lua',
        requires = 'kyazdani42/nvim-web-devicons',
        config = function()
            require('bufferline').setup {
                options = {
                    offsets = {{
                        filetype = "NvimTree",
                        text = "File Explorer",
                        highlight = "Directory",
                        text_align = "left"
                    }},
                    separator_style = "slant"
                }
            }
        end
    }

    -- Terminal Integration
    use {
        'akinsho/nvim-toggleterm.lua',
        config = function()
            require('toggleterm').setup {
                size = 20,
                open_mapping = [[<C-j>]],
                shade_filetypes = {},
                shade_terminals = true,
                shading_factor = '1',
                start_in_insert = true,
                persist_size = true,
                direction = 'horizontal'
            }
        end
    }

    -- Comment out line(s)
    use 'b3nj5m1n/kommentary'

    -- Distraction-free writing mode
    use 'junegunn/goyo.vim'

end)
