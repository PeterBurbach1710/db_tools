OPEN schema PBB;
SELECT
        get_db_location('Nuernberg');
SELECT
        get_db_arrivalboard(8000284);
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
        NAME,
        train,
        train_type,
        datetime,
        origin,
        track,
        html_unescape(origin) origin_neu
FROM
        arrival
WHERE
        train_type = 'IC'