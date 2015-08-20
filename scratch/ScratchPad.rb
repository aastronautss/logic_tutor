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

end

# Tester method calls

a = '((NOT((A)OR(B)))OR(NOT(C)))'
b = '(NOT((A)OR(B)))'
c = 'NOT(C)'
d = '(NOT((A)))'
e = '(A)'
f = 'A'

p subexpressions(a)
p subexpressions(b)
p subexpressions(c)
p subexpressions(d)
p subexpressions(e)
p subexpressions(f)
