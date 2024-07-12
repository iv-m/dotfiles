
new-session -s gyles -n m mutt
new-window -t gyles:1 -n b 'env TERM=screen ssh xrs -t screen -x'
new-window -t gyles:2 -n ln 'env TERM=screen ssh xshare -t screen -x'
select-window -t gyles:0
