function hexcalc
    if test (count $argv) -eq 0
        echo "usage: hexcalc \"0xA + 0x1F\"" >&2
        return 1
    end

    # join all arguments into one expression string
    set expr (string join " " $argv)

    # evaluate using fish’s math (which supports hex)
    set result (math "$expr")

    # print as uppercase hex
    printf "%X\n" $result
end
