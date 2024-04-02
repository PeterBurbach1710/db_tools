OPEN schema PBB;
WITH location AS (
        SELECT
                get_db_location('Nuernberg')
        LIMIT
                1
), arrival AS (
        SELECT
                id,
                NAME,
                get_db_arrivalboard(id)
        FROM
                location
)
SELECT
        id,
        NAME AS stop,
        train,
        train_type,
        datetime,
        origin,
        track
FROM
        arrival -- where track=3 and train_type='ICE'
;