function usage_dexstats() {
cat << EOF
usage: ad dexstats <classes.dex>

Prints a breakdown of method counts per package

Taken from gist posted by Jake Wharton (https://gist.github.com/JakeWharton)

Requires smali/baksmali
EOF
}

function dex_method_count() {
    cat "$1" | head -c 92 | tail -c 4 | hexdump -e '1/4 "%d\n"'
}

function dexstats() {
    exactly dexstats 1 $#
    apk="$1"
    check_file "$apk"

    ensure smali baksmali

    dir=$(mktemp -d -t ad-tools-dexstats)
    dexfile=$(mktemp -t ad-tools-classes.dex)


    # Extract entire classes.dex
    unzip -p "$apk" "classes.dex" | cat > $dexfile

    # Recompile into only the leaf packages
    baksmali $dexfile -o $dir
    for pkg in `find_leaves $dir/*`; do
        smali $pkg -o $pkg/classes.dex
        count=$(dex_method_count $pkg/classes.dex)
        name=$(echo ${pkg:(${#dir} + 1)} | tr '/' '.')
        echo -e "$count\t$name"
    done

    # Recompile the entire thing so dex_method_count works
    smali $dir -o $dir/classes.dex
    totalcount=$(dex_method_count $dir/classes.dex)
    echo "Total: ${totalcount}"
    rm -rf $dir
    rm -rf $dexfile
}
