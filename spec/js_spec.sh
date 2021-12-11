# shellcheck disable=SC1073,SC2148
Describe '2021 js advent of code'
  Parameters
    1aDemo       "7"
    1aPants      "1692"
    1aBlackthorn "1475"
  End

  It "script must output $2 for $1"
    When run node "2021/js/1a.js" -- "2021/$1.input"
    The output should eq "$2"
  End
End