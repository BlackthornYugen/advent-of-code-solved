
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

// AOC 1

setTimeout(getTestData, 1000, 1);


function aoc1(vals, secondHalf) {

    for (let i = 0; i < vals.length - 3; i++ ) {
        let x = 1 * vals[i];

        for (let j = i + 1; j < vals.length - 2; j++) {
            let y = 1 * vals[j];

            if (!secondHalf) {

                if ( (x + y) === 2020 ) {
                    log (`i: ${i} j: ${j} x: ${x} y ${y}`)
                    return (x * y);
                }

                continue;
            }
    
            for (let k = j + 1; k < vals.length - 1; k++) {
                let z = 1 * vals[k];

                if ( (x + y + z) === 2020 ) {
                    log (`i: ${i} j: ${j} k: ${k} x: ${x} y ${y} z ${z}`)
                    return (x * y * z);
                }
            }
        }
    }
}

/*
aoc1(xhrStateResults[0].split('\n'), false)
aoc1(xhrStateResults[0].split('\n'), true)
*/
