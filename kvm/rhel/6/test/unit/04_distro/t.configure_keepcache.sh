#!/bin/bash
#
# requires:
#   bash
#

## include files

. $(cd ${BASH_SOURCE[0]%/*} && pwd)/helper_shunit2.sh

## variables

## public functions

function setUp() {
  mkdir -p ${chroot_dir}/etc
  cp -p /etc/yum.conf ${chroot_dir}/etc
}

function tearDown() {
  rm -rf ${chroot_dir}
}

function test_configure_keepcache_default() {
  local keepcache=

  configure_keepcache ${chroot_dir} | egrep -q -w ^keepcache=1
  assertEquals $? 0
}

function test_configure_keepcache_arg_0() {
  local keepcache=

  configure_keepcache ${chroot_dir} 0 | egrep -q -w ^keepcache=0
  assertEquals $? 0
}

function test_configure_keepcache_arg_1() {
  local keepcache=

  configure_keepcache ${chroot_dir} 1 | egrep -q -w ^keepcache=1
  assertEquals $? 0
}

function test_configure_keepcache_param_0() {
  local keepcache=0

  configure_keepcache ${chroot_dir} | egrep -q -w ^keepcache=${keepcache}
  assertEquals $? 0
}

function test_configure_keepcache_param_1() {
  local keepcache=1

  configure_keepcache ${chroot_dir} | egrep -q -w ^keepcache=${keepcache}
  assertEquals $? 0
}

function test_configure_keepcache_complex() {
  local keepcache=1

  configure_keepcache ${chroot_dir} 0 | egrep -q -w ^keepcache=0
  assertEquals $? 0

  configure_keepcache ${chroot_dir}   | egrep -q -w ^keepcache=${keepcache}
  assertEquals $? 0

  configure_keepcache ${chroot_dir} 1 | egrep -q -w ^keepcache=1
  assertEquals $? 0

  keepcache=0
  configure_keepcache ${chroot_dir}   | egrep -q -w ^keepcache=${keepcache}
  assertEquals $? 0
}

## shunit2

. ${shunit2_file}
