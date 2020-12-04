# https://adventofcode.com/2020/day/4 part 2 in jq

# split("\n| "; "") # 2381 lines, 5.3 seconds to parse!

# Parse documents into objects
def parseDocuments:
    # foreach EXP as $var (INIT; UPDATE; EXTRACT)
    foreach .[] as $item (
        #INIT;
        [{},{}];

        #UPDATE
        if
            $item == ""
        then
            [{}, .[0]]
        else
            [ .[0] +
                ( $item | split(":")
                        | {"\(.[0])": .[1]} )
            , {}]
        end;

        #EXTRACT
        if
            $item == ""
        then .[1]
        else empty
        end
    )
;

# Filter documents by required fields
def filterDocs($requirements):
    # This should probably be rewriten as a select but I couldn't make it work...
    foreach $requirements[] as $requirement (
        {src: ., met: []} ;
        if
            ( .src | has($requirement.code) ) and
            ( .src[$requirement.code] | test("^(\($requirement.regex))$") )
        then {src, met: (.met + [$requirement])} else empty end;
        if (.met | length) == ($requirements | length) then .src else empty end
    )
;

gsub(" "; "\n") | split("\n")
    | [ parseDocuments
    # | debug
    | filterDocs([
        {code: "byr", description: "Birth Year",      regex: "19[2-9]\\d|200[0-2]"} # 1920 - 2002
       ,{code: "iyr", description: "Issue Year",      regex: "201[0-9]|2020"}       # 2010 - 2020
       ,{code: "eyr", description: "Expiration Year", regex: "202[0-9]|2030"}       # 2020 - 2030
       ,{code: "hgt", description: "Height",          regex: "1[5-8]\\dcm|19[0-3]cm|59in|6[0-9]in|7[0-6]in"} # 150cm - 193cm (59in-76in)
       ,{code: "hcl", description: "Hair Color",      regex: "#[0-9a-f]{6}"}        # colour in #DEADBEEF form
       ,{code: "ecl", description: "Eye Color",       regex: "amb|blu|brn|gry|grn|hzl|oth"} # colour is defined string
       ,{code: "pid", description: "Passport ID",     regex: "\\d{9}"} # 9 digit number
    #    ,{code: "cid", description: "Country ID",      regex: "."}
    ])
]
 | length
 # That's not the right answer; your answer is too high. If you're stuck, make sure you're using the full input data; there are also some general tips on the about page, or you can ask for hints on the subreddit. Please wait one minute before trying again. (You guessed 200.) [Return to Day 4]
 # 198!