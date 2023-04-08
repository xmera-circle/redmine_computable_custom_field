#!/usr/bin/env bash

set -e

cd "${0%/*}/.."

echo "Running brakeman"
brakeman --force
