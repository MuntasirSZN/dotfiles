# Add deno completions to search path
if [[ ":$FPATH:" != *":/home/muntasir/.zsh/completions:"* ]]; then export FPATH="/home/muntasir/.zsh/completions:$FPATH"; fi
#
#.zshrc
#

export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH

autoload -Uz compinit
compinit

export MANPATH="/usr/local/man:$MANPATH"

if [[ -n $SSH_CONNECTION ]]; then
   export EDITOR='nano'
 else
   export EDITOR='nvim'
 fi

eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

export PATH="$PATH:/home/muntasir/.cargo/bin"

# System Info On Terminal Open
fastfetch

# Prompt
eval "$(starship init zsh)"
timeout 2s getquotes --offline

# pnpm
export PNPM_HOME="/home/muntasir/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

export beef="cd ~/beef && beef"

# Check if the session is X11 or Wayland
session_type=$(w -h | awk '{print $2}')

# If the session is X11, perform the desired action
if [[ "$session_type" == "X11" ]]; then
    alias pbcopy="xsel --input --clipboard"
    alias pbpaste="xsel --output --clipboard"
else
    alias pbcopy="wl-copy"
    alias pbpaste="wl-paste"
fi

export PATH="/home/muntasir/go/bin:$PATH"

# ZSh syntax highlighting
source ~/.zsh/catppuccin_mocha-zsh-syntax-highlighting.zsh

export PATH="/home/muntasir/.config/composer/vendor/bin:$PATH"
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
# Download Zinit, if it's not there yet
if [ ! -d "$ZINIT_HOME" ]; then
   mkdir -p "$(dirname $ZINIT_HOME)"
   git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

source "${ZINIT_HOME}/zinit.zsh"
zinit light ohmyzsh/ohmyzsh
zinit snippet OMZP::git
zinit snippet OMZP::sudo
zinit snippet OMZP::aws
zinit snippet OMZP::kubectl
zinit snippet OMZP::kubectx
zinit snippet OMZP::rust
zinit snippet OMZP::command-not-found

zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit light zsh-users/zsh-syntax-highlighting
zinit light zdharma-continuum/fast-syntax-highlighting
zinit light marlonrichert/zsh-autocomplete
zinit light loiccoyle/zsh-github-copilot
zinit light olets/zsh-abbr

abbr erase 1 > /dev/null 2>&1

export ABBR_GET_AVAILABLE_ABBREVIATION=1
export ABBR_LOG_AVAILABLE_ABBREVIATION=1

bindkey              '^I'         menu-complete
bindkey "$terminfo[kcbt]" reverse-menu-complete

bindkey              '^I' menu-select
bindkey "$terminfo[kcbt]" menu-select

bindkey -M menuselect              '^I'         menu-complete
bindkey -M menuselect "$terminfo[kcbt]" reverse-menu-complete

bindkey '^[|' zsh_gh_copilot_explain
bindkey '^[\' zsh_gh_copilot_suggest

export EDITOR='nvim'

export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"

export PATH="/home/linuxbrew/.linuxbrew/bin:$PATH"

#Fzf
source <(fzf --zsh)
export FZF_DEFAULT_OPTS=" \
--color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8 \
--color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc \
--color=marker:#b4befe,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8 \
--color=selected-bg:#45475a \
--multi"
export FZF_CTRL_T_OPTS="
  --walker-skip .git,node_modules,target
  --style=full
  --preview 'fzf-preview.sh {}'
  --bind 'ctrl-/:change-preview-window(down|hidden|)'"

export FZF_CTRL_R_OPTS="--style=full"

# History
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

# Eza
export EZA_ICONS_AUTO=1
alias ls="eza"

eval $(thefuck --alias)

# Node Version Manager
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

alias man="batman"
alias -g -- -h='-h 2>&1 | bat --language=help --style=plain'
alias -g -- --help='--help 2>&1 | bat --language=help --style=plain'

# Zoxide
eval "$(zoxide init --cmd cd zsh)"

# bun completions
[ -s "/home/muntasir/.bun/_bun" ] && source "/home/muntasir/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
. "/home/muntasir/.deno/env"

alias cat="bat"

# tabtab source for packages
# uninstall by removing these lines
[[ -f ~/.config/tabtab/__tabtab.zsh ]] && . ~/.config/tabtab/__tabtab.zsh || true

rm -rf /tmp/hypr
ln -s $XDG_RUNTIME_DIR/hypr /tmp/hypr

export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XCURSOR_THEME="Bibata-Modern-Ice"
export CM_LAUNCHER="rofi"

# Turso
export PATH="$PATH:/home/muntasir/.turso"

current_cursor_theme=$(dconf read /org/gnome/desktop/interface/cursor-theme)

if [[ "$current_cursor_theme" != "'Bibata-Modern-Ice'" ]]; then
  dconf write /org/gnome/desktop/interface/cursor-theme "'Bibata-Modern-Ice'"
fi

alias clock="tty-clock -tcBrsSC 6"

export PATH=$PATH:/home/muntasir/.spicetify

# Set xdg-open as open command
alias open=xdg-open

eval "$(atuin init zsh --disable-ctrl-r)"

eval "$(direnv hook zsh)"

alias ai-enable='source ~/.local/bin/ai-enable'
alias aur-enable='source ~/.local/bin/aur-enable'
alias pop-enable='source ~/.local/bin/pop-enable'

alias ltree="eza --tree --level=2  --icons --git"
eval "$(gh copilot alias -- zsh)"

export GLAMOUR_STYLE="/home/muntasir/.config/glow/catppucin-mocha.json"

# ripgrep->fzf->vim [QUERY]
rfv() (
  RELOAD='reload:rg --column --color=always --smart-case {q} || :'
  OPENER='if [[ $FZF_SELECT_COUNT -eq 0 ]]; then
            vim {1} +{2}     # No selection. Open the current line in Vim.
          else
            vim +cw -q {+f}  # Build quickfix list for the selected items.
          fi'
  fzf --disabled --ansi --multi --style=full \
      --bind "start:$RELOAD" --bind "change:$RELOAD" \
      --bind "enter:become:$OPENER" \
      --bind "ctrl-o:execute:$OPENER" \
      --bind 'alt-a:select-all,alt-d:deselect-all,ctrl-/:toggle-preview' \
      --delimiter : \
      --preview 'bat --style=full --color=always --highlight-line {2} {1}' \
      --preview-window '~4,+{2}+4/3,<80(up)' \
      --query "$*"
)
