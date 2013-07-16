
function usage_launch() {
cat << EOF
Usage: ad launch <apk>

  Installs the apk, then launches the first activity that declares
itself launchable.
EOF
}

function launch() {
    exactly launch 1 $#

    APK="$1"

    check_file $APK
    PACKAGE=`aapt dump badging "$APK" | grep package | sed "s/.*name='\([^']*\).*/\1/"`
    ACTIVITY=`aapt dump badging "$APK" | grep launchable-activity | sed "s/.*name='\([^']*\).*/\1/"`
    echo "Starting activity $ACTIVITY"

    adb install -r $APK
    adb shell am start -a android.intent.action.MAIN -n $PACKAGE/$ACTIVITY
}
