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
  mkdir -p ${chroot_dir}

  mkdisk ${disk_filename} ${totalsize} 2>/dev/null
  mkptab ${disk_filename}
  mapptab ${disk_filename}
  mkfsdisk ${disk_filename}
  mount_ptab ${disk_filename} ${chroot_dir}

  function is_dev() { echo is_dev $*; }
}

function tearDown() {
  rm -f ${disk_filename}
  rm -rf ${chroot_dir}
}

function test_trap_vm() {
  trap_vm ${disk_filename} ${chroot_dir}
  assertEquals $? 0
}

## shunit2

. ${shunit2_file}
