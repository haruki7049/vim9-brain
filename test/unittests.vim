vim9script

import "../autoload/utils.vim" as utils

var suite = themis#suite('Test for my plugin')
var assert = themis#helper('assert')

suite.Vector = () => {
  assert.equals(
    utils.Vector(5, 4.0),
    [4.0, 4.0, 4.0, 4.0, 4.0]
  )
  assert.equals(
    utils.Vector(9, 1.0),
    [1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0]
  )
  assert.equals(
    utils.Vector(1, 10.0),
    [10.0]
  )
}

suite.Matrix = () => {
  assert.equals(
    utils.Matrix(4, 3),
    [
      [0.0, 0.0, 0.0],
      [0.0, 0.0, 0.0],
      [0.0, 0.0, 0.0],
      [0.0, 0.0, 0.0]
    ]
  )
  assert.equals(
    utils.Matrix(3, 2),
    [
      [0.0, 0.0],
      [0.0, 0.0],
      [0.0, 0.0],
    ]
  )
  assert.equals(
    utils.Matrix(10, 2),
    [
      [0.0, 0.0],
      [0.0, 0.0],
      [0.0, 0.0],
      [0.0, 0.0],
      [0.0, 0.0],
      [0.0, 0.0],
      [0.0, 0.0],
      [0.0, 0.0],
      [0.0, 0.0],
      [0.0, 0.0],
    ]
  )
}
