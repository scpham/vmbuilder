# -*-Shell-script-*-
#
# requires:
#   bash
#

## system variables

readonly abs_dirname=$(cd ${BASH_SOURCE[0]%/*} && pwd)
readonly shunit2_file=${abs_dirname}/../../../shunit2

## include files

. ${abs_dirname}/../../../../functions/utils.sh
. ${abs_dirname}/../../../../functions/disk.sh
. ${abs_dirname}/../../../../functions/distro.sh
. ${abs_dirname}/../../../../functions/hypervisor.sh
. ${abs_dirname}/../../../../functions/hypervisor/kvm.sh

## group variables

declare hypervisor=kvm
