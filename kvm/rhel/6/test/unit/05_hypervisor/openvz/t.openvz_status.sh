#!/bin/bash
#
# requires:
#   bash
#

## include files

. ./helper_shunit2.sh

## variables

## public functions

function setUp() {
  add_option_hypervisor_openvz

  function checkroot() { echo checkroot $*; }
  function shlog() { echo shlog $*; }
}

function test_openvz_status() {
  openvz_status vmbuilder
}

## shunit2

. ${shunit2_file}