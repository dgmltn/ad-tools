ensure aapt adb

case $1 in
    launch )
        shift
        launch $*
        ;;
    tasks )
        shift
        tasks $*
        ;;
    screenshot )
        shift
        screenshot $*
        ;;
    help )
        shift
        if [ $# -eq 0 ] ; then
            usage
        else
            usage_$1
        fi
        ;;
esac
