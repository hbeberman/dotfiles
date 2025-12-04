if status is-interactive
    # Commands to run in interactive sessions can go here
    # Move down in history with Ctrl+j
    bind \cj down-or-search

    # Move up in history with Ctrl+k
    bind \ck up-or-search

    fish_vi_key_bindings

    function fish_mode_prompt
      if test "$fish_bind_mode" = "default"
            set_color -o FF7F50
            echo -n "# $reset"
      end
    end
end
