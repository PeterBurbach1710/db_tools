-- closure function
function character_iterator(s)
    pos = 0
    return function()
        pos = pos + 1
        if pos > #s then return nil end
        return s:sub(pos,pos)
    end
end

for letter in character_iterator("Hello") do
    print(letter)
end