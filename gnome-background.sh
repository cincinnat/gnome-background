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


if [ "$#" -gt 0 ]; then
    fname="$1"
else
    fname=$(select_random_picture ~/Pictures/16:9/)
fi


# we'll receive the following error otherwise
# failed to commit changes to dconf: Cannot autolaunch D-Bus without X11 $DISPLAY
#
pid=$(pgrep gnome-session | head -1)
export DBUS_SESSION_BUS_ADDRESS=$(grep -z DBUS_SESSION_BUS_ADDRESS /proc/$pid/environ | cut -d= -f2-)

set_background "$fname"
