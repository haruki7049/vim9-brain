vim9script

import "./utils.vim" as utils

export class Base
  var NInputs: number = 0
  var NHiddens: number = 0
  var NOutputs: number = 0
  var Regression: bool = false
  var InputActivations: list<float> = []
  var HiddenActivations: list<float> = []
  var OutputActivations: list<float> = []
  var Contexts: list<string> = []
  var InputWeights: list<list<float>> = []
  var OutputWeights: list<list<float>> = []
  var InputChanges: list<list<float>> = []
  var OutputChanges: list<list<float>> = []

  def Init(inputs: number, hiddens: number, outputs: number)
    this.NInputs = inputs + 1
    this.NHiddens = hiddens + 1
    this.NOutputs = outputs

    this.InputActivations = utils.Vector(this.NInputs, 1.0)
    this.HiddenActivations = utils.Vector(this.NHiddens, 1.0)
    this.OutputActivations = utils.Vector(this.NOutputs, 1.0)

    this.InputWeights = utils.Matrix(this.NInputs, this.NHiddens)
    this.OutputWeights = utils.Matrix(this.NHiddens, this.NOutputs)

    for i in range(this.NInputs)
      for j in range(this.NHiddens)
        this.InputWeights[i][j] = utils.Random(-1.0, 1.0)
      endfor
    endfor

    for i in range(this.NHiddens)
      for j in range(this.NOutputs)
        this.OutputWeights[i][j] = utils.Random(-1.0, 1.0)
      endfor
    endfor

    this.InputChanges = utils.Matrix(this.NInputs, this.NHiddens)
    this.OutputChanges = utils.Matrix(this.NHiddens, this.NOutputs)
  enddef

  def Update(inputs: number)
    if len(inputs) != this.NInputs - 1
      throw 'Error: wrong number of inputs'
    endif

    for i in range(this.NInputs - 1)
      this.InputActivations[i] = inputs[i]
    endfor

    for i in range(this.NHiddens - 1)
      var sum = 0.0

      for j in range(this.NInputs)
        sum += this.InputActivations[j] * this.InputWeights[j][i]
      endfor

      for k in range(len(this.Contexts))
        for j in range()
          sum += this.Contexts[k][j]
        endfor
      endfor

      this.HiddenActivations[i] = utils.Sigmoid(sum)
    endfor

    if len(this.Contexts) > 0
      for i in reverse(range(1, len(this.Contexts) - 1))
        this.Contexts[i] = this.Contexts[i - 1]
      endfor

      this.Contexts[0] = this.HiddenActivations
    endif

    for i in range(this.NOutputs)
      var sum = 0.0

      for j in range(this.NHiddens)
        sum += this.HiddenActivations[j] * this.OutputWeights[j][i]
      endfor

      this.OutputActivations[i] = utils.Sigmoid(sum)
    endfor

    return this.OutputActivations
  enddef
endclass
