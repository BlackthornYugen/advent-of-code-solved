# 2020 Advent of Code
## JQ
```
# Usage aoc_jq_debug <NUMBER>
aoc_jq_debug() {
    watch -d -c "time jq --raw-input --color-output --slurp --from-file 2020/jq/${1}.jq 2020/input.${1} 2>&1"
}

# Usage aoc_jq_run <NUMBER>
aoc_jq_run() {
    jq --raw-input --slurp --from-file 2020/jq/${1}.jq 2020/input.${1}
}
```

### 2
[AOC 2020 2 in JQ](./2.jq)
<img src="../../media/2020/2-2.png?raw=true"/>

### 3
[AOC 2020 3 in JQ](./3.jq)
<img src="../../media/2020/3-2.png?raw=true"/>

### 4
[AOC 2020 4 in JQ](./4.jq)
<img src="../../media/2020/4-2.png?raw=true"/>
