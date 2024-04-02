import urllib.request as request
import json
import datetime as dt
import pandas as pd

url = f"https://api.coindesk.com/v1/bpi/historical/close.json?start=2013-09-01&end=2021-06-30#"
# url = f"https://api.coindesk.com/v1/bpi/historical/close.json?start=2013-09-01&end=2013-09-11#"

if "data" not in locals():
    with request.urlopen(url) as response:
        if response.getcode() == 200:
            #-- read api and read output as json
            source = response.read()
            data = json.loads(source)
else:
    print("data existiert schon")

dic = {}
dic["date"]  = [x for x in data['bpi'].keys()]
dic["price"] = [x for x in data['bpi'].values()]

df= pd.DataFrame(dic)

df.to_csv("data.csv")
