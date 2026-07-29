# Print an optspec for argparse to handle cmd's options that are independent of any subcommand.
function __fish_kache_global_optspecs
    string join \n h/help V/version
end

function __fish_kache_needs_command
    # Figure out if the current invocation already has a command.
    set -l cmd (commandline -opc)
    set -e cmd[1]
    argparse -s (__fish_kache_global_optspecs) -- $cmd 2>/dev/null
    or return
    if set -q argv[1]
        # Also print the command, so this can be used to figure out what it is.
        echo $argv[1]
        return 1
    end
    return 0
end

function __fish_kache_using_subcommand
    set -l cmd (__fish_kache_needs_command)
    test -z "$cmd"
    and return 1
    contains -- $cmd[1] $argv
end

complete -c kache -n "__fish_kache_needs_command" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c kache -n "__fish_kache_needs_command" -s V -l version -d 'Print version'
complete -c kache -n "__fish_kache_needs_command" -f -a "list" -d 'List cache entries, or show details for one crate'
complete -c kache -n "__fish_kache_needs_command" -f -a "gc" -d 'Run garbage collection (LRU eviction)'
complete -c kache -n "__fish_kache_needs_command" -f -a "purge" -d 'Wipe entire cache or entries for a specific crate'
complete -c kache -n "__fish_kache_needs_command" -f -a "clean" -d 'Recursively find and remove target/ directories under the current directory'
complete -c kache -n "__fish_kache_needs_command" -f -a "init" -d 'Interactive setup: configure cargo wrapper, install and start the daemon'
complete -c kache -n "__fish_kache_needs_command" -f -a "doctor" -d 'Diagnose setup issues and verify cache integrity'
complete -c kache -n "__fish_kache_needs_command" -f -a "sync" -d 'Synchronize the local cache with its configured remote (pull + push)'
complete -c kache -n "__fish_kache_needs_command" -f -a "save-manifest" -d 'Save a build manifest for future prefetch warming'
complete -c kache -n "__fish_kache_needs_command" -f -a "daemon" -d 'Daemon management. With no subcommand, shows daemon status'
complete -c kache -n "__fish_kache_needs_command" -f -a "monitor" -d 'Live TUI dashboard for monitoring builds'
complete -c kache -n "__fish_kache_needs_command" -f -a "stats" -d 'Show cache stats summary (non-interactive)'
complete -c kache -n "__fish_kache_needs_command" -f -a "why-miss" -d 'Diagnose why a specific crate missed the cache'
complete -c kache -n "__fish_kache_needs_command" -f -a "report" -d 'Generate a detailed build report (json, trace, markdown, or text)'
complete -c kache -n "__fish_kache_needs_command" -f -a "config" -d 'Open the configuration editor'
complete -c kache -n "__fish_kache_needs_command" -f -a "completions" -d 'Generate shell completion scripts'
complete -c kache -n "__fish_kache_needs_command" -f -a "help" -d 'Print this message or the help of the given subcommand(s)'
complete -c kache -n "__fish_kache_using_subcommand list" -l sort -d 'Sort by: name, size, hits, age' -r
complete -c kache -n "__fish_kache_using_subcommand list" -s h -l help -d 'Print help'
complete -c kache -n "__fish_kache_using_subcommand gc" -l max-age -d 'Evict entries older than this duration (e.g. 7d, 24h)' -r
complete -c kache -n "__fish_kache_using_subcommand gc" -s h -l help -d 'Print help'
complete -c kache -n "__fish_kache_using_subcommand purge" -l crate-name -d 'Only purge entries for this crate' -r
complete -c kache -n "__fish_kache_using_subcommand purge" -s h -l help -d 'Print help'
complete -c kache -n "__fish_kache_using_subcommand clean" -s n -l dry-run -d 'Preview what would be removed without deleting (pairs with --yes)'
complete -c kache -n "__fish_kache_using_subcommand clean" -s y -l yes -d 'Non-interactive: remove all target/ directories without the selector. For scripts and cron. Preview first with --dry-run'
complete -c kache -n "__fish_kache_using_subcommand clean" -s h -l help -d 'Print help'
complete -c kache -n "__fish_kache_using_subcommand init" -s y -l yes -d 'Accept all default answers (non-interactive)'
complete -c kache -n "__fish_kache_using_subcommand init" -l no-service -d 'Do not install the daemon as a login service'
complete -c kache -n "__fish_kache_using_subcommand init" -l check -d 'Print what would change without modifying anything'
complete -c kache -n "__fish_kache_using_subcommand init" -s h -l help -d 'Print help'
complete -c kache -n "__fish_kache_using_subcommand doctor" -l fix -d 'Auto-fix issues (migrate from sccache, repair config)'
complete -c kache -n "__fish_kache_using_subcommand doctor" -l purge-sccache -d 'Also remove sccache cache and binary (requires --fix)'
complete -c kache -n "__fish_kache_using_subcommand doctor" -l verify -d 'Verify cache integrity (entries, blobs, metadata)'
complete -c kache -n "__fish_kache_using_subcommand doctor" -l checksums -d 'Also verify blob checksums (slower, implies --verify)'
complete -c kache -n "__fish_kache_using_subcommand doctor" -l repair -d 'Remove corrupted entries (implies --verify)'
complete -c kache -n "__fish_kache_using_subcommand doctor" -s h -l help -d 'Print help'
complete -c kache -n "__fish_kache_using_subcommand sync" -l manifest-path -d 'Path to Cargo.toml (default: current directory)' -r
complete -c kache -n "__fish_kache_using_subcommand sync" -l pull -d 'Only download from the remote (skip uploads)'
complete -c kache -n "__fish_kache_using_subcommand sync" -l push -d 'Only upload to the remote (skip downloads)'
complete -c kache -n "__fish_kache_using_subcommand sync" -l dry-run -d 'Show what would be synced without transferring'
complete -c kache -n "__fish_kache_using_subcommand sync" -l all -d 'Pull all remote artifacts (ignore workspace filtering)'
complete -c kache -n "__fish_kache_using_subcommand sync" -l workspace -d 'Scope the pull listing to workspace members (one LIST per member) instead of one LIST per Cargo.lock dependency crate'
complete -c kache -n "__fish_kache_using_subcommand sync" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c kache -n "__fish_kache_using_subcommand save-manifest" -l manifest-key -d 'Override manifest key (default: host target triple)' -r
complete -c kache -n "__fish_kache_using_subcommand save-manifest" -l namespace -d 'Shard namespace: target/rustc_hash/profile. If set and Cargo.lock exists, uploads content-addressed shards alongside the monolithic build manifest' -r
complete -c kache -n "__fish_kache_using_subcommand save-manifest" -s h -l help -d 'Print help'
complete -c kache -n "__fish_kache_using_subcommand daemon; and not __fish_seen_subcommand_from status run start stop restart install uninstall log help" -s h -l help -d 'Print help'
complete -c kache -n "__fish_kache_using_subcommand daemon; and not __fish_seen_subcommand_from status run start stop restart install uninstall log help" -f -a "status" -d 'Show daemon status (alias for bare `kache daemon`)'
complete -c kache -n "__fish_kache_using_subcommand daemon; and not __fish_seen_subcommand_from status run start stop restart install uninstall log help" -f -a "run" -d 'Run the daemon server in the foreground'
complete -c kache -n "__fish_kache_using_subcommand daemon; and not __fish_seen_subcommand_from status run start stop restart install uninstall log help" -f -a "start" -d 'Start daemon in background (returns immediately)'
complete -c kache -n "__fish_kache_using_subcommand daemon; and not __fish_seen_subcommand_from status run start stop restart install uninstall log help" -f -a "stop" -d 'Stop a running daemon'
complete -c kache -n "__fish_kache_using_subcommand daemon; and not __fish_seen_subcommand_from status run start stop restart install uninstall log help" -f -a "restart" -d 'Restart daemon (via launchd/systemd if installed, else manual stop+start)'
complete -c kache -n "__fish_kache_using_subcommand daemon; and not __fish_seen_subcommand_from status run start stop restart install uninstall log help" -f -a "install" -d 'Install daemon as a system service (launchd/systemd)'
complete -c kache -n "__fish_kache_using_subcommand daemon; and not __fish_seen_subcommand_from status run start stop restart install uninstall log help" -f -a "uninstall" -d 'Remove the daemon service'
complete -c kache -n "__fish_kache_using_subcommand daemon; and not __fish_seen_subcommand_from status run start stop restart install uninstall log help" -f -a "log" -d 'Stream daemon logs'
complete -c kache -n "__fish_kache_using_subcommand daemon; and not __fish_seen_subcommand_from status run start stop restart install uninstall log help" -f -a "help" -d 'Print this message or the help of the given subcommand(s)'
complete -c kache -n "__fish_kache_using_subcommand daemon; and __fish_seen_subcommand_from status" -s h -l help -d 'Print help'
complete -c kache -n "__fish_kache_using_subcommand daemon; and __fish_seen_subcommand_from run" -s h -l help -d 'Print help'
complete -c kache -n "__fish_kache_using_subcommand daemon; and __fish_seen_subcommand_from start" -s h -l help -d 'Print help'
complete -c kache -n "__fish_kache_using_subcommand daemon; and __fish_seen_subcommand_from stop" -s h -l help -d 'Print help'
complete -c kache -n "__fish_kache_using_subcommand daemon; and __fish_seen_subcommand_from restart" -s h -l help -d 'Print help'
complete -c kache -n "__fish_kache_using_subcommand daemon; and __fish_seen_subcommand_from install" -s h -l help -d 'Print help'
complete -c kache -n "__fish_kache_using_subcommand daemon; and __fish_seen_subcommand_from uninstall" -s h -l help -d 'Print help'
complete -c kache -n "__fish_kache_using_subcommand daemon; and __fish_seen_subcommand_from log" -s h -l help -d 'Print help'
complete -c kache -n "__fish_kache_using_subcommand daemon; and __fish_seen_subcommand_from help" -f -a "status" -d 'Show daemon status (alias for bare `kache daemon`)'
complete -c kache -n "__fish_kache_using_subcommand daemon; and __fish_seen_subcommand_from help" -f -a "run" -d 'Run the daemon server in the foreground'
complete -c kache -n "__fish_kache_using_subcommand daemon; and __fish_seen_subcommand_from help" -f -a "start" -d 'Start daemon in background (returns immediately)'
complete -c kache -n "__fish_kache_using_subcommand daemon; and __fish_seen_subcommand_from help" -f -a "stop" -d 'Stop a running daemon'
complete -c kache -n "__fish_kache_using_subcommand daemon; and __fish_seen_subcommand_from help" -f -a "restart" -d 'Restart daemon (via launchd/systemd if installed, else manual stop+start)'
complete -c kache -n "__fish_kache_using_subcommand daemon; and __fish_seen_subcommand_from help" -f -a "install" -d 'Install daemon as a system service (launchd/systemd)'
complete -c kache -n "__fish_kache_using_subcommand daemon; and __fish_seen_subcommand_from help" -f -a "uninstall" -d 'Remove the daemon service'
complete -c kache -n "__fish_kache_using_subcommand daemon; and __fish_seen_subcommand_from help" -f -a "log" -d 'Stream daemon logs'
complete -c kache -n "__fish_kache_using_subcommand daemon; and __fish_seen_subcommand_from help" -f -a "help" -d 'Print this message or the help of the given subcommand(s)'
complete -c kache -n "__fish_kache_using_subcommand monitor" -l since -d 'Show events from the last N hours' -r
complete -c kache -n "__fish_kache_using_subcommand monitor" -s h -l help -d 'Print help'
complete -c kache -n "__fish_kache_using_subcommand stats" -l since -d 'Show events from the last N hours (e.g. 24h, 1h, 7d)' -r
complete -c kache -n "__fish_kache_using_subcommand stats" -s h -l help -d 'Print help'
complete -c kache -n "__fish_kache_using_subcommand why-miss" -s h -l help -d 'Print help'
complete -c kache -n "__fish_kache_using_subcommand report" -l format -d 'Output format: json, trace, perfetto, chrome-trace, markdown, github, text' -r
complete -c kache -n "__fish_kache_using_subcommand report" -l since -d 'Time window (e.g. 24h, 7d, 1h)' -r
complete -c kache -n "__fish_kache_using_subcommand report" -l root -d 'Only include compiler events from this build tree/root' -r -F
complete -c kache -n "__fish_kache_using_subcommand report" -s o -l output -d 'Write output to a file instead of stdout' -r -F
complete -c kache -n "__fish_kache_using_subcommand report" -l top -d 'Number of top entries to show' -r
complete -c kache -n "__fish_kache_using_subcommand report" -s h -l help -d 'Print help'
complete -c kache -n "__fish_kache_using_subcommand config" -s h -l help -d 'Print help'
complete -c kache -n "__fish_kache_using_subcommand completions" -s h -l help -d 'Print help'
complete -c kache -n "__fish_kache_using_subcommand help; and not __fish_seen_subcommand_from list gc purge clean init doctor sync save-manifest daemon monitor stats why-miss report config completions help" -f -a "list" -d 'List cache entries, or show details for one crate'
complete -c kache -n "__fish_kache_using_subcommand help; and not __fish_seen_subcommand_from list gc purge clean init doctor sync save-manifest daemon monitor stats why-miss report config completions help" -f -a "gc" -d 'Run garbage collection (LRU eviction)'
complete -c kache -n "__fish_kache_using_subcommand help; and not __fish_seen_subcommand_from list gc purge clean init doctor sync save-manifest daemon monitor stats why-miss report config completions help" -f -a "purge" -d 'Wipe entire cache or entries for a specific crate'
complete -c kache -n "__fish_kache_using_subcommand help; and not __fish_seen_subcommand_from list gc purge clean init doctor sync save-manifest daemon monitor stats why-miss report config completions help" -f -a "clean" -d 'Recursively find and remove target/ directories under the current directory'
complete -c kache -n "__fish_kache_using_subcommand help; and not __fish_seen_subcommand_from list gc purge clean init doctor sync save-manifest daemon monitor stats why-miss report config completions help" -f -a "init" -d 'Interactive setup: configure cargo wrapper, install and start the daemon'
complete -c kache -n "__fish_kache_using_subcommand help; and not __fish_seen_subcommand_from list gc purge clean init doctor sync save-manifest daemon monitor stats why-miss report config completions help" -f -a "doctor" -d 'Diagnose setup issues and verify cache integrity'
complete -c kache -n "__fish_kache_using_subcommand help; and not __fish_seen_subcommand_from list gc purge clean init doctor sync save-manifest daemon monitor stats why-miss report config completions help" -f -a "sync" -d 'Synchronize the local cache with its configured remote (pull + push)'
complete -c kache -n "__fish_kache_using_subcommand help; and not __fish_seen_subcommand_from list gc purge clean init doctor sync save-manifest daemon monitor stats why-miss report config completions help" -f -a "save-manifest" -d 'Save a build manifest for future prefetch warming'
complete -c kache -n "__fish_kache_using_subcommand help; and not __fish_seen_subcommand_from list gc purge clean init doctor sync save-manifest daemon monitor stats why-miss report config completions help" -f -a "daemon" -d 'Daemon management. With no subcommand, shows daemon status'
complete -c kache -n "__fish_kache_using_subcommand help; and not __fish_seen_subcommand_from list gc purge clean init doctor sync save-manifest daemon monitor stats why-miss report config completions help" -f -a "monitor" -d 'Live TUI dashboard for monitoring builds'
complete -c kache -n "__fish_kache_using_subcommand help; and not __fish_seen_subcommand_from list gc purge clean init doctor sync save-manifest daemon monitor stats why-miss report config completions help" -f -a "stats" -d 'Show cache stats summary (non-interactive)'
complete -c kache -n "__fish_kache_using_subcommand help; and not __fish_seen_subcommand_from list gc purge clean init doctor sync save-manifest daemon monitor stats why-miss report config completions help" -f -a "why-miss" -d 'Diagnose why a specific crate missed the cache'
complete -c kache -n "__fish_kache_using_subcommand help; and not __fish_seen_subcommand_from list gc purge clean init doctor sync save-manifest daemon monitor stats why-miss report config completions help" -f -a "report" -d 'Generate a detailed build report (json, trace, markdown, or text)'
complete -c kache -n "__fish_kache_using_subcommand help; and not __fish_seen_subcommand_from list gc purge clean init doctor sync save-manifest daemon monitor stats why-miss report config completions help" -f -a "config" -d 'Open the configuration editor'
complete -c kache -n "__fish_kache_using_subcommand help; and not __fish_seen_subcommand_from list gc purge clean init doctor sync save-manifest daemon monitor stats why-miss report config completions help" -f -a "completions" -d 'Generate shell completion scripts'
complete -c kache -n "__fish_kache_using_subcommand help; and not __fish_seen_subcommand_from list gc purge clean init doctor sync save-manifest daemon monitor stats why-miss report config completions help" -f -a "help" -d 'Print this message or the help of the given subcommand(s)'
complete -c kache -n "__fish_kache_using_subcommand help; and __fish_seen_subcommand_from daemon" -f -a "status" -d 'Show daemon status (alias for bare `kache daemon`)'
complete -c kache -n "__fish_kache_using_subcommand help; and __fish_seen_subcommand_from daemon" -f -a "run" -d 'Run the daemon server in the foreground'
complete -c kache -n "__fish_kache_using_subcommand help; and __fish_seen_subcommand_from daemon" -f -a "start" -d 'Start daemon in background (returns immediately)'
complete -c kache -n "__fish_kache_using_subcommand help; and __fish_seen_subcommand_from daemon" -f -a "stop" -d 'Stop a running daemon'
complete -c kache -n "__fish_kache_using_subcommand help; and __fish_seen_subcommand_from daemon" -f -a "restart" -d 'Restart daemon (via launchd/systemd if installed, else manual stop+start)'
complete -c kache -n "__fish_kache_using_subcommand help; and __fish_seen_subcommand_from daemon" -f -a "install" -d 'Install daemon as a system service (launchd/systemd)'
complete -c kache -n "__fish_kache_using_subcommand help; and __fish_seen_subcommand_from daemon" -f -a "uninstall" -d 'Remove the daemon service'
complete -c kache -n "__fish_kache_using_subcommand help; and __fish_seen_subcommand_from daemon" -f -a "log" -d 'Stream daemon logs'
