# Run with

```
shellspec --color spec/jq_spec.sh
```

# Results will look something like:

```
Running: /bin/sh [bash 3.2.57(1)-release]

2021 jq advent of code
  1a
    script must output 7 for 2021/1aDemo.input
    script must output 1692 for 2021/1aPants.input
    script must output 1475 for 2021/1aBlackthorn.input
  1b
    script must output 5 for 2021/1aDemo.input
    script must output 1516 for 2021/1aBlackthorn.input
  2a
    script must output 150 for 2aDemo.input
    script must output 2073315 for 2aBlackthorn.input
    script stderr line 6 should match ["DEBUG:",{"x":15,"y":-10}] for 2aDemo.input
    script stderr line 1000 should match ["DEBUG:",{"x":2063,"y":-1005}] for 2aBlackthorn.input

Finished in 2.02 seconds (user 1.52 seconds, sys 0.52 seconds)
9 examples, 0 failures
```