function add_prefix(arr, prefix)
  res = table.concat(arr, ', '..prefix)
  res = prefix..res
  return res
end

print(add_prefix( {'firstname', 'lastname', 'city'}, 'person.'))