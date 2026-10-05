#! /bin/bash 

log_message(){
    local timestamp=$(date "+%Y-%m-%d %H:%M:%S")
    local log_file="${LOG_FILE:-./server-tool.log}"
    local module=$1
    local action=$2
    local result=$3
    local log_line="$timestamp | $module | $action | $result"

    if echo "$log_line" >> "$log_file" 2>&1; then
        echo "Success"
        echo "$log_line"
        return 0
    else
        echo "Failed"
        return 1
    fi
}

load_config(){
    local config_file="${1:-./config/config.conf.example}"
    if [ ! -f "$config_file" ]; then
        echo "Config file not found: $config_file" >&2
        return 1
    fi

    while IFS= read -r line || [[ -n "$line" ]]; do
        line="${line#"${line%%[![:space:]]*}"}"
        line="${line%"${line##*[![:space:]]}"}"
        [[ -z "$line" || "$line" =~ ^#.* ]] && continue

        if [[ "$line" =~ ^([a-zA-Z_][a-zA-Z0-9_]*)=(.*)$ ]]; then
            local key="${BASH_REMATCH[1]}"
            local value="${BASH_REMATCH[2]}"
            export "$key"="$value"
        fi
    done < "$config_file"

    return 0
}

