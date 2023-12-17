#!/usr/bin/env bash
set -x
suffix=${suffix:-a.sample}
while sleep 2 ; do 
    TRIGGER=$(fswatch --one-event *.jq)
    time $TRIGGER "${TRIGGER%%.jq}${suffix}"
done