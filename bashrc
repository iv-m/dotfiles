# .bashrc

# Source global definitions
if [ -r /etc/bashrc ]; then
    . /etc/bashrc
fi

shopt -s histappend
export HISTCONTROL=ignoredups:erasedups
export PS1='\[\033[0m\033[1m\][\t \w <$?>]\$ \[\033[0m\]'
export PROMPT_COMMAND='history -a'

source ~/.iv_shells_rc

