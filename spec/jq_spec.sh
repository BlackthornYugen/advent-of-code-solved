# shellcheck disable=SC1073,SC2148
Describe '2021 jq advent of code'
  Describe "1a"
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

  Describe '1b'
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

  Describe '2a'
    Parameters
      # File      # Result  # Err Line # Should match
      2aDemo       "150"     6       '["DEBUG:",{"x":15,"y":-10}]'
      2aBlackthorn "2073315" 1000    '["DEBUG:",{"x":2063,"y":-1005}]'
    End

    It "script must output $2 for $1.input"
      When run jq --slurp --raw-input --from-file "2021/jq/2a.jq" "2021/$1.input"
      The stderr should match pattern "*DEBUG*"
      The output should eq "$2"
      The status should be success
    End

    It "script stderr line $3 should match $4 for $1.input"
      When run jq --slurp --raw-input --from-file "2021/jq/2a.jq" "2021/$1.input"
      The stderr line "$3" should eq "$4"
      The output should be valid number
      The status should be success
    End
  End
  
  Describe '2b'
    Parameters
      # File      # Result  # Err Line # Should match
      2aDemo       "900"        6       '["DEBUG:",{"x":15,"y":-60,"aim":-10}]'
      2aBlackthorn "1840311528" 1000    '["DEBUG:",{"x":2063,"y":-892056,"aim":-1005}]'
    End

    It "script must output $2 for $1.input"
      When run jq --slurp --raw-input --from-file "2021/jq/2b.jq" "2021/$1.input"
      The stderr should match pattern "*DEBUG*"
      The output should eq "$2"
      The status should be success
    End

    It "script stderr line $3 should match $4 for $1.input"
      When run jq --slurp --raw-input --from-file "2021/jq/2b.jq" "2021/$1.input"
      The stderr line "$3" should eq "$4"
      The output should be valid number
      The status should be success
    End
  End
End