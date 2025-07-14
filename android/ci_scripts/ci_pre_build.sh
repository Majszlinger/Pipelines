#!/bin/bash

# Fail this script if any subcommand fails.
set -e

# The default execution directory of this script is the ci_scripts directory.
# cd $CI_PRIMARY_REPOSITORY_PATH # change working directory to the root of your cloned repo.
# cd app/ 

# Input template file
TEMPLATE_FILE="env.template"
# Output .env file
OUTPUT_FILE=".env"

# Ensure the output file is empty before starting
> "$OUTPUT_FILE"

# Read the template file line by line
while IFS= read -r line || [ -n "$line" ]; do
  # Skip commented lines and empty lines
  case "$line" in
    \#* | '') continue ;; # Skip comments and empty lines
  esac

  # Extract the key and value from the line
  key=$(echo "$line" | cut -d '=' -f 1 | xargs)
  template_value=$(echo "$line" | cut -d '=' -f 2- | xargs)

  # Check if the key exists in the environment variables
  env_value=${!key}
  if [ -n "$env_value" ]; then
    # Use the value from the environment
    echo "$key=$env_value" >> "$OUTPUT_FILE"
  else
    # Use the value from the template
    echo "$key=$template_value" >> "$OUTPUT_FILE"
  fi
done < "$TEMPLATE_FILE"

echo "Generated .env file from template and environment variables."