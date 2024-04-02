s = "database"

print(string.len(s))
print(string.lower(s))
print(string.upper(s))
print(string.rep(s,3))

print(s:len())
print(s:lower())
print(s:upper())
print(s:rep(3))

print(s:sub(5))
print(s:sub(-2))

print(s:sub(3,5)) -- !!! start and end position!!! 3rd to 5th character


print(math.abs(-5))
print(math.min(2,54,6,1,4))
print(math.max(2,54,6,1,4))
print(math.floor(3.2342))

math.randomseed(os.time())
print(math.random())

