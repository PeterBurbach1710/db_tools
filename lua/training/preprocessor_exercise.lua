    --/
CREATE OR REPLACE SCRIPT MYTRANSFORM() AS
function transform_truncate(sqltext)
    local tokens = sqlparsing.tokenize(sqltext)
	found = sqlparsing.find(tokens, 1, true, false, sqlparsing.iswhitespaceorcomment, 'TRUNCATE', sqlparsing.isidentifier)
	if found ~= nil then 
        before = table.concat(tokens, '', 1, found[1]-1)
        after  = table.concat(tokens, '', found[2]+1)
        sqltext = before ..  'TABLE '.. after
    end
    return sqltext
end
output(transform_truncate([[TRUNCATE example_table]]))
/

--/
CREATE OR REPLACE SCRIPT MYPREPROCESS() AS
import(exa.meta.current_schema..'.MYTRANSFORM', 'MYTRANSFORM')
sqltext = sqlparsing.getsqltext()
sqltext = MYTRANSFORM.transform_truncate(sqltext)
sqlparsing.setsqltext(sqltext)
/