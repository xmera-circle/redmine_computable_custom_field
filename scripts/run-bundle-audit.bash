#!/usr/bin/env bash

set -e

cd "${0%/*}/.."

FILE=./Gemfile.lock

if [ -f "$FILE" ]; then
  echo "Running bundle audit"
  bundle audit update
  bundle audit
else
  echo "Bundle audit not necessary: No Gemfile found"
fi
