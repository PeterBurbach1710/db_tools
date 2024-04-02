--/
CREATE OR REPLACE SCRIPT PREPROCESSING.MYTRANSFORM() AS
function transform_use(sqltext)
	local tokens = sqlparsing.tokenize(sqltext)
	found = sqlparsing.find(tokens, 1, true, false, sqlparsing.iswhitespaceorcomment, 'USE', sqlparsing.isidentifier)
        firsttoken = sqlparsing.find(tokens, 1, true, false, sqlparsing.iswhitespaceorcomment, sqlparsing.isany)
	if found ~= nil and found[1] == firsttoken[1] then return true, "open schema "..tokens[found[2]] end
    return false, sqltext
end
/
--/
CREATE OR REPLACE SCRIPT PREPROCESSING.TEST_MYTRANSFORM(sql) AS
import('PREPROCESSING.MYTRANSFORM', 'MYTRANSFORM')
transformed, sqltext = MYTRANSFORM.transform_use(sql)
if transformed then 
 output(sqltext)
 return
end
output(sql)
/
execute script test_mytransform('use my_schema') with output;