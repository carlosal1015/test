#! /usr/bin/env bash

source /etc/profile.d/deal-ii.sh

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
    --verbose \
    --output-on-failure \
    --test-dir \
    tests_for_installed_dealii
}

function examples() {
  cmake \
    -S dealii/examples \
    -B examples_for_installed_dealii \
    -DDEAL_II_DIR=/usr \
    -Wno-dev

  cmake \
    --build examples_for_installed_dealii \
    --target examples
}

test
examples
