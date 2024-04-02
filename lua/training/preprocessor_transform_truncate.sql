CREATE
OR REPLACE LUA SCRIPT "PBB"."MYTRANSFORM" () RETURNS ROWCOUNT AS FUNCTION transform_truncate(sqltext) LOCAL tokens = sqlparsing.tokenize(sqltext) found = sqlparsing.find(
    tokens,
    1,
    TRUE,
    FALSE,
    sqlparsing.iswhitespaceorcomment,
    'TRUNCATE',
    sqlparsing.isidentifier
) IF found ~ = nil THEN before = TABLE .concat(tokens, '', 1, found [ 1 ]) after = TABLE .concat(tokens, '', found [ 1 ] + 1) sqltext = before .. ' TABLE' .. after
END RETURN sqltext
END