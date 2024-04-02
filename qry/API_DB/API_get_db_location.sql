CREATE
OR REPLACE PYTHON3 SCALAR SCRIPT PBB.get_db_location(NAME VARCHAR(2000)) EMITS (
        NAME VARCHAR(200),
        lon FLOAT,
        lat FLOAT,
        id DECIMAL
) AS import urllib.request AS request import json import datetime AS dt def run(ctx): NAME = ctx.name.replace(chr(32), "%20") url = f "https://api.deutschebahn.com/freeplan/v1/location/{name}" WITH request.urlopen(url) AS response: IF response.getcode() == 200: source = response.read() DATA = json.loads(source) # --loop over each record
FOR line IN DATA: ctx.emit(
        line [ "name" ],
        line [ "lon" ],
        line [ "lat" ],
        line [ "id" ]
)
ELSE: print(
        "An error occured when trying to reach out to API"
) /