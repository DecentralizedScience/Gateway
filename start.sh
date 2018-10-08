#!/bin/sh
if ! [ -x "$(command -v i3)" ]; then
  terminal -e python server.py
  terminal -e ganache-cli --account="$1,10000000000000000000"
  terminal -e ipfs daemon
else
  terminal -e python server.py
  i3 split vertical
  terminal -e ganache-cli --account="$1,1000000000000000000000"
  i3 split horizontal
  terminal -e ipfs daemon
fi
