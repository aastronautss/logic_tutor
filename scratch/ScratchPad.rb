a = "((NOT((A)OR(B)))OR(NOT(C)))"
b = "(NOT((A)OR(B)))"
c = "NOT(C)"

def subexpressions(str)
	arr = []

	first = next_sub(str)
	arr.push(str[first[0]..first[1]])

	if second = next_sub(str, first[1], first[1])
		arr.push(str[second[0]..second[1]])
	end

	arr
end

def next_sub(str, start = 1, finish = 1)
	until str[start] == "(" || start == str.length do
		start += 1
	end

	return nil if start == str.length

	finish = start # Initialize counters
	open_paren = 1

	while open_paren > 0 do
		finish += 1
		open_paren += 1 if str[finish] == "("
		open_paren -= 1 if str[finish] == ")"
	end

	[start, finish]
end

print subexpressions(a)
puts ''
print subexpressions(b)
puts ''
print subexpressions(c)