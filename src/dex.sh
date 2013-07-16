function usage_dexstats() {
cat << EOF
usage: ad dexstats <classes.dex>

Prints total method count as well as a breakdown of method counts per package

Taken from gist posted by Jake Wharton (https://gist.github.com/JakeWharton)

Requires smali/baksmali
EOF
}

function dex_method_count() {
    cat "$1" | head -c 92 | tail -c 4 | hexdump -e '1/4 "%d\n"'
}

function dexstats() {
    exactly dexstats 1 $#
    dexfile="$1"
    check_file "$dexfile"

    ensure hexdump
    count=$(dex_method_count "$dexfile")
    echo -e "$count\tTotal Methods"

    ensure smali baksmali
    dir=$(mktemp -d -t dex)
    baksmali $dexfile -o $dir
    for pkg in `find $dir/* -type d`; do
        smali $pkg -o $pkg/classes.dex
        count=$(dex_method_count $pkg/classes.dex)
        name=$(echo ${pkg:(${#dir} + 1)} | tr '/' '.')
        echo -e "$count\t$name"
    done
    rm -rf $dir
}
