# -*-Shell-script-*-
#
# description:
#  Hypervisor kvm
#
# requires:
#  bash
#  /usr/libexec/qemu-kvm, /usr/bin/kvm
#  cat, ip, brctl, telnet, ps, egrep
#  xargs, cut
#
# imports:
#  utils: shlog
#  hypervisor: viftabproc
#

function add_option_hypervisor_kvm() {
  image_format=${image_format:-raw}
  image_file=${image_file:-${name}.${image_format}}
  image_path=${image_path:-${image_file}}

  brname=${brname:-br0}

  kvm_path=${kvm_path:-$(qemu_kvm_path)}
  kvm_opts=${kvm_opts:-}

  mem_size=${mem_size:-1024}
  cpu_num=${cpu_num:-1}

  vnc_addr=${vnc_addr:-0.0.0.0}
  vnc_port=${vnc_port:-1001}
  vnc_keymap=${vnc_keymap:-en-us} # [ en-us | ja ]

  monitor_addr=${monitor_addr:-127.0.0.1}
  monitor_port=${monitor_port:-4444}

  serial_addr=${serial_addr:-127.0.0.1}
  serial_port=${serial_port:-5555}

  vif_num=${vif_num:-1}
  viftab=${viftab:-}

  vendor_id=${vendor_id:-52:54:00}
}

## command path

function qemu_kvm_path() {
  local execs="/usr/libexec/qemu-kvm /usr/bin/kvm"

  local command_path=
  for exe in ${execs}; do
    [[ -x "${exe}" ]] && command_path=${exe} || :
  done

  [[ -n "${command_path}" ]] || { echo "[ERROR] command not found: ${execs} (hypervisor/kvm:${LINENO})." >&2; return 1; }
  echo ${command_path}
}

## command builder

function build_vif_opt() {
  local vif_name macaddr bridge_if

  viftabproc <<-'EOS'
    local offset=$((${index} - 1))
    local netdev_id=hostnet${offset}
    # "addr" should be more than 0x3
    local addr="0x$((3 + ${offset}))"

    case "${macaddr}" in
    "-") macaddr=$(gen_macaddr ${offset}) ;;
    esac

    echo \
      -netdev tap,ifname=${vif_name},id=${netdev_id},script=,downscript= \
      -device virtio-net-pci,netdev=${netdev_id},mac=${macaddr},bus=pci.0,addr=${addr}
EOS
}

function build_drive_opt() {
  echo \
    -drive file=${image_path},media=disk,boot=on,index=0,cache=none
}

function build_kvm_opts() {
  echo \
   ${kvm_opts} \
   -name     ${name} \
   -m        ${mem_size} \
   -smp      ${cpu_num} \
   -vnc      ${vnc_addr}:${vnc_port} \
   -k        ${vnc_keymap} \
   -monitor  telnet:${monitor_addr}:${monitor_port},server,nowait \
   -serial   telnet:${serial_addr}:${serial_port},server,nowait \
   $(build_drive_opt) \
   $(build_vif_opt ${vif_num}) \
   -daemonize
}

function setup_bridge_and_vif() {
  checkroot || return 1

  viftabproc <<'EOS'
    shlog ip link set ${vif_name} up
    [[ -z "${bridge_if}" ]] || shlog brctl addif ${bridge_if} ${vif_name}
EOS
}

## controll kvm process

function start_kvm() {
  local name=${1}
  [[ -n "${name}" ]] || { echo "[ERROR] Invalid argument: name:${name} (hypervisor/kvm:${LINENO})" >&2; return 1; }
  checkroot || return 1

  shlog ${kvm_path} $(build_kvm_opts)
  setup_bridge_and_vif
}

function stop_kvm() {
  local monitor_addr=${1:-127.0.0.1} monitor_port=${2:-4444}
  [[ -n "${monitor_addr}" ]] || { echo "[ERROR] Invalid argument: monitor_addr:${monitor_addr} (hypervisor/kvm:${LINENO})" >&2; return 1; }
  [[ -n "${monitor_port}" ]] || { echo "[ERROR] Invalid argument: monitor_port:${monitor_port} (hypervisor/kvm:${LINENO})" >&2; return 1; }

  exec 5<>/dev/tcp/${monitor_addr}/${monitor_port}
  echo quit >&5
  cat  <&5 >/dev/null
  exec <&5-
}

function console_kvm() {
  local serial_addr=${1:-127.0.0.1} serial_port=${2:-5555}
  [[ -n "${serial_addr}" ]] || { echo "[ERROR] Invalid argument: serial_addr:${serial_addr} (hypervisor/kvm:${LINENO})" >&2; return 1; }
  [[ -n "${serial_port}" ]] || { echo "[ERROR] Invalid argument: serial_port:${serial_port} (hypervisor/kvm:${LINENO})" >&2; return 1; }

  telnet ${serial_addr} ${serial_port}
}

function list_kvm() {
  local kvm_path=${kvm_path:-$(qemu_kvm_path)}
  ps -ef | egrep -w ${kvm_path} | egrep -v "egrep -w ${kvm_path}"
}

function kvmof() {
  local name=$1
  [[ -n "${name}" ]] || { echo "[ERROR] Invalid argument: name:${name} (hypervisor/kvm:${LINENO})" >&2; return 1; }

  list_kvm | egrep -w -- "-name ${name}"
}

function info_kvm() {
  local name=$1
  [[ -n "${name}" ]] || { echo "[ERROR] Invalid argument: name:${name} (hypervisor/kvm:${LINENO})" >&2; return 1; }
  checkroot || return 1

  kvmof ${name} | beautify_process_args
  echo

  local pid=$(kvmof ${name} | awk '{print $2}')
  [[ -z "${pid}" ]] || {
    echo
    # 1. list kvm process fd
    # 2. delete "total XXX"
    # 3. order by fd number
    ls -l /proc/${pid}/fd/ | sed -e 1d |  sort -k 9 -n
  }
}

function dump_kvm() {
  cat <<-EOS
	name=${name}
	image_format=${image_format}
	image_file=${image_file}
	image_path=${image_path}

	brname=${brname}

	kvm_path=${kvm_path}
	kvm_opts=${kvm_opts}

	mem_size=${mem_size}
	cpu_num=${cpu_num}

	vnc_addr=${vnc_addr}
	vnc_port=${vnc_port}

	monitor_addr=${monitor_addr}
	monitor_port=${monitor_port}

	serial_addr=${serial_addr}
	serial_port=${serial_port}
	EOS
}
