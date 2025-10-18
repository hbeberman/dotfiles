function codex_login --wraps='ssh -N -L 1455:127.0.0.1:1455 henry@jupiter' --description 'alias codex_login=ssh -N -L 1455:127.0.0.1:1455 henry@jupiter'
    ssh -N -L 1455:127.0.0.1:1455 henry@jupiter $argv
end
