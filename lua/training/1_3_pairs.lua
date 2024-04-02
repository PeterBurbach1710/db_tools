-- ipair for arrays (keys numeric from 1 to x)
-- for k, v in ipairs(t) do .. end

-- pair for arbitrary arrays / tables/ dictionaries (keys are anything)
-- for k, v in pairs(t) do .. end

a = { 'Berlin', 'london', 'Paris', 'Nuremberg'}

print("** Loop 1")
for k, v in ipairs(a) do 
  print(k..":"..v)
end

a = { 'Berlin', 'london', 'Paris', 'Nuremberg',
  [10] = 'Hannover', COMPANY = 'Exasol' }

-- ends with Nuremberg!!!
print("** Loop 2")
for k, v in ipairs(a) do 
  print(k..":"..v)
end

print("** Loop 3")
for k, v in pairs(a) do 
  print(k..":"..v)
end


a = { [1] = 'node1', [2] = 'node2', info = 'Node list' }
print("** Loop 4")
for k, v in pairs(a) do 
  print(k..":"..v)
end
print("** Loop 5")
for k, v in ipairs(a) do 
  print(k..":"..v)
end
