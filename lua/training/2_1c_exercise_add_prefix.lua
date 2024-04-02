function add_prefix(arr, prefix)
  local my_arr = arr
  for k,v in ipairs(my_arr) do
    my_arr[k] = prefix..v
  end
  return table.concat(arr, ', ')
end

print(add_prefix( {'firstname', 'lastname', 'city'}, 'person.'))