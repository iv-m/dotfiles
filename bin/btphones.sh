#!/bin/bash

phones_on () {
    /usr/sbin/rfkill unblock bluetooth ||:
    #sudo hciconfig hci0 up
    sleep 1s
    (
        # echo "power off"
        # sleep 1s
        echo "power on"
        sleep 1s
        echo "connect 34:C7:31:FD:BD:14"
        sleep 7s
    ) | bluetoothctl

    phones_def
}

phones_off () {
    (
        echo "power off"
        sleep 1s
    ) | bluetoothctl
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
