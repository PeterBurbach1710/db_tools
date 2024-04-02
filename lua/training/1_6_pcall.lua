function factorial(n)
  if n == 0 or n == 1 then return 1 end
  if n < 0 then error("The number is negative") end
  return n * factorial(n-1)
end

-- pcall: param1: function, param2: value to pass
-- returns success as boolean and result of function call

print("factorial(5)")
suc, y = pcall(factorial, 5)
print(suc)
print(y)

print("factorial(-5)")
suc, y = pcall(factorial, -5)
print(suc)
print(y)
