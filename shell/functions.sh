#!/bin/sh

_uch_admin_goodbye () 
{
    python "$UCH_SYSTEM"/shell/src/functions.py "admin_goodbye"

}

_uch_check_if_bash ()
{
    python "$UCH_SYSTEM"/shell/src/functions.py "shell_is_bash"
}

_uch_check_if_zsh ()
{
    python "$UCH_SYSTEM"/shell/src/functions.py "shell_is_zsh"
}

_uch_check_if_bash_or_zsh ()
{
    python "$UCH_SYSTEM"/shell/src/functions.py "shell_is_bash_or_zsh"
}

_uch_check_var_isset ()
{
    python "$UCH_SYSTEM"/shell/src/functions.py "check_var_isset" "$1"
}

_uch_check_file_ext ()
{
	python "$UCH_SYSTEM"/shell/src/functions.py "check_file_ext" "$1" "$2"
}

_uch_get_filepath ()
{
	python "$UCH_SYSTEM"/shell/src/functions.py "get_filepath" "$1"
}

_uch_check_user_confirmation ()
{
    local answer
    printf "Are you sure you want to do this? [y/N]: "
    read answer
    if echo "$answer" | grep -iq "^y" ;then
        return 0
    else
        return 1
    fi
}

_uch_get_active_ip ()
{
    ip addr | grep 'state UP' -A2 | tail -n1 | awk '{print $2}' | sed 's/\/.*//'
}

_uch_check_installed ()
{
    ## this only works on bash and zsh!!.
    ## 
    if [ -z "$1" ]; then
        echo "_uch_check_installed requires 1 argument: <executable_name>"
        _uch_admin_goodbye
        return 1
    fi

    local name="$1"
    printf " - checking existense of: '%s' ...... " "$name"
    if ! hash "$name" 2>/dev/null; then
        printf " NOT INSTALLED.\n"
        return 1
    else
        printf " OK.\n"
        return 0
    fi
}

_uch_check_installed_and_exit ()
{
    ## this only works on bash and zsh!!.
    ## 
    if [ -z "$1" ]; then
        echo "_uch_check_installed_and_exit requires 1 argument: <executable_name>"
        _uch_admin_goodbye
        exit 1
    fi

    local name="$1"
    if ! _uch_check_installed "$name"; then
        printf "Please Install '%s' before proceeding.\n" "$name"
        exit 1
    fi
    return 0
}
