#!/usr/bin/env bash

set -e

DIR=~/xmera-scm/development/xmera_development_kit
PLUGIN=${PWD##*/}
source ./scripts/.env

cd "${0%/*}/.."

echo "Running tests: PLUGIN: ${PLUGIN}, CASE: ${CASE}"

if [ -d "${DIR}" ]; then
  cd ${DIR};
  make plugin_test CASE=${CASE} NAME=${PLUGIN} INTERACTIVE_TTY=${INTERACTIVE_TTY}
else
  echo "Could not find xmera development kit"
  exit 1
fi
