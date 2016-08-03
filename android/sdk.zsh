if [[ -d /usr/local/opt/android-sdk ]]; then
    export ANDROID_HOME=/usr/local/opt/android-sdk
    path=(/usr/local/opt/android-sdk/bin $path)
fi
