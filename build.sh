#!/bin/bash

files="src/util.sh src/launch.sh src/tasks.sh src/screenshot.sh src/main.sh"
target="bin/ad"

echo "#!/bin/bash" > $target
cat $files >> $target
chmod +x $target

