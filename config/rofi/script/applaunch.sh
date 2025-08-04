dir="$HOME/.config/rofi/script/"
theme='appconfig'

## Run
rofi \
    -dmenu -p "Run: '$($HOME/.config/rofi/script/cmd.sh)'" \
    -theme ${dir}/${theme}.rasi
