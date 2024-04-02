f = function(x)
  return x
end

function f(x)
  return x
end

print(type(f)) -- return function
print(f(5))


function g(x)
  local my_x = x  -- makes my_x is a local variable (it does not override a potential global variable with the same name)
  if x == nil then my_x = 5 end
  return my_x
end

print(g(10))
print(g())
print(g(1,2,3))