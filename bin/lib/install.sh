
# === {{CMD}} ...
install () {
  local TEMP="$THIS_DIR/tmp"
  local DOWNLOAD="$(wget -qO-  http://redis.io/download | grep -Pzo '(?s)Stable.+?\K(https?://[^>]+?\/redis-[\d\.]+\.tar\.gz)')"
  local ARCHIVE="$(basename $DOWNLOAD)"
  local SRC="$(basename $DOWNLOAD .tar.gz)"
  local PREFIX="$@"
  if [[ -z "$PREFIX" ]]; then
    PREFIX="$PWD/progs"
  fi

  mkdir -p "$TEMP"
  mkdir -p "$PREFIX/bin"

  cd "$TEMP"
  if [[ ! -s "$ARCHIVE" ]]; then
    wget $DOWNLOAD
    rm -rf redis-*
  fi

  if [[ ! -f $SRC/src/redis-server || ! -f $SRC/src/redis-cli ]]; then
    tar xvzf "$ARCHIVE" || { rm -f $ARCHIVE; wget "$DOWNLOAD"; tar xvzf "$ARCHIVE"; }
    cd $SRC
    make
    make test
  fi

  cd $SRC
  cp -f src/redis-server "$PREFIX/bin/"
  cp -f src/redis-cli    "$PREFIX/bin/"

  bash_setup GREEN "=== Installed {{redis}} to: $PREFIX/bin"
} # === end function
