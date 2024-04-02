function generate_import(table_name, connection, files)
  local res
  if #files == 0 then
    error("The array of file names is empty")
  end
  res = "IMPORT INTO "..table_name
  res = res.." FROM CSV AT "..connection
  for k,v in ipairs(files) do
    res = res.." FILE '"..v.."'"
  end
  return res
end

print(generate_import( 'article_new', 'my_connection', {'a1.csv', 'a2.csv'} ))
-- print(generate_import( 'article_new', 'my_connection', {} ))
