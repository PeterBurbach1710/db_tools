--/
CREATE
OR REPLACE SCRIPT PBB.TEST_MYTRANSFORM(SQL) AS import('PBB.MYTRANSFORM', 'MYTRANSFORM') sqltext = MYTRANSFORM.transform_truncate(SQL) outtext = 'IN: ' ..sql.. ' OUT: ' ..sqltext RETURN output(outtext) / EXECUTE script PBB.test_mytransform('truncate article') WITH output;