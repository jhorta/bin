#!/bin/bash
echo "Installing dependencies."
sudo apt-get install silversearcher-ag
sudo apt-get install tmux
sudo apt-get install zsh
sudo apt-get install git-core
wget https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - | zsh
chsh -s `which zsh`

echo "Installing vim plugins......"
# setup pathogen
mkdir -p ~/.vim/autoload ~/.vim/bundle && \
curl -LSso ~/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim
 
cd ~/.vim/bundle
########### Download nerdtree
if [ ! -e "nerdtree" ]; then
  git clone https://github.com/scrooloose/nerdtree.git
fi
########### Download and set up fugitive
if [ ! -e "vim-fugitive" ]; then
  git clone git://github.com/tpope/vim-fugitive.git
  vim -u NONE -c "helptags vim-fugitive/doc" -c q
fi
########### Download syntastic
if [ ! -e "syntastic" ]; then
  git clone https://github.com/scrooloose/syntastic.git
fi
########### Download vim-colors-solarized
if [ ! -e "vim-colors-solarized" ]; then
  git clone git://github.com/altercation/vim-colors-solarized.git
  wget https://raw.githubusercontent.com/nanotech/jellybeans.vim/master/colors/jellybeans.vim
  mv jellybeans.vim vim-colors-solarized/colors
fi
########### Download nerdCommenter
if [ ! -e "nerdcommenter" ]; then
git clone https://github.com/scrooloose/nerdcommenter.git
fi
########### Download vim-gutter
if [ ! -e "vim-gitgutter" ]; then
git clone git://github.com/airblade/vim-gitgutter.git
fi
########### Download supertab
if [ ! -e "supertab" ]; then
git clone https://github.com/ervandew/supertab.git
fi
########### Download rust vim
if [ ! -e "rust.vim" ]; then
git clone https://github.com/wting/rust.vim.git
fi
########### Download vim-surround
if [ ! -e "vim-surround" ]; then
git clone git://github.com/tpope/vim-surround.git
fi
########### Download vimux
if [ ! -e "vimux" ]; then
git clone https://github.com/benmills/vimux.git
fi
########### Download ctrlp
# Run at Vim's command line:
# :helptags ~/.vim/bundle/ctrlp.vim/doc
# Restart Vim and check :help ctrlp.txt for usage instructions and configuration details
if [ ! -e "ctrlp.vim" ]; then
git clone https://github.com/kien/ctrlp.vim.git
fi
########### Download vim-airline
if [ ! -e "vim-airline" ]; then
git clone https://github.com/bling/vim-airline ~/.vim/bundle/vim-airline
fi
 
 
###############################################################
###############################################################
###################Generate vimrc file#########################
#!/bin/bash
echo "Creating vimrc file."
cat > ~/.vimrc << EOF
execute pathogen#infect()
syntax on
set nocompatible              " be iMproved
filetype plugin indent on     " required!
autocmd vimenter * NERDTree   " Open nerd tree when no file specified
map <C-n> :NERDTreeToggle<CR> " Open nerd tree with Ctrl + C
" Recommended settings for nerdcommenter
filetype plugin on
 
" Recommended syntastic settings
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*
 
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
let g:syntastic_cpp_compiler = 'clang++'
let g:syntastic_cpp_compiler_options = ' -std=c++11 -stdlib=libc++'
" End of syntastic settings
 
" Recommended settings for ctrl P
set runtimepath^=~/.vim/bundle/ctrlp.vim
let g:ctrlp_map = '<c-p>'
let g:ctrlp_cmd = 'CtrlP'
let g:ctrlp_working_path_mode = 'ra'
set wildignore+=*/tmp/*,*.so,*.swp,*.zip     " Linux/MacOSX
 
let g:ctrlp_custom_ignore = '\v[\/]\.(git|hg|svn)$'
" The Silver Searcher
if executable('ag')
  " Use ag over grep
  set grepprg=ag\ --nogroup\ --nocolor
 
  " Use ag in CtrlP for listing files. Lightning fast and respects .gitignore
  let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'
 
  " ag is fast enough that CtrlP doesn't need to cache
  let g:ctrlp_use_caching = 0
endif
 
" Recommended settings for vim airline
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#left_sep = ' '
let g:airline#extensions#tabline#left_alt_sep = '|'
 
" Recommended settings for vim-colors
syntax enable
set background=light
colorscheme jellybeans
let g:solarized_termcolors=256
if has('gui_running')
    set background=light
else
    set background=dark
endif

" Recommended settings for vim-gutter
let g:gitgutter_sign_column_always = 1
let g:gitgutter_highlight_lines = 1
let g:gitgutter_sign_added = '++'
let g:gitgutter_sign_modified = 'MM'
let g:gitgutter_sign_removed = '--'
let g:gitgutter_sign_removed_first_line = '^^'
let g:gitgutter_sign_modified_removed = 'ww'
 
 
" bind K to grep word under cursor
nnoremap K :grep! "\b<C-R><C-W>\b"<CR>:cw<CR>
 
nnoremap <C-T> :w<CR>:call VimuxRunCommand("clear; run " . expand("%:p"))<CR>
:command CreateTemplate :call VimuxRunCommand("template " . expand("%:p"))<CR>
 
" http://vimcasts.org/e/1/
nmap <leader>l :set list!<CR>
nmap <leader>n :set number!<CR>
set listchars=tab:▸\ ,eol:¬
 
" http://vimcasts.org/e/2/
set shiftwidth=2
set tabstop=2
set softtabstop=2
set expandtab
set nu
 
" http://vimcasts.org/e/58/
set clipboard=unnamed
 
" http://vimcasts.org/e/3/
set laststatus=2
 
if has("autocmd")
  filetype on
 
  autocmd FileType go setlocal noexpandtab
  autocmd BufNewFile,BufRead *.rss,*.atom setfiletype xml
  au FileType go nmap <Leader>s <Plug>(go-implements)
  au FileType go nmap <Leader>i <Plug>(go-info)
  au FileType go nmap <Leader>gd <Plug>(go-doc)
  au FileType go nmap <Leader>gv <Plug>(go-doc-vertical)
  au FileType go nmap <Leader>gb <Plug>(go-doc-browser)
  au FileType go nmap <leader>r <Plug>(go-run)
  au FileType go nmap <leader>b <Plug>(go-build)
  au FileType go nmap <leader>t <Plug>(go-test)
  au FileType go nmap <leader>c <Plug>(go-coverage)
  au FileType go nmap <Leader>ds <Plug>(go-def-split)
  au FileType go nmap <Leader>dv <Plug>(go-def-vertical)
  au FileType go nmap <Leader>dt <Plug>(go-def-tab)
  au FileType go nmap <Leader>e <Plug>(go-rename)
endif
set hlsearch
highlight LineNr ctermfg=yellow 
"End of file
EOF
echo "Done creating vimrc file."
 
home=~
echo "Getting vim automation scripts."
cd ~/.vim
if [ ! -e "bin" ]; then
  git clone https://github.com/jhorta/bin.git
  chmod +x bin/run
  chmod +x bin/template
fi
echo "Done!"

####################################################################
built_path="${home}/.vim/bin:${PATH}"

if [[ "$OSTYPE" == "linux-gnu" ]]; then
  echo "export PATH=${built_path}" >> ~/.bashrc
  source ~/.bashrc
elif [[ "$OSTYPE" == "darwin"* ]]; then
  # Mac OSX
  echo "export PATH=${built_path}" >> ~/.profile
  source ~/.profile
elif [[ "$OSTYPE" == "cygwin" ]]; then
  # POSIX compatibility layer and Linux environment emulation for Windows
  echo "Cygwin is not currently supported! Please include ~/.vim/bin to PATH environment variable."
else
  echo "Unrecognized operating system! Please include ~/.vim/bin to PATH environment variable."
fi

echo "We need to restart your system in order for changes to take effect."
echo "Do you want to restart your system now? [Y/N]"

read response
case $response in
  [Y/y/Yes/yes])
    echo "Restarting system now!"
    sleep 1
    sudo shutdown -r 0
    ;;
  *)
    echo "System not restarting."
    echo "Perform manual restart for changes to take effect."
    ;;
esac
