
# User specific aliases and functions
alias grep="grep --color=auto"
alias mc='. /usr/lib/mc/mc-wrapper.sh'
alias m='. /usr/lib/mc/mc-wrapper.sh -u'
alias df='df -h'
alias du='du -h'
alias gear-hsh='ionice -c idle nice gear-hsh'
alias gear-rpm='ionice -c idle nice gear-rpm'
alias use_java=". use_java"
alias udiff='git diff --no-index'

export BROWSER=/usr/bin/firefox
export EDITOR=vim
export GCC_USE_CCACHE=1
export ALTWRAP_LLVM_USE_CCACHE=1
export ALTWRAP_LLVM_VERSION=15.0
export CCACHE_COMPRESS=1
export MYSQL_PS1="$(hostname -s) \h/\d> "
export PYTHONSTARTUP="$HOME/.pythonrc.py"
export MAVEN_OPTS="-Xmx2048m -XX:MaxPermSize=2048m"

export LC_MESSAGES=C.utf-8
# unset LC_ALL
# export LC_ALL

# no org.a11y.Bus lookup
export NO_AT_BRIDGE=1
# . use_java 1.8

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
