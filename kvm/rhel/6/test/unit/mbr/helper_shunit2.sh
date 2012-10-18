# -*-Shell-script-*-
#
# requires:
#   bash
#

## system variables

readonly abs_dirname=$(cd $(dirname $0) && pwd)
readonly shunit2_file=${abs_dirname}/../shunit2

## include files

. ${abs_dirname}/../../../functions/mbr.sh

## group variables

declare disk_filename=${abs_dirname}/_disk.raw.$$
