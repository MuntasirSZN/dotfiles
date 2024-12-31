###-begin-netlify-completion-###
if type compdef &>/dev/null; then
  _netlify_completion () {
    local reply
    local si=$IFS

    IFS=$'\n' reply=($(COMP_CWORD="$((CURRENT-1))" COMP_LINE="$BUFFER" COMP_POINT="$CURSOR" /usr/lib/node_modules/netlify-cli/dist/lib/completion/script.js completion -- "${words[@]}"))
    IFS=$si

    _describe 'values' reply
  }
  compdef _netlify_completion netlify
fi
###-end-netlify-completion-###
