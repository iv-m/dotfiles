# .bashrc

# Source global definitions
if [ -r /etc/bashrc ]; then
    . /etc/bashrc
fi

shopt -s histappend
shopt -s direxpand
export HISTCONTROL=ignoreboth:erasedups
export HISTFILESIZE=999999
export HISTSIZE=999999
export PS1='\[\033[0;1m\][\t \w\[\033[$PS_COLOR;1m\]${PS_EXIT_CODE:-}\[\033[0;1m\]]\$ \[\033[0m\]'
export PROMPT_COMMAND='PS_EXIT_CODE=$?; if [ "$PS_EXIT_CODE" -eq 0 ]; then PS_EXIT_CODE=""; PS_COLOR=0; else PS_EXIT_CODE=" <$PS_EXIT_CODE>"; PS_COLOR=31; fi; history -a'

source ~/.iv_shells_rc
