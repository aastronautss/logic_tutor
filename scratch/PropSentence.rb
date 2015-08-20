# MolecularSentence is a wrapper class for a tree of SentenceNodes with the main connective of the sentence as the root. This provides various utilities for 
class MolecularSentence
	# #initialize takes a string in the form of a formula in sentential logic and stores its components as nodes in our tree.
	def initialize(str, symbols = { 'NOT'  		=> 'NOT',
																	'AND'  		=> 'AND',
																	'OR'			=> 'OR',
																	'IMPLIES'	=> 'IMPLIES',
																	'IFF'			=> 'IFF' })
		str.gsub!(/\s+/, '')
		symbols.each { |key, value| str.gsub!(value, key) }
		@main_connective = populate_tree(str)
	end

	# #is_wff? returns true if the object is a well-formed formula. False otherwise.
	def is_wff?
		@main_connective.is_wf?
	end

	# #evaluate calls the SentenceNode#evaluate method for @main_connective and returns its value.
	def evaluate(interp = Interpretation.new)
		raise 'Not a well-formed formula.' unless is_wff?
		@main_connective.evaluate_helper(interp)
	end

	def to_s
		str = @main_connective.string_helper
		str.sub!(/^\(/, '')
		str.sub!(/\)$/, '')
		str.gsub!(/AND/, ' AND ')
		str.gsub!(/OR/, ' OR ')
		str.gsub!(/IMPLIES/, ' IMPLIES ')
		str.gsub!(/IFF/, ' IFF ')
		str.gsub!(/NOT/, 'NOT ')
		str.gsub!(/\((\w+)\)/, '\1')
		str.gsub!(/NOT \(/, 'NOT(')
		str
	end

	def to_s_custom(options = { 'NOT'			=> '~',
															'AND'			=> '&',
															'OR'			=> 'v',
															'IMPLIES'	=> '->',
															'IFF'			=> '<->' })
		str = to_s
		options.each { |key, value| str.gsub!(key, value) }
		str
	end

	private

	# #subexpressions returns an array: index 0 and 2 are the flanking subexpressions, while index 1 is the value of the node-to-be. Just as in the structure of the binary tree, a node is atomic if the flanking expressions are nil.
	def subexpressions(str)
		if next_sub(str, 0) == [0, str.length - 1] # If there are outer parentheses
			str.sub!(/^\(/, '')
			str.sub!(/\)$/, '') # Strip enclosing parentheses
		end

		arr = [nil, '', nil] # Initializes return variable (as a leaf node)
		indices = next_sub(str, 0) # Take the indices of the next outer set of parentheses. "NOT((A)OR(B))" would return [3, 12]

		if indices.nil? # #next_sub will return nil if it doesn't find a subexpression
			arr[1] = str	# So we add the value to the array and call it a day.
		elsif str[0..2] == 'NOT' # If the first thing outside of the parentheses is NOT we only need to run next_sub once.
			arr[1] = 'NOT'
			arr[2] = str[indices[0]..indices[1]]
		else
			arr[0] = str[indices[0]..indices[1]]
			letters = [] # Here we find the connective between the two subexpressions.
			n = indices[1] + 1
			until str[n] == '('
				letters << str[n]
				n += 1
			end
			arr[1] = letters.join('')
			indices = next_sub(str, n)
			arr[2] = str[indices[0]..indices[1]]
		end
		arr
	end

	# #next_sub is a helper method for #subexpressions. Finds the next subexpression in a propositional expression starting at the given indices.
	def next_sub(str, start = 1)
		until str[start] == '(' || start == str.length
			start += 1
		end

		return nil if start == str.length

		finish = start # Initialize counters
		open_paren = 1

		while open_paren > 0 do
			finish += 1
			open_paren += 1 if str[finish] == '('
			open_paren -= 1 if str[finish] == ')'
		end

		[start, finish]
	end

	def populate_tree(str)
		arr = subexpressions(str)
		node = SentenceNode.new(arr[1])
		node.left = populate_tree(arr[0]) unless arr[0].nil?
		node.right = populate_tree(arr[2]) unless arr[2].nil?

		node
	end

	class SentenceNode
		# @value is a String, which may be given an atomic sentence with any name, or a connective AND, OR, IMPLIES, IFF, and NOT.
		# @left and @right are SentenceNodes which can be evaluated recursively.
		attr_accessor :value, :left, :right

		def initialize(v, l = nil, r = nil)
			@value = v
			@left = l
			@right = r
		end

		# #evaluate returns the truth value of
		def evaluate_helper(interp = Interpretation.new)	# interp is an interpretation.
			l = @left.evaluate_helper(interp) unless @left.nil? # Evaluate left child.
			r = @right.evaluate_helper(interp) unless @right.nil? # Evaluate right child.

			case @value
				when 'NOT'
					return true if !r
				when 'AND'
					return true if l && r
				when 'OR'
					return true if l || r
				when 'IMPLIES'
					return true if !l || r
				when 'IFF'
					return true if l == r
				else
					return interp.values[@value]
			end
			false
		end

		def is_wf?
			case @value
				when 'NOT'
					false unless @left.nil? && @right.is_wf?
				when 'AND' || 'OR' || 'IMPLIES' || 'IFF'
					false unless @left.is_wf? && @right.is_wf?
				else
					true
			end
		end

		# #string_helper is a helper class for MolecularSentence to make the recursion easier to do. A sentence like ~Av~B winds up like ((NOT(A))OR(NOT(B))). MolecularSentence#to_s will make it look better.
		def string_helper
			str = '('
			str = str + @left.string_helper unless @left.nil?
			str = str + @value
			str = str + @right.string_helper unless @right.nil?
			str = str + ')'
		end
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

# Related to Interpretation, Tanslation assigns English statements (values in @assignments) to the atomic symbols (keys in @assignments).
class Translation
	attr_accessor :assignments

	def initialize(hash = Hash.new(''))
		@assignments = hash
	end
end

s = MolecularSentence.new('((NOT((A)OR(B)))OR(NOT(C)))')
puts s.to_s
puts s.to_s_custom
puts "Well-formed formula: " + s.is_wff?.to_s
puts "Evaluates to: " + s.evaluate.to_s