#!/bin/bash
#
# requires:
#   bash
#

## include files

. $(cd ${BASH_SOURCE[0]%/*} && pwd)/helper_shunit2.sh

## variables

## public functions

function test_add_option_hypervisor_lxc() {
  add_option_hypervisor_lxc
  assertEquals $? 0
}

## shunit2

. ${shunit2_file}
