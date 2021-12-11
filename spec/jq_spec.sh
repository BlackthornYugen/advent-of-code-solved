# shellcheck disable=SC1073,SC2148
Describe '2021 jq advent of code 1a'
  Parameters
    1aDemo       "7"
    1aPants      "1692"
    1aBlackthorn "1475"
  End

  It "script must output $2 for 2021/$1.input"
    When run jq --slurp --from-file "2021/jq/1.jq" "2021/$1.input"
    The line 1 of stderr should match pattern '*DEBUG*window":[[]*[]],*hits":0*'
    The line 2 of stderr should match pattern '*DEBUG*window":[[]*[]],*hits":*'
    The output should eq "$2"
  End
End

Describe '2021 jq advent of code 1b'
  Parameters
    1aDemo "5"
    1aBlackthorn "1516"
  End

  It "script must output $2 for 2021/$1.input"
    When run jq --slurp --arg window 3 --from-file "2021/jq/1.jq" "2021/$1.input"
    The line 1 of stderr should match pattern '*DEBUG*window":[[]*[]],*hits":0*'
    The line 2 of stderr should match pattern '*DEBUG*window":[[]*,*[]],*hits":0*'
    The line 3 of stderr should match pattern '*DEBUG*window":[[]*,*,*[]],*hits":0*'
    The line 4 of stderr should match pattern '*DEBUG*window":[[]*,*,*[]],*hits":*'
    The output should eq "$2"
  End
End