if type -q eza
    alias ll "eza -l -g --icons"
    alias lla "ll -a"
end

# Rust cargo
set -gx PATH "$HOME/.cargo/bin" $PATH
# end

# Nvm Node
set --universal nvm_default_version v22
# end

# pnpm
set -gx PNPM_HOME "$HOME/.local/share/pnpm"
set -gx PATH "$PNPM_HOME" $PATH
alias pn=pnpm
# end

# Golang
set -gx GO_HOME /usr/local/go/bin
set -gx PATH "$GO_HOME" $PATH
# end

# Default config for prettierd
set -u PRETTIERD_DEFAULT_CONFIG "$HOME/.config/nvim/plugin.prettierrc.json"
# end

# The fuck 
function fuck -d "Correct your previous console command"
    set -l fucked_up_command $history[1]
    env TF_SHELL=fish TF_ALIAS=fuck PYTHONIOENCODING=utf-8 thefuck $fucked_up_command THEFUCK_ARGUMENT_PLACEHOLDER $argv | read -l unfucked_command
    if [ "$unfucked_command" != "" ]
        eval $unfucked_command
        builtin history delete --exact --case-sensitive -- $fucked_up_command
        builtin history merge ^ /dev/null
    end
end
# end

# deno
export DENO_INSTALL="$HOME/.deno"
export PATH="$DENO_INSTALL/bin:$PATH"

# Alias
alias vi nvim
alias pn pnpm
alias python python3
alias lpdc "cp $HOME/.config/nvim/default_var/.prettierrc ./"
alias dk docker
alias dkll "docker ps"
alias dkla "docker ps -a"
alias dks "docker start"


# git
alias ga "git add"
alias gc "git commit -m"
alias gp "git push"
alias gb "git branch"
alias gco "git checkout"
# end

# Power
alias pwoff "shutdown now"

# 1.1.1.1
alias 1.1 "warp-cli connect"
alias 1.0 "warp-cli disconnect"

alias rm "rm -i"
alias top bpytop
alias nf neofetch


function tmux_shortcuts
    echo
    set_color brgreen
    echo "🖥️  Tmux Shortcuts  (Prefix = Ctrl+A)"
    set_color normal
    echo
    printf "  %-28s %s\n" "🪟  Window" ""
    set_color white
    printf "  %-28s %s\n" "Prefix + n" "Next window"
    printf "  %-28s %s\n" "Prefix + p" "Previous window"
    printf "  %-28s %s\n" "Prefix + X" "Kill window"
    set_color normal
    echo
    printf "  %-28s %s\n" "📐 Pane" ""
    set_color white
    printf "  %-28s %s\n" "Prefix + v" "Split vertical ▯"
    printf "  %-28s %s\n" "Prefix + s" "Split horizontal ▔"
    printf "  %-28s %s\n" "Prefix + h / j / k / l" "Move ← ↓ ↑ →"
    printf "  %-28s %s\n" "Prefix + H / J / K / L" "Resize ← ↓ ↑ →"
    printf "  %-28s %s\n" "Prefix + x" "Kill pane"
    set_color normal
    echo
    printf "  %-28s %s\n" "📋 Other" ""
    set_color white
    printf "  %-28s %s\n" "Prefix + r" "Reload config"
    printf "  %-28s %s\n" "Prefix + [" "Copy mode (vi keys)"
    printf "  %-28s %s\n" "Prefix + ]" "Paste"
    set_color normal
    echo
end


status is-interactive; and not set -q TMUX_POPUP; and tmux_shortcuts

starship init fish | source

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
if test -f "$HOME/anaconda3/bin/conda"
    eval "$HOME/anaconda3/bin/conda" "shell.fish" "hook" $argv | source
else
    if test -f "$HOME/anaconda3/etc/fish/conf.d/conda.fish"
        . "$HOME/anaconda3/etc/fish/conf.d/conda.fish"
    else
        set -x PATH "$HOME/anaconda3/bin" $PATH
    end
end
# <<< conda initialize <<<

fish_vi_key_bindings

# bun
set --export BUN_INSTALL "$HOME/.bun"
set --export PATH $BUN_INSTALL/bin $PATH

# Added by Antigravity IDE
fish_add_path $HOME/.antigravity-ide/antigravity-ide/bin


# Added by Antigravity CLI installer
set -gx PATH "$HOME/.local/bin" $PATH

# Anti - Open folder/file on client machine
set -gx PATH $PATH $HOME/.garden/bin

# Go (user-local install) + sesh
set -gx PATH "$HOME/go-install/go/bin" "$HOME/go/bin" $PATH

# zoxide
zoxide init fish | source

# Fix missing terminfo (Ghostty, etc)
if not infocmp $TERM &>/dev/null
    set -gx TERM xterm-256color
end

# tmux: always attach to 'main' instead of creating new sessions
alias tmux="tmux new-session -A -s main"

# Auto-attach tmux on SSH
if status is-interactive; and test -z "$TMUX"; and test -n "$SSH_CONNECTION"
    command tmux new-session -A -s main
end

# opencode
fish_add_path /home/samsa/.opencode/bin
