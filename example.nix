{ pkgs, dsl }: with dsl; {

  set.number = true;

  use.lsp_signature.setup = callWith {
    bind = true;
    hint_enable = false;
    hi_parameter = "Visual";
    handler_opts.border = "single";
  };

  use."nvim-treesitter.configs".setup = callWith {
    ensure_installed = [ "bash" "c" "css" "javascript" "json" "lua" "nix" "python" "rust" "toml" ];
    highlight = {
      enable = true;
      disable = [ "css" ];
    };
    rainbow = {
      enable = true;
      disable = [ "html" ];
      extended_mode = true;
      max_file_lines = 10000;
      colors = [ "#bd93f9" "#6272a4" "#8be9fd" "#50fa7b" "#f1fa8c" "#ffb86c" "#ff5555" ];
    };
  };


  vim.g = {
    mapleader = " ";
    nofoldenable = true;
    noshowmode = true;
    completeopt = "menu,menuone,noselect";
  };
  vim.o = {
    termguicolors = true;
    showcmd = true;
    showmatch = true;
    ignorecase = true;
    smartcase = true;
    cursorline = true;
    wrap = true;
    autoindent = true;
    copyindent = true;
    splitbelow = true;
    splitright = true;
    relativenumber = true;
    title = true;
    undofile = true;
    autoread = true;
    hidden = true;
    list = true;
    background = "dark";
    backspace = "indent,eol,start";
    undolevels = 1000000;
    undoreload = 1000000;
    foldmethod = "indent";
    foldnestmax = 10;
    foldlevel = 1;
    scrolloff = 3;
    sidescrolloff = 5;
    listchars = "tab:→→,trail:●,nbsp:○";
    clipboard = "unnamed,unnamedplus";
    formatoptions = "tcqj";
    encoding = "utf-8";
    fileencoding = "utf-8";
    fileencodings = "utf-8";
    bomb = true;
    binary = true;
    matchpairs = "(:),{:},[:],<:>";
    expandtab = true;
    pastetoggle = "<leader>v";
    wildmode = "list:longest,list:full";
  };
}