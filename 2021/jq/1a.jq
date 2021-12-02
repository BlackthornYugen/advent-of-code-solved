def find_increases:
    foreach .[] as $depth (
        #INIT;
        {"count":0, "last_ping_result": null};

        #UPDATE
        . * { last_ping_result: $depth  };

        #EXTRACT
        .
    )
;


find_increases

