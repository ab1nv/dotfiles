ZSH_THEME="powerlevel10k/powerlevel10k"


if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

export ZSH="$HOME/.oh-my-zsh"

plugins=(git zsh-autosuggestions zsh-syntax-highlighting)

source $ZSH/oh-my-zsh.sh

if command -v tmux &> /dev/null && [ -z "$TMUX" ]; then tmux; fi

# Aliases and functions for Competitive Programming.

cpwalias() {
    filename=$(xclip -o | tr "[:upper:]" "[:lower:]" | tr " " "_").cpp
    cp /home/abhinav/code/codebase/templates/basic.cpp "$filename"

    code -g "$filename:8:15"   
}


cpralias() {
    base_name="${1%.cpp}"
    g++ -std=c++23 -O2 -Wall "$base_name.cpp" -o "$base_name"
    if [ $? -eq 0 ]; then
        ./"$base_name"
        
        if [ "$2" != "--retain" ]; then
            rm "$base_name"
        fi
    fi
}

alias cpw=cpwalias
alias cpr=cpralias

# Setting up Go environment
export GOPATH=$HOME/go
export GOBIN=$GOPATH/bin
export PATH=$PATH:$GOBIN

export PATH="/home/abhinav/.local/bin:$PATH"

# Aliases

alias reload='source ~/.zshrc'

alias gscp='!f() { git add . && git commit -m "$1" && git push origin main; }; f'
alias gfetch='git fetch origin && git log HEAD..origin/main --oneline'
alias gup='git fetch origin && git merge origin/main'
alias gs='git status -sb'
alias gco='git checkout'
alias gb='git branch'
export PATH=$PATH:/home/abhinav/.spicetify
