-- array = lua table with increasing numeric key
a = { 'one', 'two' }

a[#a+1] = 'three'

table.insert(a, 'four')
table.insert(a, 1, 'zero')

removed_element = table.remove(a, 3)
removed_element = table.remove(a)     -- remove last table element

print(table.concat(a, ','))

for k,v in pairs(a) do
  print(k..':'..v)
end

print(table.concat(a)) -- concats everything together, without delimiter

t = { FIRSTNAME = 1, LASTNAME = 2 }
table.insert(t, 'hello')
for k,v in pairs(t) do print(k, v) end

