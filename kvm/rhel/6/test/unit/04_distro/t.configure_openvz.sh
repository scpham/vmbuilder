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

  function install_vzkernel() { echo install_vzkernel $*; }
  function install_vzutils() { echo install_vzutils $*; }
  function install_menu_lst_vzkernel() { echo install_menu_lst_vzkernel $*; }
}

function tearDown() {
  rm -rf ${chroot_dir}
}

function test_configure_openvz() {
  configure_openvz ${chroot_dir}
  assertEquals $? 0
}

## shunit2

. ${shunit2_file}
