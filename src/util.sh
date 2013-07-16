function usage() {
cat << EOF
Usage: ad <cmd> options

Use ad help <cmd> for more information.

The following is the list of available commands:

    launch: Launch activity given apk
    tasks: task information for running app
    screenshot: take a screenshot
EOF
}

function ensure () {
    hash -r
    for cmd in $* ; do
        which $cmd > /dev/null
        if [ $? -ne 0 ] ; then
            echo "Command $cmd not found"
            exit 1
        fi
    done
}

function exactly() {
    CMD="$1"
    X="$2"
    Y="$3"

    if [ $X -ne $Y ] ; then
        usage_$CMD
        exit 1
    fi
}

function usage_file() {
    FILE="$1"
    echo "$FILE: File does not exist"
}


function check_file() {
    FILE="$1"
    if [ ! -f $FILE ] ; then
        usage_file $FILE
        exit 1
    fi
}

