import urllib
import json
json_response = urllib.urlopen("....").read()
rate = json.loads(json_response)["COLUMN"]
