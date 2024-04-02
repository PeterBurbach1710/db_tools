t = {'Jane', 'Miller', 'Bob', 'Smith'}

if t == nil then
  error('The array is nil')
elseif #t % 2 ~= 0 then
  error('The array does not contain an even number of elements')
else
  print(#t)
end

print("** while loop **")
i = 1
while i <= #t do
  print(t[i])
  i = i +1
end

print("** for loop 1 **")
for i=1, #t do
  print(t[i])
end

print("** for loop 2 **")
for i=#t, 1, -1 do
  print(t[i])
end

print("** repeat loop **")
repeat
  t[#t+1] = 'Exasol'
until #t >= 10

for i=1, #t do
  print(i..": "..t[i])
end

