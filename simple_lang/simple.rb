module SimpleLang
  def self.test
    Machine.new(
      Assign.new(
        :y,
        Multiply.new(
          Variable.new(:x),
          Add.new(Number.new(2), Variable.new(:x))
        )
      ),
      {x: Number.new(2)}
    ).run
  end

  class Machine < Struct.new(:statement, :environment)
    def step
      self.statement, self.environment = statement.reduce(environment)
    end

    def run
      while statement.reductible?
        log
        step
      end
      log
    end

    private
    def log
      puts "#{statement}, #{environment}"
    end
  end

  module Reductible
    def reductible?
      true
    end

    def reduce(environment)
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

    def reduce(environment)
      if left.reductible?
        Add.new(left.reduce(environment), right)
      elsif right.reductible?
        Add.new(left, right.reduce(environment))
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

    def reduce(environment)
      if left.reductible?
        Multiply.new(left.reduce(environment), right)
      elsif right.reductible?
        Multiply.new(left, right.reduce(environment))
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

    def reduce(environment)
      if left.reductible?
        LessThan.new(left.reduce(environment), right)
      elsif right.reductible?
        LessThan.new(left, right.reduce(environment))
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

  class DoNothing
    include Irreductible

    def to_s
      "do-nothing"
    end

    def ==(other)
      other.instance_of?(DoNothing)
    end
  end

  class Assign < Struct.new(:name, :expression)
    include Reductible

    def to_s
      "#{name} = #{expression}"
    end

    def reduce(environment)
      if expression.reductible?
        [Assign.new(name, expression.reduce(environment)), environment]
      else
        [DoNothing.new, environment.merge(name => expression)]
      end
    end
  end

end

puts SimpleLang.test
