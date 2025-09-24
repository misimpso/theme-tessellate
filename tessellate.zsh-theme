# Tessellate Oh My ZSH Theme
# Converted from Oh My Fish theme
# Inspired by `bobthefish` and `ocean` themes

# Helper function to get normalized PWD
__pwd() {
    pwd -P 2>/dev/null || echo $PWD
}

# Helper function to replace home directory with tilde
__tilde_path() {
    local pth="$1"
    echo "${pth/#$HOME/~}"
}

# Get git branch name with truncation
_git_branch_name() {
    local max_len=20
    local branch=$(git symbolic-ref HEAD 2>/dev/null | sed -e 's|^refs/heads/||')
    if [[ ${#branch} -gt $max_len ]]; then
        branch="${branch:0:$((max_len-3))}..."
    fi
    echo "$branch"
}

# Check if git repository is dirty
_is_git_dirty() {
    git status -s --ignore-submodules=dirty 2>/dev/null
}

# Main prompt function
tessellate_prompt() {
    local blue="%{$fg[blue]%}"
    local green="%{$fg[green]%}"
    local red="%{$fg[red]%}"
    local normal="%{$reset_color%}"
    
    local VIRTUAL_ENV_DIR=""
    local CURRENT_DIR="$(__tilde_path $(__pwd))"
    local GIT_BRANCH="$(_git_branch_name)"
    
    # Handle virtual environment
    if [[ -n "$VIRTUAL_ENV" ]]; then
        VIRTUAL_ENV_DIR="$(__tilde_path $(dirname $VIRTUAL_ENV))"
        CURRENT_DIR="${CURRENT_DIR#$VIRTUAL_ENV_DIR}"
        CURRENT_DIR="${blue}${VIRTUAL_ENV_DIR}${normal}${CURRENT_DIR}"
    fi
    
    # Build prompt
    local prompt_string="[ "
    
    # Add git branch with status color
    if [[ -n "$GIT_BRANCH" ]]; then
        if [[ -n "$(_is_git_dirty)" ]]; then
            prompt_string+="${red}"
        else
            prompt_string+="${green}"
        fi
        prompt_string+="(${GIT_BRANCH}) ${normal}"
    fi
    
    prompt_string+="${CURRENT_DIR}"
    prompt_string+=" ] ${normal}"
    
    echo "$prompt_string"
}

# Set the prompt
PROMPT='$(tessellate_prompt)'