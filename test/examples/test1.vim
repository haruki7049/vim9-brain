vim9script

import "../../autoload/brain.vim" as vim9_brain

var suite = themis#suite('Test for my plugin')
var assert = themis#helper('assert')

suite.ExampleTest1 = () => {
  var base: vim9_brain.Base = vim9_brain.Base.new()
  vim9_brain.srand(0)

  var patterns = [
    [[0.0, 0.0], [0.0]],
    [[0.0, 1.0], [1.0]],
    [[1.0, 0.0], [1.0]],
    [[1.0, 1.0], [0.0]],
  ];

  var ff = vim9_brain.new_feed()

  ff.Init(2, 2, 1)

  ff.Train(patterns, 1000, 0.6, 0.4, v:false)

  ff.Test(patterns)
}
