#!/bin/bash

echo "run through pipe into bash to see the secret message" 2>/dev/null

function secretMessage() {
  echo "keep this a secret to everybody"
  echo "you can't really pass args like this"
}

[ -t 0 ] || secretMessage
