vim9script

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

    this.InputActivations = Vector(this.NInputs, 1.0)
    this.HiddenActivations = Vector(this.NHiddens, 1.0)
    this.OutputActivations = Vector(this.NOutputs, 1.0)

    this.InputWeights = Matrix(this.NInputs, this.NHiddens)
    this.OutputWeights = Matrix(this.NHiddens, this.NOutputs)

    for i in range(this.NInputs)
      for j in range(this.NHiddens)
        this.InputWeights[i][j] = Random(-1.0, 1.0)
      endfor
    endfor

    for i in range(this.NHiddens)
      for j in range(this.NOutputs)
        this.OutputWeights[i][j] = Random(-1.0, 1.0)
      endfor
    endfor

    this.InputChanges = Matrix(this.NInputs, this.NHiddens)
    this.OutputChanges = Matrix(this.NHiddens, this.NOutputs)
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

      this.HiddenActivations[i] = Sigmoid(sum)
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

      this.OutputActivations[i] = Sigmoid(sum)
    endfor

    return this.OutputActivations
  enddef
endclass

# Creates two-dimensional array, as: [[0.0, 0.0], [0.0, 0.0]]
# i -> line count
# j -> column count
export def Matrix(i: number, j: number): list<list<float>>
  var column_list: list<float> = repeat([0.0], i)
  var result: list<list<float>> = []

  for _ in column_list
    add(result, repeat([0.0], j))
  endfor

  return result
enddef

# Creates one-dimensional array, as: [5.0, 5.0, 5.0]
# i -> column count
# fill -> A number what you want to fill
export def Vector(i: number, fill: float): list<float>
  return map(repeat([0.0], i), (key, value) => fill)
enddef

export def Random(a: float, b: float): float
  return (b - a) * rand() + a
enddef

export def Sigmoid(x: float): float
  return 1.0 / (1.0 + exp(-x))
enddef
