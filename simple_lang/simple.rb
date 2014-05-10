module SimpleLang
  def self.test
    Machine.new(
      Add.new(
        Multiply.new(Number.new(2), Number.new(2)),
        Multiply.new(Number.new(2), Number.new(2)),
      )
    ).run
  end

  class Machine < Struct.new(:expression)
    def step
      self.expression = expression.reduce
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

    def reduce
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

    def reduce
      if left.reductible?
        Add.new(left.reduce, right)
      elsif right.reductible?
        Add.new(left, right.reduce)
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

    def reduce
      if left.reductible?
        Multiply.new(left.reduce, right)
      elsif right.reductible?
        Multiply.new(left, right.reduce)
      else
        Number.new(left.value * right.value)
      end
    end
  end
end

puts SimpleLang.test
