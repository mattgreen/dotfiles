LLVM_BIN_PATH=/usr/local/Cellar/llvm33/3.3_1/lib/llvm-3.3/bin

if [[ -d $LLVM_BIN_PATH ]]; then
    path=($LLVM_BIN_PATH $path)
fi

unset LLVM_BIN_PATH
