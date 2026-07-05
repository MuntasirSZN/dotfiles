# fzf-git.sh ported to fish
# Ctrl-G + <key> for git-aware fzf browsing
# Based on junegunn/fzf-git.sh

set -g fzf_git_color 'always'
# If you use eza/bat, keep it; otherwise set to 'auto'
# set -g fzf_git_color 'auto'

function __fzf_git_is_git_repo
    git rev-parse --git-dir >/dev/null 2>&1
end

# Files (Ctrl-G Ctrl-F)
function __fzf_git_files
    __fzf_git_is_git_repo; or return 1
    set -l cmd "git -c color.status=$fzf_git_color status --short --untracked-files=all 2>/dev/null | cut -c4-"
    eval $cmd | fzf --prompt='Files> ' --multi \
        --preview 'git diff --color=always -- {-1} 2>/dev/null; git show --color=always -- {-1} 2>/dev/null' | \
    string split0 | while read -l f
        commandline -i -- (string escape -- $f)
    end
end

# Branches (Ctrl-G Ctrl-B)
function __fzf_git_branches
    __fzf_git_is_git_repo; or return 1
    git branch -a --color=$fzf_git_color --sort=-committerdate | \
        fzf --prompt='Branches> ' --multi \
            --header-first --header 'ENTER: checkout / ALT-C: checkout new branch' \
            --preview 'git log --oneline --graph --date=short --color=always -20 {1}' \
            --bind 'alt-c:execute(git checkout -b (echo {} | head -1 | string trim))' | \
        head -1 | string trim | read -l branch
    if test -n "$branch"
        git checkout (string replace -r '^[* ]*' '' -- $branch)
    end
    commandline -f repaint
end

# Log (Ctrl-G Ctrl-L)
function __fzf_git_log
    __fzf_git_is_git_repo; or return 1
    git log --date=short --format='%C(yellow)%h %C(green)%ad %C(cyan)%an%C(auto)%d %Creset%s' \
        --color=$fzf_git_color | \
        fzf --prompt='Log> ' --multi \
            --preview 'git show --color=always (string split " " $1)[1]' | \
        string split " " | head -1 | read -l sha
    if test -n "$sha"
        commandline -i -- $sha
    end
end

# Status (Ctrl-G Ctrl-S)
function __fzf_git_status
    __fzf_git_is_git_repo; or return 1
    git -c color.status=$fzf_git_color status --short | \
        fzf --prompt='Status> ' --multi \
            --preview 'git diff --color=always -- (string split " " $1)[-1]' | \
        string split " " | tail -1 | read -l f
    if test -n "$f"
        commandline -i -- (string escape -- $f)
    end
end

# Reflog (Ctrl-G Ctrl-R)
function __fzf_git_reflog
    __fzf_git_is_git_repo; or return 1
    git reflog --date=iso --color=$fzf_git_color | \
        fzf --prompt='Reflog> ' --preview 'git show --color=always (string split " " $1)[1]' | \
        string split " " | head -1 | read -l sha
    if test -n "$sha"
        commandline -i -- $sha
    end
end

# Diff (Ctrl-G Ctrl-D)
function __fzf_git_diff
    __fzf_git_is_git_repo; or return 1
    git diff --name-only --relative | \
        fzf --prompt='Diff> ' --multi \
            --preview 'git diff --color=always -- {}' | \
        string split0 | while read -l f
            commandline -i -- (string escape -- $f)
        end
end

# Add (Ctrl-G Ctrl-A)
function __fzf_git_add
    __fzf_git_is_git_repo; or return 1
    set -l files (git -c color.status=$fzf_git_color status --short --untracked-files=all | \
        fzf --prompt='Add> ' --multi \
            --preview 'git diff --color=always -- (string split " " $1)[-1]' | \
        string split " " | tail -1)
    if test -n "$files"
        git add -- $files
        commandline -f repaint
    end
end

# Bindings — only in interactive shell
if status is-interactive
    bind \cg\cf '__fzf_git_files'
    bind \cg\cb '__fzf_git_branches'
    bind \cg\cl '__fzf_git_log'
    bind \cg\cs '__fzf_git_status'
    bind \cg\cr '__fzf_git_reflog'
    bind \cg\cd '__fzf_git_diff'
    bind \cg\ca '__fzf_git_add'
end
