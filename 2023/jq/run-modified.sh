#!/usr/bin/env bash
set -x
while sleep 2 ; do 
    TRIGGER=$(fswatch --one-event *.jq)
    $TRIGGER "${TRIGGER%%.jq}a.sample"
done