# shellcheck disable=SC1073,SC2148
Describe '2021 jq advent of code'
  Parameters
    1aDemo "7"
    1aPants "1692"
    1aBlackthorn "1475"
  End

  It "1a.jq should say $2 for $1"
    When run jq --slurp -c --from-file "2021/jq/1a.jq" "2021/$1.input"
    The output should eq "$2"
  End
End