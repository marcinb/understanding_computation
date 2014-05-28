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

function FARuleBook(rules) {
  this.rules = rules

  this.nextState = function(state, character) {
    return this.ruleFor(state, character).nextState
  }

  this.ruleFor = function(state, character) {
    return this.rules.filter(function(rule) {
      return rule.appliesTo(state, character)
    })[0]
  }
}
