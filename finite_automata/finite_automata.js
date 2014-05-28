function FiniteAutomataRun(startState, acceptStates, ruleBook) {
  this.startState = startState
  this.acceptStates = acceptStates
  this.ruleBook = ruleBook

  this.accepts = function(string) {
    var automata = new FiniteAutomata(this.startState, this.acceptStates, this.ruleBook)
    automata.processString(string)
    return automata.accepting()
  }
}

function FiniteAutomata(currentState, acceptStates, ruleBook) {
  this.currentState = currentState
  this.acceptStates = acceptStates
  this.ruleBook = ruleBook

  this.processString = function(string) {
    var self = this

    string.split('').forEach(function(character) {
      self.processCharacter(character)
    })
  }

  this.processCharacter = function(character) {
    this.currentState = ruleBook.nextState(this.currentState, character)
    console.log("current state is: " + this.currentState)
  }

  this.accepting = function() {
    var self = this

    return this.acceptStates.some(function(state) {
      return state == self.currentState
    })
  }
}

function FARuleBook(rules) {
  this.rules = rules

  this.nextState = function(state, character) {
    next = this.ruleFor(state, character).nextState
    console.log("next state is: " + next)
    return next
  }

  this.ruleFor = function(state, character) {
    return this.rules.filter(function(rule) {
      return rule.appliesTo(state, character)
    })[0]
  }
}

function FARule(state, character, nextState) {
  this.state = state
  this.character = character
  this.nextState = nextState

  this.appliesTo = function(state, character) {
    return state == this.state && character == this.character
  }

  this.toString = function() {
    return "state: " + this.state + " ('" + this.character + "' -> " + this.nextState + ")"
  }
}

