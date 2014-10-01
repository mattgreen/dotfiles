LLVM_BIN_PATH=/usr/local/opt/llvm/bin

if [[ -d $LLVM_BIN_PATH ]]; then
    path=($LLVM_BIN_PATH $path)
fi

unset LLVM_BIN_PATH
