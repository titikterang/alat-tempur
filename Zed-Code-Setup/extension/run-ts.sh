#!/bin/bash
# Runs a TypeScript file using tsx (fallback to ts-node if tsx not found)

FILE="$1"

if [ -z "$FILE" ]; then
  echo "No file provided."
  exit 1
fi

# Check if tsx is installed
if command -v tsx >/dev/null 2>&1; then
  tsx "$FILE"
elif command -v ts-node >/dev/null 2>&1; then
  ts-node "$FILE"
else
  echo "Error: Please install tsx or ts-node globally:"
  echo "  npm install -g tsx"
  exit 1
fi

