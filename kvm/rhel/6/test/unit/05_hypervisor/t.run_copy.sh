#!/bin/bash
#
# requires:
#   bash
#

## include files

. ./helper_shunit2.sh

## variables

declare copyfile=${abs_dirname}/copy.$$

## public functions

function setUp() {
  mkdir -p ${chroot_dir}/tmp
  echo src > ${abs_dirname}/src
  echo foo > ${abs_dirname}/foo
  cat <<-EOS > ${copyfile}
	${abs_dirname}/src /tmp/dst
	
	${abs_dirname}/foo /tmp/var
	${abs_dirname}/zzz /tmp/zzz
	EOS
  #function cp() { echo cp $*; }
}

function tearDown() {
  rm -rf ${chroot_dir}
  rm -f  ${abs_dirname}/src
  rm -f  ${abs_dirname}/foo
  rm -f  ${copyfile}
}

function test_run_copy_found() {
  run_copy ${chroot_dir} ${copyfile}
  assertEquals $? 0

  diff ${abs_dirname}/src ${chroot_dir}/tmp/dst
  assertEquals $? 0
}

function test_run_copy_not_found() {
  run_copy ${chroot_dir} ${abs_dirname}/_$$.copy
  assertNotEquals $? 0
}

## shunit2

. ${shunit2_file}
