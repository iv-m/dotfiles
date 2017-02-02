
# User specific aliases and functions
alias qgit="qgit --all"
alias grep="grep --color=auto"

export BROWSER=/usr/bin/firefox
export GCC_USE_CCACHE=1
export CCACHE_COMPRESS=1
# export GREP_OPTIONS="--color=auto"
export MYSQL_PS1="$(hostname -s) \h/\d> "
export PYTHONSTARTUP="$HOME/.pythonrc.py"
export SPLUNK_TOOL_CONFIG="$HOME/.ssh/splunk.json"
export MAVEN_OPTS="-Xmx2048m -XX:MaxPermSize=2048m"
# export PATH=$PATH:/home/iv/opt/android-sdk-linux_x86/platform-tools/

# disable pango in firefox
export MOZ_DISABLE_PANGO=1

alias mc='. /usr/lib/mc/mc-wrapper.sh'
alias m='. /usr/lib/mc/mc-wrapper.sh -u'
alias df='df -h'
alias du='du -h'
alias gear-hsh='ionice -c idle nice gear-hsh'
alias gear-rpm='ionice -c idle nice gear-rpm'

export LC_MESSAGES=POSIX

sshs () {
    ssh "$@" -t 'screen -r || screen'
    return $?
}

vgrep () {
    vim "+grep -R $* | copen $((LINES/3))"
    return $?
}

# support for file:line syntax
veem () {
    # remove trailing colon, if any
    local arg="${1%:}"

    # file is everything before last colon
    local file="${arg%:*}"

    # line a number just before the end of arg
    local line="${arg##*[^0-9]}"

    vim "$file" "+${line}"
    return $?
}

