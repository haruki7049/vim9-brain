vim9script

import "../autoload/brain.vim" as vim9_brain

var suite = themis#suite('Test for my plugin')
var assert = themis#helper('assert')

suite.Vector = () => {
  assert.equals(
    vim9_brain.Vector(5, 4.0),
    [4.0, 4.0, 4.0, 4.0, 4.0]
  )
  assert.equals(
    vim9_brain.Vector(9, 1.0),
    [1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0]
  )
  assert.equals(
    vim9_brain.Vector(1, 10.0),
    [10.0]
  )
}

suite.Matrix = () => {
  assert.equals(
    vim9_brain.Matrix(4, 3),
    [
      [0.0, 0.0, 0.0],
      [0.0, 0.0, 0.0],
      [0.0, 0.0, 0.0],
      [0.0, 0.0, 0.0]
    ]
  )
  assert.equals(
    vim9_brain.Matrix(3, 2),
    [
      [0.0, 0.0],
      [0.0, 0.0],
      [0.0, 0.0],
    ]
  )
  assert.equals(
    vim9_brain.Matrix(10, 2),
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
