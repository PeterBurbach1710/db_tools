import pandas as pd

df = pd.read_csv("data.csv")
df.pop("Unnamed: 0")

df2 = df.loc[0:9]

print( df2["date"].min() )
print( df2["date"].max() )
print( df2["price"].min() )
print( df2["price"].max() )
print( df2["price"].mean() )

# df2=df2.assign(test=[x for x in range(10)])

speedList=[]
prevSpeedList=[]

for idx, price in df2["price"].items():
    if idx == 0:
        speed = 0
        prevSpeedList.append(0)
    else:
        prevSpeedList.append(speed)
        speed = price - prev_price
    speedList.append(speed)
    prev_price = price
    
df2=df2.assign(speed=speedList)
df2=df2.assign(speed_p1=prevSpeedList)

if "df3" not in globals():
    df3 = pd.DataFrame(f, index=[0])
else:
    df3 = df3.append(f, ignore_index=True)
