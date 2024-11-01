
new-session -s gyles -n m
send-keys -t gyles:0 mutt ENTER
new-window -t gyles:1 -n b
send-keys 'env TERM=screen ssh xrs -t screen -x' ENTER
new-window -t gyles:2 -n ln
send-keys 'env TERM=screen ssh xshare -t screen -x' ENTER

if-shell -b "[ $(hostname -s) == 'iv-work' ]" {
    new-window -t gyles:3 -n ry
    send-keys 'env TERM=screen ssh ryzen -t screen -x' ENTER
}

select-window -t gyles:0
