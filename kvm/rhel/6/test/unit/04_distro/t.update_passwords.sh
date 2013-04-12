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
  mkdir -p ${chroot_dir}

  function update_user_password() { echo update_user_password $*; }
  function update_user_encpassword() { echo update_user_encpassword $*; }
  function chroot() { echo chroot $*; }

  rootpass=
  rootencpass=
}

function tearDown() {
  rm -rf ${chroot_dir}
}

function test_update_passwords_empty_rootpass() {
  update_passwords ${chroot_dir} | egrep -q -w "^chroot ${chroot_dir} bash -e -c usermod -L root"
  assertEquals $? 0
}

function test_update_passwords_rootpass() {
  local rootpass=asdf

  update_passwords ${chroot_dir} | egrep -q -w "^update_user_password ${chroot_dir} root ${rootpass}"
  assertEquals $? 0
}

function test_update_passwords_empty_rootencpass() {
  update_passwords ${chroot_dir} | egrep -q -w "^chroot ${chroot_dir} bash -e -c usermod -L root"
  assertEquals $? 0
}

function test_update_passwords_rootencpass() {
  local rootencpass=$6$7abcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrst

  update_passwords ${chroot_dir} | egrep -q -w "^update_user_encpassword ${chroot_dir} root ${rootencpass}"
  assertEquals $? 0
}

## shunit2

. ${shunit2_file}
