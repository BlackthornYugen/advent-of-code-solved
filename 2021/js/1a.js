const aocLib = require('../../lib/aoc')

function doTheSTuff(data) { // data = '1\n2\n3\n4'
    let dataArray = data.split('\n')
    let intArray = dataArray.map((_) => parseInt(_, 10));
    let dataLength = dataArray.length // dataLength = ##
    let solution = 0

    for (let dataCount = 0; dataCount < dataLength -1; dataCount++ ){
        if (intArray[dataCount] < intArray[dataCount+1]) {
            if (dataArray[dataCount] < dataArray[dataCount+1]) {
                solution++
            } else {
                debugger
            }
        }
    }

    console.log(solution); // stupid internets // Stupid internets
}

// Run first // they are talking about part #2
aocLib.getTestData(process.argv[3], doTheSTuff);

