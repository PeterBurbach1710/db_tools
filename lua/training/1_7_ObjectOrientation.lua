function new()
  return {
    name = "",
    age = 0,
    incrementAge = function(self) self.age = self.age+1 end
    }
end

p = new()
p.name = "Peter"
p.age = 25
p.incrementAge(p)
p:incrementAge()
print(p.name, p.age)


print(p)  -- returns i.e. "table: 0x000281e8"


--[[
function wrap_incrementAge(self, n) 
  self.age = self.age+n
end


function new()
  return {
    name = "",
    age = 0,
    incrementAge = wrap_incrementAge
    }
end
]]--