# Append LLVM toolchain to PATH
if hash brew 2>/dev/null; then
    LLVM_BIN_PATH=$(brew --cellar llvm33)/3.3/lib/llvm-3.3/bin

    if [[ -d $LLVM_BIN_PATH ]]; then
        path=($LLVM_BIN_PATH $path)
    fi

    unset LLVM_BIN_PATH
fi
