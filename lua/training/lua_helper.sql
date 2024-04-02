    --/
CREATE OR REPLACE SCRIPT helper() returns table AS
  function get_schemas()
    res = query([[select schema_name from exa_all_schemas]])
    
    t = {}
    for i=1, #res do
      t[i] = res[i][1]
    end
    return t
  end
  output(table.concat(get_schemas(), ", "))
/
execute script helper() with output;

select schema_name from exa_all_schemas