function fish_prompt
    # Colors
    set -l grey    (set_color -o 949494)
    set -l neptune (set_color -o 00AFFF)
    set -l jupiter (set_color -o A85425)
    set -l demeter (set_color -o EDDA9F)
    set -l daedalus (set_color -o BA65CD)
    set -l white   (set_color -o FFFFFF)
    set -l reset   (set_color normal)

    # Cache hostname and delim color once
    if not set -q __prompt_host
        set -g __prompt_host (
            command hostnamectl hostname |
            string trim |
            string lower |
            string split -f1 '.'
        )

        switch $__prompt_host
            case neptune
                set -g __delim_col $neptune
            case jupiter
                set -g __delim_col $jupiter
            case demeter
                set -g __delim_col $demeter
            case daedalus
                set -g __delim_col $daedalus
            case '*'
                set -g __delim_col $white
        end
    end

    set -l host $__prompt_host
    set -l cwd (prompt_pwd)

    # Optional prefix for SSH or virtualized sessions
    set -l prompt_host ""
    if set -q SSH_TTY
        or begin
            command -sq systemd-detect-virt
            and systemd-detect-virt -q
        end
        set prompt_host "$__delim_col$host$reset "
    end

    # Print prompt
    echo -n "$prompt_host$grey$cwd $__delim_col\$ $reset"
end

