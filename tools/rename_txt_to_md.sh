#!/bin/bash

# Find all .txt files in the current directory and its subdirectories
for file in $(find . -type f -name "*.txt"); do
  # Get just the filename from the full path
  base=$(basename "$file")
  # Remove the extension to get the new name
  newbase="${base%.*}"
  # Rename the file by changing its extension
  mv "$file" "${newbase}.md"
done
