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
  mkdir -p ${chroot_dir}/etc/sysconfig/network-scripts
  function run_yum() { echo run_yum $*; }
}

function tearDown() {
  rm -rf ${chroot_dir}
}

### set value

## ethernet

function test_install_interface_ethernet_eth0() {
  install_interface ${chroot_dir} eth0 >/dev/null

  [[ -f ${chroot_dir}/etc/sysconfig/network-scripts/ifcfg-eth0 ]]
  assertEquals $? 0
}

function test_install_interface_ethernet_eth1() {
  install_interface ${chroot_dir} eth1 >/dev/null

  [[ -f ${chroot_dir}/etc/sysconfig/network-scripts/ifcfg-eth1 ]]
  assertEquals $? 0
}

## bridge

function test_install_interface_bridge_br0() {
  install_interface ${chroot_dir} br0 bridge >/dev/null

  [[ -f ${chroot_dir}/etc/sysconfig/network-scripts/ifcfg-br0 ]]
  assertEquals $? 0
}

## shunit2

. ${shunit2_file}
