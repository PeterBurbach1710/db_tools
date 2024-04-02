CREATE
OR REPLACE PYTHON3 SCALAR SCRIPT PBB.get_db_arrivalBoard(id DECIMAL) EMITS (
        train VARCHAR(200),
        train_type VARCHAR(10),
        dateTime VARCHAR(20),
        origin VARCHAR(40),
        track VARCHAR(20)
) AS import urllib.request AS request import json import datetime AS dt def run(ctx): id = ctx.id today = dt.date.today() .strftime("%Y-%m-%d") url = f " https://api.deutschebahn.com/freeplan/v1/arrivalBoard/{id}?date={today}" WITH request.urlopen(url) AS response: IF response.getcode() == 200: source = response.read() DATA = json.loads(source) # --loop over each record
FOR line IN DATA: ctx.emit(
        line.get("name", ""),
        line.get("type", ""),
        line.get("dateTime", ""),
        line.get("origin", ""),
        line.get("track", "")
)
ELSE: print(
        "An error occured when trying to reach out to API"
) /