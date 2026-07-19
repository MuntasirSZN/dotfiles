fish_config theme choose catppuccin-mocha --color-theme=dark

/home/muntasir/.local/bin/mise activate fish | source
zoxide init --cmd cd fish | source
atuin init fish | source
batpipe | source
direnv hook fish | source

function starship_transient_prompt_func
    starship module character
end

if status is-interactive

    fastfetch
    getquotes --offline
    fzf --fish | source
    pay-respects fish --alias | source
    starship init fish | source
    # @fish-lsp-disable-next-line 7001
    enable_transience

    if set -q SSH_CONNECTION
        set -gx EDITOR nano
    else
        set -gx EDITOR nvim
    end

    # Key sequence timeout (zsh KEYTIMEOUT=100 = 1s, fish is ms)
    set -g fish_escape_delay_ms 1000

    set -gx MANPAGER "env BATMAN_IS_BEING_MANPAGER=yes bash /home/muntasir/.local/share/mise/installs/github-eth-p-bat-extras/latest/bin/batman"
    set -gx MANROFFOPT -c
    set -gx BUN_INSTALL "$HOME/.bun"
    set -gx GLAMOUR_STYLE "/home/muntasir/.config/glow/catppuccin-mocha.json"
    set -gx BATPIPE_ENABLE_COLOR true
    set -gx BATDIFF_USE_DELTA true
    set -gx EZA_ICONS_AUTO true
    set -gx LS_COLORS (vivid generate catppuccin-mocha)
    set -gx MANPATH "/usr/local/man:$MANPATH"
    set -gx FZF_DEFAULT_OPTS " \
    --color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8 \
    --color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc \
    --color=marker:#b4befe,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8 \
    --color=selected-bg:#45475a \
    "
    set -gx CC clang
    set -gx CXX clang++
    set -gx GOPATH "$HOME/.go"
    set -gx NH_FLAKE "$HOME/.config/nixos#nixos"
    set -gx PNPM_HOME "$HOME/.local/share/pnpm"

    if type -q doppler
        doppler secrets download --no-file --format env | sed 's/^export //; s/^/set -gx /; s/=/ /' | source
    end

    fish_add_path \
        "$HOME/.spicetify" \
        "$HOME/.turso" \
        "$HOME/.cargo/bin" \
        "$HOME/bin" \
        "$HOME/.local/bin" \
        /usr/local/bin \
        /usr/bin \
        "$HOME/.adb/platform-tools" \
        "$HOME/.local/share/nvim/mason/bin" \
        "$BUN_INSTALL/bin" \
        "$PNPM_HOME/bin"
    bind escape,escape 'set -l cmd (commandline -c); commandline -r "sudo $cmd"'
end

function rfg --argument-names editor
    set -l RELOAD 'reload:rg --column --color=always --smart-case {q} || true'
    set -l OPENER "if test \$FZF_SELECT_COUNT -eq 0
          $editor {1} +{2}
        else
          $editor +cw -q {+f}
        end"
    fzf --disabled --ansi --multi --style=full \
        --bind "start:$RELOAD" --bind "change:$RELOAD" \
        --bind "enter:become:$OPENER" \
        --bind "ctrl-o:execute:$OPENER" \
        --bind 'alt-a:select-all,alt-d:deselect-all,ctrl-/:toggle-preview' \
        --delimiter : \
        --preview 'bat --style=full --color=always --highlight-line {2} {1}' \
        --preview-window '~4,+{2}+4/3,<80(up)' \
        --query (string join " " $argv[2..])
end

function rfn --wraps='rfg nvim'
    rfg nvim $argv
end

function rfv --wraps='rfg vim'
    rfg vim $argv
end
