def find_increases:
    foreach .[] as $depth (
        #INIT;
        # Start at -1 because the first update will be registered as an increase but won't be one.
        { last: null, hits: -1 }; 

        #UPDATE
        . * { 
            last: $depth, 
            hits:  ( if (.last > $depth) then .hits else (.hits + 1) end ) 
            };
        if $depth == "FINISH" then (.hits - 1) else empty end 
    )
;


. + ["FINISH"] | find_increases

