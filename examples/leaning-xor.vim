vim9script

# Tested with Vim 9.1.905

import "../autoload/brain.vim" as vim9_brain

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
