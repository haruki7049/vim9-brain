vim9script

export var seed: number = 0

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
  return (b - a) * (rand() % 65536 / 65536.0) + a
enddef

export def Sigmoid(x: float): float
  return 1.0 / (1.0 + exp(-x))
enddef

export def Srand(s: number)
  seed = s
enddef

export def Dsigmoid(y: float): float
  return y * (1.0 - y)
enddef
