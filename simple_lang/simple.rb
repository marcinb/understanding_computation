module SimpleLang
  def self.test
    Machine.new(
      LessThan.new(
        Add.new(
          Multiply.new(Variable.new(:x), Number.new(2)),
          Multiply.new(Variable.new(:y), Number.new(2)),
        ),
        Multiply.new(Number.new(3), Number.new(4))
      ), {x: Number.new(2), y: Number.new(1)}).run

  end

  class Machine < Struct.new(:expression, :environment)
    def step
      self.expression = expression.reduce(environment)
    end

    def run
      while expression.reductible?
        puts expression
        step
      end
      puts expression
    end
  end

  module Reductible
    def reductible?
      true
    end

    def reduce(expression)
      raise NotImplementedError
    end
  end

  module Irreductible
    def reductible?
      false
    end
  end

  class Number < Struct.new(:value)
    include Irreductible

    def to_s
      "#{value}"
    end
  end

  class Add < Struct.new(:left, :right)
    include Reductible

    def to_s
      "#{left} + #{right}"
    end

    def reduce(expression)
      if left.reductible?
        Add.new(left.reduce(expression), right)
      elsif right.reductible?
        Add.new(left, right.reduce(expression))
      else
        Number.new(left.value + right.value)
      end
    end
  end

  class Multiply < Struct.new(:left, :right)
    include Reductible

    def to_s
      "#{left} * #{right}"
    end

    def reduce(expression)
      if left.reductible?
        Multiply.new(left.reduce(expression), right)
      elsif right.reductible?
        Multiply.new(left, right.reduce(expression))
      else
        Number.new(left.value * right.value)
      end
    end
  end

  class Boolean < Struct.new(:value)
    include Irreductible

    def to_s
      value.to_s
    end
  end

  class LessThan < Struct.new(:left, :right)
    include Reductible

    def to_s
      "#{left} < #{right}"
    end

    def reduce(expression)
      if left.reductible?
        LessThan.new(left.reduce(expression), right)
      elsif right.reductible?
        LessThan.new(left, right.reduce(expression))
      else
        Boolean.new(left.value < right.value)
      end
    end
  end

  class Variable < Struct.new(:name)
    include Reductible

    def to_s
      "#{name}"
    end

    def reduce(environment)
      environment[name]
    end
  end
end

puts SimpleLang.test
