var xhttp = new XMLHttpRequest();

var xhrStateResults = [];

function readyStateHandler() {
    if (this.readyState == 4 && this.status == 200) {
       xhrStateResults.push(xhttp.responseText);
    }
};

function getTestData(day) {
    xhttp.open("GET", `/2020/day/${day}/input`);
    xhttp.send();
}

xhttp.onreadystatechange = readyStateHandler;

function log(val) {
    if (Window.debuggin === true) {
        console.log(val)
    }
}

// AOC 2

setTimeout(getTestData, 2000, 2);

// 1-3 a: abcde
// 1-3 b: cdefg
// 2-9 c: ccccccccc

function aoc2(vals, secondHalf) {
    let pass = 0

    for (let i = 0; i < vals.length; i++ ) {
        let capture = /(?<min>\d+)-(?<max>\d+) (?<charactor>.): (?<value>\w+)/.exec(vals[i]);
        
        if (capture == null) continue;

        let groups = capture.groups;
        let min = groups.min * 1;
        let max = groups.max * 1;
        let value = groups.value;
        let charactor = groups.charactor;

        let count = value.length - value.replaceAll(charactor, "").length;

        let valid = false;

        if (secondHalf) {
            log(`${value[min - 1]} ${value[max - 1]} // ${charactor} ${value}`);
            if (value.length < max) {
                valid = false;
                console.warn(`\n${i}\n`)
            } else {
                valid = (value[min - 1] === charactor) ^ (value[max - 1] === charactor);
            }
        } else {
            log(`${min} < ${count} < ${max} // ${charactor} ${value}`);
            valid = count >= min && count <= max;
        }

        if (valid) log(++pass);
    }

    return pass;
}

// not 256, too low.
/* 
aoc2(["1-3 a: abcde", "1-3 b: cdefg", "2-9 c: ccccccccc"], false)
aoc2(["1-3 a: abcde", "1-3 b: cdefg", "2-9 c: ccccccccc"], true)
aoc2(xhrStateResults[1].split('\n'))
aoc2(xhrStateResults[1].split('\n'), true)
Window.debuggin = true
*/

// not 741, too high: That's not the right answer; your answer is too high. If you're stuck, make sure you're using the full input data; there are also some general tips on the about page, or you can ask for hints on the subreddit. Please wait one minute before trying again. (You guessed 741.) [Return to Day 2]

//485