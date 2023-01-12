
# -*- encoding: utf-8 -*-

# pythonstartup
import os
import readline
import rlcompleter
import atexit

# Bind ‘TAB’ to complete
readline.parse_and_bind('tab:complete')
# Set history file – ~\.pythonhistory

histfile = os.path.join(os.environ['HOME'], '.pythonhistory')
# Attempt read of histfile
try:
    readline.read_history_file(histfile)
except IOError:
    pass

# Write history file at shell exit
atexit.register(readline.write_history_file, histfile)
# Cleanup
del os, histfile, readline, rlcompleter
