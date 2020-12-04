# https://adventofcode.com/2020/day/4 part 1 in jq

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
            ( .src[$requirement.code] | test($requirement.regex) )
        then {src, met: (.met + [$requirement])} else empty end;
        if (.met | length) == ($requirements | length) then .src else empty end
    )
;

gsub(" "; "\n") | split("\n")
    | [ parseDocuments
    # | debug
    | filterDocs([
        {code: "byr", description: "Birth Year",      regex: "."}
       ,{code: "iyr", description: "Issue Year",      regex: "."}
       ,{code: "eyr", description: "Expiration Year", regex: "."}
       ,{code: "hgt", description: "Height",          regex: "172cm"}
       ,{code: "hcl", description: "Hair Color",      regex: "."}
       ,{code: "ecl", description: "Eye Color",       regex: "blu"}
       ,{code: "pid", description: "Passport ID",     regex: "."}
       ,{code: "cid", description: "Country ID",      regex: "."}
    ])
]
 | length, .