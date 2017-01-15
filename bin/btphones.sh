#!/bin/bash


phones_on () {
    #sudo rfkill unblock bluetooth
    #sudo hciconfig hci0 up
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
    pactl set-default-sink bluez_sink.34_C7_31_FD_BD_14
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
    default)
        echo "Unknown command: $COMMAND" >&2
        exit 13
esac
