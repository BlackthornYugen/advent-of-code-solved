# shellcheck disable=SC1073,SC2148
Describe '2021 jq advent of code'
  Parameters
    1aDemo       "7"
    1aPants      "7"
    1aBlackthorn "7"
  End

  It "js should say $2 for $1"
    When run node "2021/js/$1.js" -- "2021/$1.input"
    The output should eq "$2"
  End
End