class LogicFormula
  def initialize(str)
    str.gsub!(/\s+/, '')
  end

  def is_wff?
  end

  def evaluate(interp = Interpretation.new)
  end

  def to_s
  end

  def main_connective
    @main_connective.value
  end

  class FormulaNode
    attr_accessor :value, :left, :right

    def initialize(value, left = nil, right = nil)
      @value = value
      @left = left
      @right = right
    end

    def is_wf?
    end

    def evaluate_helper(interp = Interpretation.new)
    end

    def string_helper
    end
  end

  class Connective
    attr_accessor :symbol

    def initialize(symbol, eval_proc = Proc.new { |l, r, i| false })
      @symbol = symbol
      @eval_proc = eval_proc
    end

    def evaluate_helper(left, right, interp)
      @eval.call(left, right, interp)
    end
  end

  class UnaryConnective < Connective
  end

  class BinaryConnective < Connective
  end
end

# An Interpretation assigns truth values to atomic sentences.
class Interpretation
  # @vals is a hash where the keys are the sentence letters, and the values are either true or false.
  attr_accessor :values

  def initialize(values = Hash.new(false))
    @values = values
  end
end