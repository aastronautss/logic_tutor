# MolecularSentence is a wrapper class for a tree of SentenceNodes with the main connective of the sentence as the root. This provides various utilities for 
class MolecularSentence
	attr_accessor :main_connective

	# #initialize takes a string in the form of a formula in sentential logic and stores its components as nodes in our tree.
	def initialize(string)
		if string.nil?
			@main_connective = SentenceNode.new
		else
		end
	end

	# #is_wff? returns true if the object is a well-formed formula. False otherwise.
	def is_wff?
	end

	# #evaluate calls the SentenceNode#evaluate method for @main_connective and returns its value.
	def evaluate
		@main_connective.evaluate
	end

	def to_s
		start = @main_connective.to_s

		start.slice!(0)
		start.slice!(-1) # Remove open and close parens
	end

	def to_s_custom(options = { "NOT"			=> "~",
															"AND"			=> "&",
															"OR"			=> "v",
															"IMPLIES"	=> "->",
															"IFF"			=> "<->"})
		str = self.to_s
		options.each do |k, v|
			str.gsub!(k, v)
		end
	end
end

class SentenceNode
	# @value is a String, which may be given an atomic sentence with any name, or a connective AND, OR, IMPLIES, IFF, and NOT.
	# @left and @right are SentenceNodes which can be evaluated recursively.
	attr_accessor :value, :left, :right

	def initialize(v, r = nil, l = nil)
		@value = v
		@right = r
		@left = l
	end

	# #evaluate returns the truth value of 
	def evaluate(interp = Interpretation.new)	# interp is an interpretation.
		l = @left.evaluate(interp) # Evaluate left child.
		r = @right.evaluate(interp) # Evaluate right child.
		case @value
			when "NOT"
				!r
			when "AND"
				l && r
			when "OR"
				l || r
			when "IMPLIES"
				!l || r
			when "IFF"
				(l && r) || (!l && !r)
			else
				interp.vals[@value]
		end
	end

	# #english is a helper class for MolecularSentence to make the recursion easier to do. A sentence like ~Av~B winds up like ((NOT(A))OR(NOT(B))). MolecularSentence#to_s will make it look better.
	def to_s
		str = "("
		str += @left.to_str unless @left.nil?
		str += @value
		str += @right.to_str unless @right.nil?
		str += ")"
	end
end

# An Interpretation assigns truth values to atomic sentences.
class Interpretation
	# @vals is a hash where the keys are the sentence letters, and the values are either true or false.
	attr_accessor :values

	def initialize(hash = {})
		@values = hash
	end
end

# Related to Interpretation, Tanslation assigns English statements (values in @assignments) to the atomic symbols (keys in @assignments).
class Translation
	attr_accessor :assignments

	def initialize(hash = {})
		@assignments = hash
	end
end