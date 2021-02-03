#!/bin/bash

echo "run through pipe into bash to see the secret message" 2>/dev/null

function secretMessage() {
  echo "keep this a secret to everybody"
  echo "your args are $@"
  echo "first arg was $1"
}

# shellcheck disable=SC2015
[[ "${0#-}" == "${BASH_SOURCE[0]}" ]] && secretMessage "$@" || true
