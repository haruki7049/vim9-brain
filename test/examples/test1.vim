vim9script

import "../../autoload/brain.vim" as vim9_brain

var suite = themis#suite('Test for my plugin')
var assert = themis#helper('assert')

suite.ExampleTest1 = () => {
  vim9_brain.Srand(0)

  var patterns = [
    [[0.0, 0.0], [0.0]],
    [[0.0, 1.0], [1.0]],
    [[1.0, 0.0], [1.0]],
    [[1.0, 1.0], [0.0]],
  ]

  var ff: vim9_brain.Base = vim9_brain.Base.new()

  ff.Init(2, 2, 1)

  ff.Train(patterns, 1000, 0.6, 0.4, v:false)

  ff.Test(patterns)

  assert.equals(
    execute('messages'),
    '[0.0, 0.0] -> [0.045977]  :  [0.0]\n[0.0, 1.0] -> [0.9461]  :  [1.0]\n[1.0, 0.0] -> [0.944088]  :  [1.0]\n[1.0, 1.0] -> [0.073895]  :  [0.0]'
  )
}
