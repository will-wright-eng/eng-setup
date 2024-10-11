#! /bin/bash

create_env_example() {
    if [ "$#" -ne 1 ]; then
        echo "Usage: dotenvex <path-to-env-file>"
        return 1
    fi

    local ENV_FILE="$1"
    local ENV_EXAMPLE_FILE="${ENV_FILE}.example"

    awk -F '=' '/=/ {
        if (tolower($1) ~ /(key|token|secret|password)/) {
            print $1 "=REDACTED"
        } else {
            print $1 "=" $2
        }
    } ! /=/ { print }' "$ENV_FILE" > "$ENV_EXAMPLE_FILE"
    echo "Example environment file created: $ENV_EXAMPLE_FILE"
}

alias dotenvex="create_env_example"

cnote () {
    local input="$1"
    local filename="$(date +"%Y%m%d")-$input.md"
    local filedir="$HOME/repos/cyber-epistemics/website/site/content/blog"
    local filepath="$filedir/$filename"
    local msg="---
author: \"Will Wright\"
title: \"${input}\"
date: $(date +%Y-%m-%dT%H:%M:%S-07:00)
# description: \"${input}\"
tags: [\"blog\", \"project\", \"static\", \"tags\"] #include full list to trim from
categories: [\"cnote auto-generated\", \"blogging\"]
series: [\"cnote auto-generated\"]
aliases: [\"${input}\"]
ShowToc: true
TocOpen: false
draft: true
---

*intro*

## first section

*content*

## references

- [ref 1]()
"
    echo "$msg"
    if test -e "$filepath"; then
        echo "...file exists; not overwritten"
        cursor "$filepath"
    else
        touch "$filepath"
        echo "$msg" >> "$filepath"
        cursor "$filepath"
    fi
}

function aisay() {
    sgpt --no-cache "$*" | tee >(say)
}
