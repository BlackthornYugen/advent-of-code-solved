def find_increases($window_size):
    foreach .[] as $depth (
        #INIT;
        # Start at -1 because the first update will be registered as an increase but won't be one.
        { window: [], hits: 0 };

        #UPDATE
        . | . * {
            window: ([$depth] + .window)[0:($window_size)],
            oldWindow: .window,
            hits: .hits }
            |
            if   ( .oldWindow | length >= $window_size ) and (( .window | add ) > ( .oldWindow | add ))
            then ( . * {"hits": (.hits + 1)} )
            else ( . )
            end
              | { window, hits } | debug ;
        if $depth == -1
        then .hits
        else empty
        end
    )
;

. + [-1] | find_increases(($ARGS.named.window // 1)|tonumber)

# Usage 1a:
# jq --slurp --from-file "2021/jq/1.jq" "2021/01_blackthorn.input"
# Usage 1b:
# jq --slurp --arg window 3 --from-file "2021/jq/1.jq" "2021/01_blackthorn.input"