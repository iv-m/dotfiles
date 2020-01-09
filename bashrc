# .bashrc

# Source global definitions
if [ -r /etc/bashrc ]; then
    . /etc/bashrc
fi

shopt -s histappend
export HISTCONTROL=ignoreboth:erasedups
export HISTFILESIZE=999999
export HISTSIZE=999999
export PS1='\[\033[0;1m\][\t \w${PS_EXIT_CODE:-}]\$ \[\033[0m\]'
export PROMPT_COMMAND='PS_EXIT_CODE=$?; [ "$PS_EXIT_CODE" -eq 0 ] && PS_EXIT_CODE="" || PS_EXIT_CODE=" <$PS_EXIT_CODE>"; history -a'

source ~/.iv_shells_rc
