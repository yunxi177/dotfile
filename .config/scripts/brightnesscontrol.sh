#!/usr/bin/env sh

function print_error
{
cat << "EOF"
    ./brightnesscontrol.sh <action>
    ...valid actions are...
        i -- <i>ncrease brightness [+5%]
        d -- <d>ecrease brightness [-5%]
EOF
}

function send_notification {
    ico="~/.config/dunst/icons/vol/vol-${angle}.svg"
    current=$(brightnessctl g)
    max=$(brightnessctl m)
    percent=$((current * 100 / max))
    notify-send -i display-brightness-symbolic "亮度调整" "当前亮度：$percent%"

}

function get_brightness {
    brightnessctl -m | grep -o '[0-9]\+%' | head -c-2
}

case $1 in
i)  # increase the backlight by 5%
    brightnessctl set +5%
    send_notification ;;
d)  # decrease the backlight by 5%
    if [[ $(get_brightness) -lt 5 ]] ; then
        # avoid 0% brightness
        brightnessctl set 1%
    else
        # decrease the backlight by 5%
        brightnessctl set 5%-
    fi
    send_notification ;;
*)  # print error
    print_error ;;
esac

