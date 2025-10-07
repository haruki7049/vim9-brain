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
  var Contexts: list<list<float>> = []
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

  def Update(inputs: list<float>): list<float>
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
        for j in range(this.NHiddens - 1)
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

  def BackPropagate(targets: list<float>, lRate: float, mFactor: float): float
    if len(targets) != this.NOutputs
      throw 'Error: wrong number of target values'
    endif

    var outputDeltas = utils.Vector(this.NOutputs, 0.0)
    for i in range(this.NOutputs)
      outputDeltas[i] = utils.Dsigmoid(this.OutputActivations[i]) * (targets[i] - this.OutputActivations[i])
    endfor

    var hiddenDeltas = utils.Vector(this.NHiddens, 0.0)
    for i in range(this.NHiddens)
      var e = 0.0

      for j in range(this.NOutputs)
        e += outputDeltas[j] * this.OutputWeights[i][j]
      endfor
      hiddenDeltas[i] = utils.Dsigmoid(this.HiddenActivations[i]) * e
    endfor

    for i in range(this.NHiddens)
      for j in range(this.NOutputs)
        var change = outputDeltas[j] * this.HiddenActivations[i]
        this.OutputWeights[i][j] = this.OutputWeights[i][j] + (lRate * change) + (mFactor * this.OutputChanges[i][j])
        this.OutputChanges[i][j] = change
      endfor
    endfor

    for i in range(this.NInputs)
      for j in range(this.NHiddens)
        var change = hiddenDeltas[j] * this.InputActivations[i]
        this.InputWeights[i][j] = this.InputWeights[i][j] + (lRate * change) + (mFactor * this.InputChanges[i][j])
        this.InputChanges[i][j] = change
      endfor
    endfor

    var e = 0.0

    for i in range(len(targets))
      e += 0.5 * pow(targets[i] - this.OutputActivations[i], 2.0)
    endfor

    return e
  enddef

  def Train(patterns: list<any>, iterations: number, lRate: float, mFactor: float, debug: bool): list<float>
    var errors: list<float> = repeat([0.0], iterations)

    for i in range(iterations)
      var e = 0.0
      for p in patterns
        this.Update(p[0])
        e += this.BackPropagate(p[1], lRate, mFactor)
      endfor

      errors[i] = e

      if debug && i % 1000 == 0
        echo i e
      endif
    endfor

    return errors
  enddef

  def Test(patterns: list<any>)
    for p in patterns
      echomsg p[0] "->" this.Update(p[0]) " : " p[1]
    endfor
  enddef
endclass

export def Srand(seed: number)
  utils.Srand(seed)
enddef
