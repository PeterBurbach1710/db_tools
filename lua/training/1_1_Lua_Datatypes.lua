-- lua is case sensitive!

-- this is a comment

x = nil   -- nil
b = false -- boolean
n = 5     -- number

-- strings either '' or "" or [[ ]]
-- [[]] does not need to be escaped!
s = 'this'.." or "..[[that way! "That's nice!"]]
e = 'it\'s not nice'

-- tables/ arrays
a = {}
a = { [1] = 'h1', [2] = 'hello', [3] = 'you' }
a = { 'h1', 'hello', 'you' }  -- same as abvove... in that case automatically listed with key 1,2,3

t = { ["FIRSTNAME"] = "Jane" } -- key is a string
t = { FIRSTNAME = "Jane" }  -- same as above

-- exasol added extra datatypes, you can only use within exasol
-- NULL, null, decimal(5.89)

function f(x) return x*x end

print(#s) -- counts the length of the string
          -- result 32
print(#a) -- counts the length of the array
          -- result 3

print(#t) -- does not work on arbitrary table
          -- result 0


