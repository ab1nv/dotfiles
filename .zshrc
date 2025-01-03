export ZSH="$HOME/.oh-my-zsh"
export PATH="$HOME/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/.local/share/nvim/mason/bin:$PATH"
export PATH="$HOME/.cargo/bin:$PATH"
export PATH="$PATH:$HOME/apps/flutter/bin"
export PATH="$PATH:$HOME/go/bin"
export DENO_INSTALL="/home/hynduf/.deno"
export PATH="$DENO_INSTALL/bin:$PATH"
export ANDROID_SDK_ROOT='/opt/android-sdk'
export PATH=$PATH:$ANDROID_SDK_ROOT/platform-tools/
# export PATH=$PATH:$ANDROID_SDK_ROOT/tools/bin/
export PATH=$PATH:$ANDROID_ROOT/emulator
export PATH=$PATH:$ANDROID_SDK_ROOT/tools/
export PATH=$PATH:$ANDROID_SDK_ROOT/cmdline-tools/latest/bin
export GEM_HOME="$(ruby -e 'puts Gem.user_dir')"
export PATH="$PATH:$GEM_HOME/bin"
export EDITOR=nvim
export VISUAL=nvim
export JAVA_HOME=/usr/lib/jvm/java-21-openjdk
export PATH="$HOME/.linuxbrew/bin:$PATH"
export MANPATH="$HOME/.linuxbrew/share/man:$MANPATH"
export INFOPATH="$HOME/.linuxbrew/share/info:$INFOPATH"
export _JAVA_AWT_WM_NONREPARTENTING=1
export FZF_DEFAULT_COMMAND="find \! \( -path '*/.git' -prune \) -printf '%P\n'"
export FZF_DEFAULT_OPTS='
  --color fg:#a9b1d6,bg:#11111b
  --color bg+:#2f263d,fg+:#a9b1d6,hl:#7aa2f7,hl+:#ff9e64,gutter:#3a404c
  --color pointer:#9ece6a,prompt:#ff7a93,info:#606672,spinner:#9ece6a
  --height 15'
export FZF_CTRL_T_COMMAND="find \! \( -path '*/.git' -prune \) -printf '%P\n'"
export FZF_ALT_C_COMMAND='find . -type d'

ZSH_THEME="pacman"

plugins=(git
        fzf-tab
        archlinux
        zsh-syntax-highlighting
        colorize        
        sudo    
        command-not-found)

source $ZSH/oh-my-zsh.sh

alias v='nvim'
alias l='colorls --group-directories-first --almost-all'
alias ll='colorls --group-directories-first --almost-all --long'

alias e='erdtree_level'
erdtree_level() {
  local level="$1"
  shift
  erd -H -I -i -. --no-git -L "$level" "$@"
}

alias pom='~/bin/switch-desktop-workaround 7 follow & pomo start -t my-project "Study now"'
alias r='ranger'
alias f='fzf'
alias ss='screenshot'
alias sv='sudoedit'

# Start jupyter notebook and edit something with neovim
# Usage: juv test.sync.py
alias juv='conda activate d2l > /dev/null 2>&1 && jupyter notebook > /dev/null 2>&1 & v'

# Create a paired .py file (in percent format) from a .ipynb file
# Usage: jug test.sync.ipynb
alias jug='jupytext --set-formats ipynb,py:percent'

setopt extendedglob
source $(dirname $(gem which colorls))/tab_complete.sh

# Comment this to upgrade miniconda3 package safely
[ -f /opt/miniconda3/etc/profile.d/conda.sh ] && source /opt/miniconda3/etc/profile.d/conda.sh

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
source /usr/share/z/z.sh

ulimit -s unlimited


# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/opt/miniconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/opt/miniconda3/etc/profile.d/conda.sh" ]; then
        . "/opt/miniconda3/etc/profile.d/conda.sh"
    else
        export PATH="/opt/miniconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

source /usr/share/nvm/init-nvm.sh