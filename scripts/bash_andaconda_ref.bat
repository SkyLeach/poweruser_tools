REM TODO: I don't trust any of this.  I may never fix it
REM bash commands
REM lists all of your conda env
conda env list

REM Create a conda env w/ python3
REM -n sets the name for your new env. I call it neovim here
conda create -n neovim python=3.5

REM add neovim for python3 to the env
REM specify version you want here, 0.1.13 up to date ver atm
REM should auto detect ver you need
conda install -c conda-forge neovim=0.1.13

REM use the list cmd again and extract the path to new env
conda env list

REM neovim init.vim file cmd
REM runs python3 for neovim from a specific env
REM should resolve the need for neovim in each new python env when using nvim
REM add the following to your init.vim file
REM let g:python3_host_prog = '/path/to/neovim/env/bin/python'



