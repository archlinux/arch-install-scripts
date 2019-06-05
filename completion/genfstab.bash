_genfstab() {
    compopt -o dirnames
    local cur prev words cword
    _init_completion || return

    local opts="-f -L -p -P -t -U -h"

    case ${prev} in
        -f)
            return 0
            ;;
        -t)
            COMPREPLY=($(compgen -W "LABEL UUID PARTLABEL PARTUUID" -- "${cur}"))
            return 0
            ;;
    esac

    if [[ ${cur} = -* ]]; then
        COMPREPLY=($(compgen -W "${opts}" -- "${cur}"))
        return 0
    fi

    for i in "${COMP_WORDS[@]:1:COMP_CWORD-1}"; do
        if [[ -d ${i} ]]; then
            compopt +o dirnames
            return 0
        fi
    done
}

complete -F _genfstab genfstab
