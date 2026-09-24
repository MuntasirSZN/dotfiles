# Print an optspec for argparse to handle cmd's options that are independent of any subcommand.
function __fish_ein_global_optspecs
    string join \n q/quiet progress t/threads= progress-keep-open h/help V/version
end

function __fish_ein_needs_command
    # Figure out if the current invocation already has a command.
    set -l cmd (commandline -opc)
    set -e cmd[1]
    argparse -s (__fish_ein_global_optspecs) -- $cmd 2>/dev/null
    or return
    if set -q argv[1]
        # Also print the command, so this can be used to figure out what it is.
        echo $argv[1]
        return 1
    end
    return 0
end

function __fish_ein_using_subcommand
    set -l cmd (__fish_ein_needs_command)
    test -z "$cmd"
    and return 1
    contains -- $cmd[1] $argv
end

complete -c ein -n "__fish_ein_needs_command" -s t -l threads -d 'The number of threads to use. If unset or 0, use the command default; repository discovery uses 8 on macOS' -r
complete -c ein -n "__fish_ein_needs_command" -s q -l quiet -d 'Do not display verbose messages and progress information'
complete -c ein -n "__fish_ein_needs_command" -l progress -d 'Bring up a terminal user interface displaying progress visually'
complete -c ein -n "__fish_ein_needs_command" -l progress-keep-open -d 'The progress TUI will stay up even though the work is already completed'
complete -c ein -n "__fish_ein_needs_command" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c ein -n "__fish_ein_needs_command" -s V -l version -d 'Print version'
complete -c ein -n "__fish_ein_needs_command" -f -a "init" -d 'Initialize the repository in the current directory'
complete -c ein -n "__fish_ein_needs_command" -f -a "initialize" -d 'Initialize the repository in the current directory'
complete -c ein -n "__fish_ein_needs_command" -f -a "tool" -d 'A selection of useful tools'
complete -c ein -n "__fish_ein_needs_command" -f -a "t" -d 'A selection of useful tools'
complete -c ein -n "__fish_ein_needs_command" -f -a "completions" -d 'Generate shell completions to stdout or a directory'
complete -c ein -n "__fish_ein_needs_command" -f -a "generate-completions" -d 'Generate shell completions to stdout or a directory'
complete -c ein -n "__fish_ein_needs_command" -f -a "shell-completions" -d 'Generate shell completions to stdout or a directory'
complete -c ein -n "__fish_ein_needs_command" -f -a "help" -d 'Print this message or the help of the given subcommand(s)'
complete -c ein -n "__fish_ein_using_subcommand init" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c ein -n "__fish_ein_using_subcommand initialize" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c ein -n "__fish_ein_using_subcommand tool; and not __fish_seen_subcommand_from find organize estimate-hours h hours help" -s h -l help -d 'Print help'
complete -c ein -n "__fish_ein_using_subcommand tool; and not __fish_seen_subcommand_from find organize estimate-hours h hours help" -f -a "find" -d 'Find all repositories in a given directory'
complete -c ein -n "__fish_ein_using_subcommand tool; and not __fish_seen_subcommand_from find organize estimate-hours h hours help" -f -a "organize" -d 'Move all repositories found in a directory into a structure matching their clone URLs'
complete -c ein -n "__fish_ein_using_subcommand tool; and not __fish_seen_subcommand_from find organize estimate-hours h hours help" -f -a "estimate-hours" -d 'Estimate hours worked based on a commit history'
complete -c ein -n "__fish_ein_using_subcommand tool; and not __fish_seen_subcommand_from find organize estimate-hours h hours help" -f -a "h" -d 'Estimate hours worked based on a commit history'
complete -c ein -n "__fish_ein_using_subcommand tool; and not __fish_seen_subcommand_from find organize estimate-hours h hours help" -f -a "hours" -d 'Estimate hours worked based on a commit history'
complete -c ein -n "__fish_ein_using_subcommand tool; and not __fish_seen_subcommand_from find organize estimate-hours h hours help" -f -a "help" -d 'Print this message or the help of the given subcommand(s)'
complete -c ein -n "__fish_ein_using_subcommand tool; and __fish_seen_subcommand_from find" -s d -l debug -d 'If set, print additional information to help understand why the traversal is slow'
complete -c ein -n "__fish_ein_using_subcommand tool; and __fish_seen_subcommand_from find" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c ein -n "__fish_ein_using_subcommand tool; and __fish_seen_subcommand_from organize" -s f -l repository-source -d 'The directory to use when finding input repositories to move into position' -r -F
complete -c ein -n "__fish_ein_using_subcommand tool; and __fish_seen_subcommand_from organize" -s t -l destination-directory -d 'The directory to which to move repositories found in the repository-source' -r -F
complete -c ein -n "__fish_ein_using_subcommand tool; and __fish_seen_subcommand_from organize" -l execute -d 'The operation will be in dry-run mode unless this flag is set'
complete -c ein -n "__fish_ein_using_subcommand tool; and __fish_seen_subcommand_from organize" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c ein -n "__fish_ein_using_subcommand tool; and __fish_seen_subcommand_from estimate-hours" -s b -l no-bots -d 'Ignore github bots which match the `[bot]` search string'
complete -c ein -n "__fish_ein_using_subcommand tool; and __fish_seen_subcommand_from estimate-hours" -s f -l file-stats -d 'Collect additional information about file modifications, additions and deletions (without rename tracking)'
complete -c ein -n "__fish_ein_using_subcommand tool; and __fish_seen_subcommand_from estimate-hours" -s l -l line-stats -d 'Collect additional information about lines added and deleted (without rename tracking)'
complete -c ein -n "__fish_ein_using_subcommand tool; and __fish_seen_subcommand_from estimate-hours" -s p -l show-pii -d 'Show personally identifiable information before the summary. Includes names and email addresses'
complete -c ein -n "__fish_ein_using_subcommand tool; and __fish_seen_subcommand_from estimate-hours" -s i -l omit-unify-identities -d 'Omit unifying identities by name and email which can lead to the same author appear multiple times due to using different names or email addresses'
complete -c ein -n "__fish_ein_using_subcommand tool; and __fish_seen_subcommand_from estimate-hours" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c ein -n "__fish_ein_using_subcommand tool; and __fish_seen_subcommand_from h" -s b -l no-bots -d 'Ignore github bots which match the `[bot]` search string'
complete -c ein -n "__fish_ein_using_subcommand tool; and __fish_seen_subcommand_from h" -s f -l file-stats -d 'Collect additional information about file modifications, additions and deletions (without rename tracking)'
complete -c ein -n "__fish_ein_using_subcommand tool; and __fish_seen_subcommand_from h" -s l -l line-stats -d 'Collect additional information about lines added and deleted (without rename tracking)'
complete -c ein -n "__fish_ein_using_subcommand tool; and __fish_seen_subcommand_from h" -s p -l show-pii -d 'Show personally identifiable information before the summary. Includes names and email addresses'
complete -c ein -n "__fish_ein_using_subcommand tool; and __fish_seen_subcommand_from h" -s i -l omit-unify-identities -d 'Omit unifying identities by name and email which can lead to the same author appear multiple times due to using different names or email addresses'
complete -c ein -n "__fish_ein_using_subcommand tool; and __fish_seen_subcommand_from h" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c ein -n "__fish_ein_using_subcommand tool; and __fish_seen_subcommand_from hours" -s b -l no-bots -d 'Ignore github bots which match the `[bot]` search string'
complete -c ein -n "__fish_ein_using_subcommand tool; and __fish_seen_subcommand_from hours" -s f -l file-stats -d 'Collect additional information about file modifications, additions and deletions (without rename tracking)'
complete -c ein -n "__fish_ein_using_subcommand tool; and __fish_seen_subcommand_from hours" -s l -l line-stats -d 'Collect additional information about lines added and deleted (without rename tracking)'
complete -c ein -n "__fish_ein_using_subcommand tool; and __fish_seen_subcommand_from hours" -s p -l show-pii -d 'Show personally identifiable information before the summary. Includes names and email addresses'
complete -c ein -n "__fish_ein_using_subcommand tool; and __fish_seen_subcommand_from hours" -s i -l omit-unify-identities -d 'Omit unifying identities by name and email which can lead to the same author appear multiple times due to using different names or email addresses'
complete -c ein -n "__fish_ein_using_subcommand tool; and __fish_seen_subcommand_from hours" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c ein -n "__fish_ein_using_subcommand tool; and __fish_seen_subcommand_from help" -f -a "find" -d 'Find all repositories in a given directory'
complete -c ein -n "__fish_ein_using_subcommand tool; and __fish_seen_subcommand_from help" -f -a "organize" -d 'Move all repositories found in a directory into a structure matching their clone URLs'
complete -c ein -n "__fish_ein_using_subcommand tool; and __fish_seen_subcommand_from help" -f -a "estimate-hours" -d 'Estimate hours worked based on a commit history'
complete -c ein -n "__fish_ein_using_subcommand tool; and __fish_seen_subcommand_from help" -f -a "help" -d 'Print this message or the help of the given subcommand(s)'
complete -c ein -n "__fish_ein_using_subcommand t; and not __fish_seen_subcommand_from find organize estimate-hours h hours help" -s h -l help -d 'Print help'
complete -c ein -n "__fish_ein_using_subcommand t; and not __fish_seen_subcommand_from find organize estimate-hours h hours help" -f -a "find" -d 'Find all repositories in a given directory'
complete -c ein -n "__fish_ein_using_subcommand t; and not __fish_seen_subcommand_from find organize estimate-hours h hours help" -f -a "organize" -d 'Move all repositories found in a directory into a structure matching their clone URLs'
complete -c ein -n "__fish_ein_using_subcommand t; and not __fish_seen_subcommand_from find organize estimate-hours h hours help" -f -a "estimate-hours" -d 'Estimate hours worked based on a commit history'
complete -c ein -n "__fish_ein_using_subcommand t; and not __fish_seen_subcommand_from find organize estimate-hours h hours help" -f -a "h" -d 'Estimate hours worked based on a commit history'
complete -c ein -n "__fish_ein_using_subcommand t; and not __fish_seen_subcommand_from find organize estimate-hours h hours help" -f -a "hours" -d 'Estimate hours worked based on a commit history'
complete -c ein -n "__fish_ein_using_subcommand t; and not __fish_seen_subcommand_from find organize estimate-hours h hours help" -f -a "help" -d 'Print this message or the help of the given subcommand(s)'
complete -c ein -n "__fish_ein_using_subcommand t; and __fish_seen_subcommand_from find" -s d -l debug -d 'If set, print additional information to help understand why the traversal is slow'
complete -c ein -n "__fish_ein_using_subcommand t; and __fish_seen_subcommand_from find" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c ein -n "__fish_ein_using_subcommand t; and __fish_seen_subcommand_from organize" -s f -l repository-source -d 'The directory to use when finding input repositories to move into position' -r -F
complete -c ein -n "__fish_ein_using_subcommand t; and __fish_seen_subcommand_from organize" -s t -l destination-directory -d 'The directory to which to move repositories found in the repository-source' -r -F
complete -c ein -n "__fish_ein_using_subcommand t; and __fish_seen_subcommand_from organize" -l execute -d 'The operation will be in dry-run mode unless this flag is set'
complete -c ein -n "__fish_ein_using_subcommand t; and __fish_seen_subcommand_from organize" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c ein -n "__fish_ein_using_subcommand t; and __fish_seen_subcommand_from estimate-hours" -s b -l no-bots -d 'Ignore github bots which match the `[bot]` search string'
complete -c ein -n "__fish_ein_using_subcommand t; and __fish_seen_subcommand_from estimate-hours" -s f -l file-stats -d 'Collect additional information about file modifications, additions and deletions (without rename tracking)'
complete -c ein -n "__fish_ein_using_subcommand t; and __fish_seen_subcommand_from estimate-hours" -s l -l line-stats -d 'Collect additional information about lines added and deleted (without rename tracking)'
complete -c ein -n "__fish_ein_using_subcommand t; and __fish_seen_subcommand_from estimate-hours" -s p -l show-pii -d 'Show personally identifiable information before the summary. Includes names and email addresses'
complete -c ein -n "__fish_ein_using_subcommand t; and __fish_seen_subcommand_from estimate-hours" -s i -l omit-unify-identities -d 'Omit unifying identities by name and email which can lead to the same author appear multiple times due to using different names or email addresses'
complete -c ein -n "__fish_ein_using_subcommand t; and __fish_seen_subcommand_from estimate-hours" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c ein -n "__fish_ein_using_subcommand t; and __fish_seen_subcommand_from h" -s b -l no-bots -d 'Ignore github bots which match the `[bot]` search string'
complete -c ein -n "__fish_ein_using_subcommand t; and __fish_seen_subcommand_from h" -s f -l file-stats -d 'Collect additional information about file modifications, additions and deletions (without rename tracking)'
complete -c ein -n "__fish_ein_using_subcommand t; and __fish_seen_subcommand_from h" -s l -l line-stats -d 'Collect additional information about lines added and deleted (without rename tracking)'
complete -c ein -n "__fish_ein_using_subcommand t; and __fish_seen_subcommand_from h" -s p -l show-pii -d 'Show personally identifiable information before the summary. Includes names and email addresses'
complete -c ein -n "__fish_ein_using_subcommand t; and __fish_seen_subcommand_from h" -s i -l omit-unify-identities -d 'Omit unifying identities by name and email which can lead to the same author appear multiple times due to using different names or email addresses'
complete -c ein -n "__fish_ein_using_subcommand t; and __fish_seen_subcommand_from h" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c ein -n "__fish_ein_using_subcommand t; and __fish_seen_subcommand_from hours" -s b -l no-bots -d 'Ignore github bots which match the `[bot]` search string'
complete -c ein -n "__fish_ein_using_subcommand t; and __fish_seen_subcommand_from hours" -s f -l file-stats -d 'Collect additional information about file modifications, additions and deletions (without rename tracking)'
complete -c ein -n "__fish_ein_using_subcommand t; and __fish_seen_subcommand_from hours" -s l -l line-stats -d 'Collect additional information about lines added and deleted (without rename tracking)'
complete -c ein -n "__fish_ein_using_subcommand t; and __fish_seen_subcommand_from hours" -s p -l show-pii -d 'Show personally identifiable information before the summary. Includes names and email addresses'
complete -c ein -n "__fish_ein_using_subcommand t; and __fish_seen_subcommand_from hours" -s i -l omit-unify-identities -d 'Omit unifying identities by name and email which can lead to the same author appear multiple times due to using different names or email addresses'
complete -c ein -n "__fish_ein_using_subcommand t; and __fish_seen_subcommand_from hours" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c ein -n "__fish_ein_using_subcommand t; and __fish_seen_subcommand_from help" -f -a "find" -d 'Find all repositories in a given directory'
complete -c ein -n "__fish_ein_using_subcommand t; and __fish_seen_subcommand_from help" -f -a "organize" -d 'Move all repositories found in a directory into a structure matching their clone URLs'
complete -c ein -n "__fish_ein_using_subcommand t; and __fish_seen_subcommand_from help" -f -a "estimate-hours" -d 'Estimate hours worked based on a commit history'
complete -c ein -n "__fish_ein_using_subcommand t; and __fish_seen_subcommand_from help" -f -a "help" -d 'Print this message or the help of the given subcommand(s)'
complete -c ein -n "__fish_ein_using_subcommand completions" -s s -l shell -d 'The shell to generate completions for. Otherwise it\'s derived from the environment' -r -f -a "bash\t''
elvish\t''
fish\t''
powershell\t''
zsh\t''"
complete -c ein -n "__fish_ein_using_subcommand completions" -s h -l help -d 'Print help'
complete -c ein -n "__fish_ein_using_subcommand generate-completions" -s s -l shell -d 'The shell to generate completions for. Otherwise it\'s derived from the environment' -r -f -a "bash\t''
elvish\t''
fish\t''
powershell\t''
zsh\t''"
complete -c ein -n "__fish_ein_using_subcommand generate-completions" -s h -l help -d 'Print help'
complete -c ein -n "__fish_ein_using_subcommand shell-completions" -s s -l shell -d 'The shell to generate completions for. Otherwise it\'s derived from the environment' -r -f -a "bash\t''
elvish\t''
fish\t''
powershell\t''
zsh\t''"
complete -c ein -n "__fish_ein_using_subcommand shell-completions" -s h -l help -d 'Print help'
complete -c ein -n "__fish_ein_using_subcommand help; and not __fish_seen_subcommand_from init tool completions help" -f -a "init" -d 'Initialize the repository in the current directory'
complete -c ein -n "__fish_ein_using_subcommand help; and not __fish_seen_subcommand_from init tool completions help" -f -a "tool" -d 'A selection of useful tools'
complete -c ein -n "__fish_ein_using_subcommand help; and not __fish_seen_subcommand_from init tool completions help" -f -a "completions" -d 'Generate shell completions to stdout or a directory'
complete -c ein -n "__fish_ein_using_subcommand help; and not __fish_seen_subcommand_from init tool completions help" -f -a "help" -d 'Print this message or the help of the given subcommand(s)'
complete -c ein -n "__fish_ein_using_subcommand help; and __fish_seen_subcommand_from tool" -f -a "find" -d 'Find all repositories in a given directory'
complete -c ein -n "__fish_ein_using_subcommand help; and __fish_seen_subcommand_from tool" -f -a "organize" -d 'Move all repositories found in a directory into a structure matching their clone URLs'
complete -c ein -n "__fish_ein_using_subcommand help; and __fish_seen_subcommand_from tool" -f -a "estimate-hours" -d 'Estimate hours worked based on a commit history'
