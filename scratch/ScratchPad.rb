a = "((NOT((A)OR(B)))OR(NOT(C)))"

s = 1
e = 2
o = 1
while o > 0 do
	0 += 1 if a[e] == "("
	0 -= 1 if a[e] == ")"
	e += 1
end