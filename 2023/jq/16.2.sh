#!/usr/bin/env bash
TMP_DIR="/var/folders/b5/fcbmwgp144lgpd8r0hl5k2jh0000gn/T/tmp.aS06MfEndN"
input=${input:-16.input}
columns=$(head -1 "$input" | wc -c | awk '{print $1}')
rows=$(wc -l "$input" | awk '{print $1}')
{
    for y in $(seq 0 "$rows") ; do 
        ./16.jq "$input" --arg y "$y" --arg x 0 --arg direction east > $TMP_DIR/"0.${y}.east.log" &
        ./16.jq "$input" --arg y "$y" --arg x "$columns" --arg direction west > $TMP_DIR/"${columns}.$y.west.log" &
    done
    wait
    for x in $(seq 0 "$columns") ; do 
        ./16.jq "$input" --arg y 0 --arg x "$x" --arg direction south > $TMP_DIR/"${x}.0.south.log" &
        ./16.jq "$input" --arg y "$rows" --arg x "$x" --arg direction north > $TMP_DIR/"${x}.${rows}.north.log" &
    done
}
wait
cat $TMP_DIR/* | jq --slurp 'sort_by(.energized)'
rm -f $TMP_DIR/*

echo "$columns" "$rows"