 function get_schemas()
  res = { {SCHEMANAME = "Schema"}, {SCHEMANAME = "Schema2"}, {SCHEMANAME = "Schema3"}}

  t = {}
  for i=1, #res do
    print(res[i].SCHEMANAME)
    t[i] = res[i].SCHEMANAME
  end

  print(table.concat(t, ', '))
  return {}
 end
 
 
 print(generate_import( 'article_new', 'my_connection', {'a1.csv', 'a2.csv'} ))