#! /usr/bin/env bash

# source /etc/profile.d/deal-ii.sh

function test() {
  cmake \
    -S dealii/tests \
    -B tests_for_installed_dealii \
    -DDEAL_II_DIR=/usr \
    -Wno-dev

  cmake \
    --build tests_for_installed_dealii \
    --target setup_tests

  ctest \
    -j $(nproc) \
    --verbose \
    --output-on-failure \
    --test-dir tests_for_installed_dealii
}

function examples() {
  for step in step-*; do
    pushd step
    cmake -B build -Wno-dev
    cmake --build build --target run
    popd
  done
}

# https://stackoverflow.com/a/16496491/9302545
usage() {
  echo "Usage: $0 [-p <string>]" 1>&2
  exit 1
}

while getopts ":s:p:" o; do
  case "${o}" in
  p)
    p=${OPTARG}
    if [ "$OPTARG" == "example" ]; then
      examples
    elif [ "$OPTARG" == "test" ]; then
      test
    else
      echo "Input valids: example or test."
      usage
    fi
    ;;
  *)
    usage
    ;;
  esac
done
shift $((OPTIND - 1))

if [ -z "${p}" ]; then
  usage
fi
