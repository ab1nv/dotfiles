# Aliases and functions for Competitive Programming.

cpwalias() {
    filename=$(xclip -o | tr "[:upper:]" "[:lower:]" | tr " " "_").cpp
    cp /home/abhinav/code/codebase/templates/basic.cpp "$filename"

    code -g "$filename:8:13"   
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