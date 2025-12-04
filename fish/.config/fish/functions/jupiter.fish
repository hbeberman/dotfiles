function jupiter --wraps='ssh henry@jupiter' --description 'alias jupiter=ssh henry@jupiter'
    TERM=xterm-256color ssh henry@jupiter $argv
end
