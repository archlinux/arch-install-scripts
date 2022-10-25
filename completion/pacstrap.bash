if ! declare -F _pacman_pkg > /dev/null; then
    _completion_loader pacman
fi

_pacstrap() {
    compopt +o dirnames +o default
    local cur prev opts
    COMPREPLY=()
    cur="${COMP_WORDS[COMP_CWORD]}"
    prev="${COMP_WORDS[COMP_CWORD-1]}"
    opts="-C -c -D -G -i -K -M -N -P -U -h"

    for i in "${COMP_WORDS[@]:1:COMP_CWORD-1}"; do
        if [[ -d ${i} ]]; then
            _pacman_pkg Slq
            return 0
        fi
    done

    case ${prev} in
        -h)
            return 0
            ;;
        -C)
            compopt -o default
            return 0
            ;;
    esac

    if [[ ${cur} = -* ]]; then
        COMPREPLY=($(compgen -W "${opts}" -- "${cur}"))
        return 0
    fi

    compopt -o dirnames
}

complete -F _pacstrap pacstrap
