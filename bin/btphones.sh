#!/bin/bash

retry () {
    local max="$1"
    shift
    for attempt in $(seq 1 "$max"); do
        "$@" && break;
        sleep 1s
    done
}

phones_on () {
    /usr/sbin/rfkill unblock bluetooth ||:
    #sudo hciconfig hci0 up
    retry 5 bluetoothctl power on
    sleep .5s
    retry 5 bluetoothctl connect 34:C7:31:FD:BD:14
}

phones_off () {
    bluetoothctl power off
    sleep 1s
}

phones_def () {
    pactl set-default-sink bluez_sink.34_C7_31_FD_BD_14.a2dp_sink \
        || pactl set-default-sink bluez_sink.34_C7_31_FD_BD_14
}

set -exu

COMMAND="${1:-on}"

case "$COMMAND" in
    on|off|def)
        "phones_$COMMAND"
        ;;
    dmesg)
        dmesg | grep -i bluetooth
        ;;
    block)
        /usr/sbin/rfkill block bluetooth
        ;;
    *)
        echo "Unknown command: $COMMAND" >&2
        exit 13
esac
