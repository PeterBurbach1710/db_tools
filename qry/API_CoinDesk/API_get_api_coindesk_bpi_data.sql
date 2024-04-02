CREATE
OR REPLACE PYTHON3 SCALAR SCRIPT PBB.get_api_coindesk_bpi_data(no_days_to_load DECIMAL) EMITS (bpi_date DATE, bpi_price DOUBLE) AS import urllib.request AS request import json import datetime AS dt def run(ctx): start_date = (
        dt.datetime.today() - dt.timedelta(days = ctx.no_days_to_load)
) .strftime("%Y-%m-%d") end_date = (dt.datetime.today() - dt.timedelta(days = 1)) .strftime("%Y-%m-%d") url = f "https://api.coindesk.com/v1/bpi/historical/close.json?start={start_date}&end={end_date}#" WITH request.urlopen(url) AS response: IF response.getcode() == 200: # -- read api and read output as json
source = response.read() DATA = json.loads(source) # -- loop over each date and display eachs price
FOR DATE,
price IN DATA [ "bpi" ] .items(): # print(DATE, price) ctx.emit(
        dt.datetime.strptime(DATE, '%Y-%m-%d') .date(),
        price
)
ELSE: print(
        "An error occured when trying to reach out to API"
) /