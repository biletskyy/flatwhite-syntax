# Assignment:
number   = 42
opposite = true

# Conditions:
number = -42 if opposite

# Functions:
square = (x) -> x * x

# Arrays:
list = [1, 2, 3, 4, 5]

# Objects:
math =
  root:   Math.sqrt
  square: square
  cube:   (x) -> x * square x

# Splats:
race = (winner, runners...) ->
  print winner, runners

# Existence:
alert "I knew it!" if elvis?

# Array comprehensions:
cubes = (math.cube num for num in list)


@app.directive 'customInput', ->
  restrict: 'E'
  scope:
    name: '@'
    errors: '='
    label: '@'
    type: '@'
  templateUrl: 'inputs/input.html'

@app.constant "$keyCodes",
  A: 65,
  B: 66,
  C: 67,
  D: 68,
  E: 69,
  F: 70

hash_assignment =
  a: 'test'

x = ->
  method_call
    with: 'arguments'
  hash_assignment_in_function =
    a: 'test'
    b: 'test'

method_that_returns_hash = ->
  hello: 'world'
  how: 'are you?'

method = (val, var1: 'test') ->
  if var1 == 'test'
    console.log val
  else
    console.log 'ERROR'

method 'test'

setTimeout ->
  method('test')
, 2000

false

fill = (container, liquid = "coffee") ->
  "Filling the #{container} with #{liquid}..."


# Eat lunch.
eat food for food in ['toast', 'cheese', 'wine']

# Fine five course dining.
courses = ['greens', 'caviar', 'truffles', 'roast', 'cake']
menu i + 1, dish for dish, i in courses

# Health conscious meal.
foods = ['broccoli', 'spinach', 'chocolate']
eat food for food in foods when food isnt 'chocolate'


class Animal
  constructor: (@name) ->

  move: (meters) ->
    alert @name + " moved #{meters}m."

class Snake extends Animal
  move: ->
    alert "Slithering..."
    super 5

class Horse extends Animal
  move: ->
    alert "Galloping..."
    super 45

sam = new Snake "Sammy the Python"
tom = new Horse "Tommy the Palomino"

sam.move()
tom.move()


author = "Wittgenstein"
quote  = "A picture is a fact. -- #{ author }"

sentence = "#{ 22 /  } is a decent approximation of π"

# Econ 101
if this.studyingEconomics
  buy()  while supply > demand
  sell() until supply > demand

# Nursery Rhyme
num = 6
lyrics = while num -= 1
  "#{num} little monkeys, jumping on the bed.
    One fell out and bumped his head."

for filename in list
  do (filename) ->
    fs.readFile filename, (err, contents) ->
      compile filename, contents.toString()

launch() if ignition is on

volume = 10 if band isnt SpinalTap

letTheWildRumpusBegin() unless answer is no

if car.speed < limit then accelerate()

winner = yes if pick in [47, 92, 13]

print inspect "My name is #{@name}"

String::dasherize = ->
  this.replace /_/g, "-"

Account = (customer, cart) ->
  @customer = customer
  @cart = cart

  $('.shopping_cart').on 'click', (event) =>
    @customer.purchase @cart

score = 76
grade = switch
  when score < 60 then 'F'
  when score < 70 then 'D'
  when score < 80 then 'C'
  when score < 90 then 'B'
  else 'A'
# grade == 'C'


module.exports =
class Model
  @resetNextInstanceId: -> nextInstanceId = 1

  alive: true

  constructor: (params) ->
    @assignId(params?.id)

  assignId: (id) ->
    @id ?= id ? nextInstanceId++
    nextInstanceId = id + 1 if id >= nextInstanceId

  destroy: ->
    return unless @isAlive()
    @alive = false
    @destroyed?()

  isAlive: -> @alive

  isDestroyed: -> not @isAlive()
