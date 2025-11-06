function weather --wraps='curl wttr.in/Redmond_Wa' --wraps='curl wttr.in/Redmond_Wa | head -n 30' --wraps='curl wttr.in/Redmond_Wa | head -n 27' --wraps='curl -sS wttr.in/Redmond_Wa | head -n 27 2>/dev/null' --description 'alias weather=curl -sS wttr.in/Redmond_Wa | head -n 27 2>/dev/null'
    curl -sS wttr.in/Redmond_Wa | head -n 27 2>/dev/null $argv
end
