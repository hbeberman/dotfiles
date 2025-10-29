function kns
    # Default node index
    set -l NODE 0

    # Validate first argument if provided (must be a single digit 0-9)
    if test (count $argv) -gt 0
        if string match -qr '^[0-9]$' -- $argv[1]
            set NODE $argv[1]
        else
            echo "Invalid argument, defaulting to node 0"
        end
    end

    # Get the first node name and trim its last character
    set -l node_name (kubectl get nodes -o jsonpath='{.items[0].metadata.name}' | sed 's/.$//')

    set -l MYNODE "$node_name$NODE"

    echo "Connecting to node $MYNODE"
    kubectl node-shell "$MYNODE"
end
