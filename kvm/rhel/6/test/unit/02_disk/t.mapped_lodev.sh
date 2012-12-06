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
  mkdisk ${disk_filename} ${totalsize} 2>/dev/null
  mkptab ${disk_filename}
}

function tearDown() {
  unmapptab ${disk_filename}
  rm -f ${disk_filename}
}

function test_mapped_lodev() {
  mapptab ${disk_filename}

  mapped_lodev ${disk_filename}
  assertEquals $? 0
}

function test_mapped_lodev_2times_to_use_mapped_device() {
  mapptab ${disk_filename}
  mapped_lodev ${disk_filename}

  mapped_lodev ${disk_filename}
  assertEquals $? 0
}

## shunit2

. ${shunit2_file}
