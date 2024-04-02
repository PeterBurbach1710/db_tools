function add_prefix(arr, prefix)
  local res
  res = ""
  for k,v in ipairs(arr) do
    if res ~= "" then res = res..", " end
    res = res..prefix..v
  end
  return res
end

print(add_prefix( {'firstname', 'lastname', 'city'}, 'person.'))