#! /usr/bin/bash


function set_background
{
    local path="file:///$1"
    gsettings set org.gnome.desktop.background picture-uri "$path"
}

function select_random_picture
{
    local dirname="$1"
    find "$dirname" -type f \( -name "*.png" -or -name "*.jpg" \) \
        | sort -R | head -1
}

function dbus_session_bus_address
{
    local pid=$(pgrep gnome-session | head -1)

    # here we replace \0 in \n in order to avoid
    # warning: command substitution: ignored null byte in input
    grep -z DBUS_SESSION_BUS_ADDRESS /proc/$pid/environ \
        | tr '\0' '\n' \
        | cut -d= -f2-
}


if [ "$#" -gt 0 ]; then
    fname="$1"
else
    fname=$(select_random_picture ~/Pictures/16:9/)
fi


# we'll receive the following error otherwise
# failed to commit changes to dconf: Cannot autolaunch D-Bus without X11 $DISPLAY
#
# NOTE: apparently, is not necessary for gnome on xorg (3.34)
#
#export DBUS_SESSION_BUS_ADDRESS=$(dbus_session_bus_address)

set_background "$fname"
