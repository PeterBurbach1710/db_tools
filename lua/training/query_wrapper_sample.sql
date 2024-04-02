--/
CREATE
OR REPLACE LUA SCRIPT PBB.create_restricted_view(view_name, table_name, ARRAY column_blacklist) RETURNS TABLE AS import('etl.query_wrapper', 'qw') wrapper = qw.new(
    'etl.job_log',
    'etl.job_details',
    'create_restricted_view'
) -- Convert the column_blacklist array into a Lua table with the column names as keys.
-- This makes it easy to check whether a column is on the blacklist.
blacklist = { } FOR i = 1,
#column_blacklist DO blacklist [ column_blacklist [ i ] ] = TRUE
END wrapper :set_param('T', quote(table_name)) suc,
res = wrapper :query([ [ DESC :: T ] ]) cols = { } FOR i = 1,
#res DO IF blacklist [ res [ i ] .COLUMN_NAME ] == nil THEN cols [ #cols + 1 ] = res [ i ] .COLUMN_NAME
END
END wrapper :log('INFO', TABLE .concat(cols, ', ')) wrapper :set_param('V', quote(view_name)) wrapper :set_param('T', quote(table_name)) wrapper :query(
    [ [ CREATE
    OR REPLACE VIEW :: V AS
    SELECT
        ] ] ..table.concat(cols, ', ') .. [ [
    FROM
        :: T ] ]
) RETURN wrapper :finish() /