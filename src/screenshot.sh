function usage_screenshot() {
cat << EOF
usage: ad screenshot options [<filename.png>]

This script automates Android screenshots fro a device connected over adb.  It
will pull the screenshot to the host computer with a default filename that has
the date in it.

OPTIONS:
   -o      Open the screenshot after saving
EOF
}

function screenshot() {
    DEFAULT_FILENAME="device-$(date +%Y-%m-%d-%H%M%S).png"

    filename=$DEFAULT_FILENAME
    open_flag=""

    while getopts "o" OPTION
    do
        case $OPTION in
            o)
                open_flag=1
                ;;
            ?)
                usage_screenshot
                exit
                ;;
        esac
    done

    shift $(($OPTIND -1))
    if [ ! -z $1 ] ; then
        filename=$1
    fi

    adb shell screencap -p /sdcard/$filename \
        && adb pull /sdcard/$filename &>/dev/null \
        && adb shell rm /sdcard/$filename

    if [ ! -z "$open_flag" -a -f "$filename" -a -s "$filename" ] ; then
        open "$filename"
    fi
}
