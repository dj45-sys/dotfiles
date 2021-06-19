" auto-install vim-plug
if empty(glob('~/.config/nvim/autoload/plug.vim'))
  silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  "autocmd VimEnter * PlugInstall
  "autocmd VimEnter * PlugInstall | source $MYVIMRC
endif

call plug#begin('~/.config/nvim/autoload/plugged')

    " Better Syntax Support
    Plug 'sheerun/vim-polyglot'
    " File Explorer
    Plug 'scrooloose/NERDTree'
    " Auto pairs for '(' '[' '{'
    Plug 'jiangmiao/auto-pairs'
    " Discord Rich Presence
    Plug 'andweeb/presence.nvim'
    " Theme
    Plug 'drewtempelmeyer/palenight.vim'   
    " Icons
    Plug 'ryanoasis/vim-devicons'
    " Emmet
    Plug 'mattn/emmet-vim'
    " Prettier Code Formater
    Plug 'prettier/prettier'
    " Wakatime API
    Plug 'wakatime/vim-wakatime'
    " Lua Syntax Highlight
    Plug 'euclidianace/betterlua.vim'
    " Autocomplete for IA
    Plug 'zxqfl/tabnine-vim'
    " Intellisense
    Plug 'neoclide/coc.nvim'
    " Tabnine Intellisense Integration
    Plug 'neoclide/coc-tabnine'
    " NERDTree Git Status
    Plug 'xuyuanp/nerdtree-git-plugin'
    " Airline status bar
    Plug 'vim-airline/vim-airline'
    Plug 'vim-airline/vim-airline-themes'
    " NERDCommenter
    Plug 'preservim/nerdcommenter'
    "C/C++ Highlight
    Plug 'bfrg/vim-cpp-modern'    
call plug#end()
