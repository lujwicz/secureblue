#!/usr/bin/bash
# Filename needs to be alphabetically later than vte.sh

# Print nonzero exit codes in bold red text inside square brackets at beginning of prompt
if [[ $- == *i* && -n "${BASH_VERSION:-}" ]]; then
    __scbl_ps1_exit_code() {
        # Only print the function name during xtrace for cleaner output
        { local -; set +x; } 2>/dev/null

        if [[ "$1" == 0 ]]; then
            return
        fi

        # https://www.gnu.org/software/bash/manual/html_node/Controlling-the-Prompt.html
        local -r ps1_prefix=(
            '\[\e[31m\]' # red
            "["
            '\[\e[1m\]' # bold
            "$1"
            '\[\e[22m\]' # default intensity
            "]"
            '\[\e[39m\]' # default color
        )

        # @P tells Bash to expand the values as a prompt string
        printf '%s' "${ps1_prefix[@]@P}"
    }

    # In login shells /etc/profile runs this thingy before /etc/bashrc
    # which sets PS1 as '[\u@\h \W]\$ ' only if PS1 is the bash fallback prompt
    # Need to apply it here first
    if [[ "${PS1:-}" == '\s-\v\$ ' ]]; then
        PS1='[\u@\h \W]\$ '
    fi

    # shellcheck disable=SC2154
    PS1='$(__scbl_ps1_exit_code "$?")'"${PS1:-}"
fi
