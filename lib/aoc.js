const fs = require('fs')

exports.getTestData = function getTestData(path, callback) {
    // Run second
    fs.readFile(path, 'utf8' , (err, data) => {
        if (err) {
          console.error(err)
          return
        }

        callback(data)
    })
}