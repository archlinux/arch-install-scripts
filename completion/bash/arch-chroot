_arch_chroot() {
    compopt +o dirnames
    local cur prev opts i
    _init_completion -n : || return
    opts="-N -u -h"

    for i in "${COMP_WORDS[@]:1:COMP_CWORD-1}"; do
        if [[ -d ${i} ]]; then
            return 0
        fi
    done

    if [[ ${prev} = -u ]]; then
        _usergroup -u
        return 0
    fi

    if [[ ${cur} = -* ]]; then
        COMPREPLY=($(compgen -W "${opts}" -- "${cur}"))
        return 0
    fi
    compopt -o dirnames
}

complete -F _arch_chroot arch-chroot
