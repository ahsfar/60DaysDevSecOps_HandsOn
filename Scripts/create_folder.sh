#!/bin/bash

while IFS= read -r line; do
  mkdir -p "$line"
  echo "# This is the README for $line" > "$line/README.md"
done < "file.txt"

