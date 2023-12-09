const fs = require('fs')

const depths = fs.readFileSync('./input.txt')
  .toString()
  .split('\n')
  .map(input => Number(input))

function getIncreaseCount(depths) {
  let increases = 0
  depths.reduce((previous, next) => {
    if (previous < next) {
      increases++
    }
    return next;
  })
  return increases
}

console.log({ increases: getIncreaseCount(depths) })


function getSumOfWindow(depths, start, count) {
  if (depths.length - start >= count) {
    return depths
      .slice(start, start + count)
      .reduce((sum, current) => sum + current)
  }
}

const WINDOW_SIZE = 3

const windowSums = depths.reduce((windowSums, _, index) => {
  const sum = getSumOfWindow(depths, index, WINDOW_SIZE)
  if (sum == null) {
    return windowSums
  }
  return [...windowSums, sum]
}, [])

console.log({ windowIncreases: getIncreaseCount(windowSums) })
