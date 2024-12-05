#!/usr/bin/env sh

wall_set=$HOME/Pictures/wallpaper/desktop.png

wallpaper_set() {
    cursor_pos=$(hyprctl cursorpos)

    # 检查返回的 cursor_pos 是否有效
    if [[ "$cursor_pos" =~ ^[0-9]+,[0-9]+$ ]]; then
        transition_pos="--transition-pos $cursor_pos"
    else
        # 如果返回无效坐标，使用默认位置或不设置该参数
        transition_pos=""
    fi

    swww img "$wall_set" \
        --transition-bezier .43,1.19,1,.4 \
        --transition-duration 0.7 \
        --transition-fps 60 \
        --invert-y \
        $transition_pos
}
swww query
if [ $? -eq 1 ]; then
    swww-daemon
fi

wallpaper_set
