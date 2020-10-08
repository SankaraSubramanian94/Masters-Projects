# Drug Death
"""
Created on Mon Nov  4 10:31:50 2019

@author: Sankar
"""
# Download data from JSON format
import requests
URL = input("Enter a URL:")
print(URL)

# API for download - https://data.ct.gov/api/views/rybz-nyjw/rows.json?accessType=DOWNLOAD

# Python user-defined exceptions:

class MyError(Exception):
    def __init__(self,Value="Unsupported URL"):
        self.Value=Value
        
    def __str__(self):
        return(repr(self.Value))  
# Try and catch exception
try:
    url_request = requests.get(url = URL)
    print("Valid Url")
    try:
        data = url_request.json()
    except:
        raise(MyError())
except MyError as a:
    print(a.value)

# Data Extraction from raw json:

no_col = len(data['meta']['view']['columns'])
no_rows = (len(data['data']))

col_name =[]
for i in range(8,(no_col-1)):
    col_name.append(data['meta']['view']['columns'][i]['name'])

row_data = []
for j in range(0,(no_rows)):
    row_data.append(data['data'][j][8:49])

dict_data=[]
for k in range(len(row_data)):
    dict_data.append(dict(zip(col_name,row_data[k])))

# Connection to Mongodb:
from pymongo import MongoClient
client = MongoClient("mongodb://myTester:myTester123@87.44.4.32/test")
print(client)

# load data of json type to mongodb:
mydb = client["test"]
mycol = mydb["drug_accidents"]
#mycol.insert_many(dict_data)
#truncate collection
#mycol.remove() 

print(db.list_collection_names())- show collections

# Load data from mongodb to pandas dataframe:

import pandas as pd
cursor = mydb['drug_accidents'].find()
print(cursor)
df =  pd.DataFrame(list(cursor))

# Adding a new column Year and resetting index
df['Year']= pd.DatetimeIndex(df['Date']).year

del df['_id']

df_1 = df[(df['MannerofDeath']=='Accident')& (~df['Year'].isnull())& (~df['DeathCity'].isnull())]
df_1['Year'] = df['Year'].astype('Int64')

df_1 = df.reset_index(drop=True)
df_1.dtypes


# Read a State City Mapping file:

mapping_file = pd.read_csv("D:/Database_Programming/project/state_city_file.csv")

df_2 = pd.merge(df_1,mapping_file, how = 'left', left_on =['DeathCity'], right_on =['City'])

df_2.loc[(df_2['State'].isnull())&(df_2['ResidenceState']=='CT'),'State']='CONNECTICUT'

df_3 = df_2[~(df_2['State'].isnull())]

df_3.drop(['DeathCityGeo','ResidenceCityGeo','InjuryCityGeo', 'ResidenceCounty', 'Race', 'ResidenceCity',\
          'ResidenceCounty','ResidenceState','DeathCity','DeathCounty', 'LocationifOther',\
          'DescriptionofInjury', 'InjuryPlace', 'InjuryCity', 'InjuryCounty', 'InjuryState', \
          'OtherSignifican', 'DateType'],
          axis=1, inplace=True)

# Load final output to csv file
# file-directory : "D:/Database_Programming/project/final_file.csv"

df_3.to_csv(input("Enter File Directory:"), index=False)

df_3.dtypes

# Create table in postgres
import psycopg2 as pg
try:
    dbConnection = pg.connect(
    user = "group_a",password = "groupa123",
    host = "87.44.4.32",
    port = "5432",
    database = "proj_grp_a")
    dbConnection.set_isolation_level(0) # AUTOCOMMIT
    dbCursor = dbConnection.cursor()
    dbCursor.execute("""
CREATE TABLE drug_death(
ID                  text    PRIMARY KEY,
Date                timestamp,
Age                 integer,
Sex                 text,
Location            text,
COD                 text,
Heroin              text,
Cocaine             text,
Fentanyl            text,
FentanylAnalogue    text,
Oxycodone           text,
Oxymorphone         text,
Ethanol             text,
Hydrocodone         text,
Benzodiazepine      text,
Methadone           text,
Amphet              text,
Tramad              text,
Morphine_NotHeroin  text,
Hydromorphone       text,
Other               text,        
OpiateNOS           text,
AnyOpioid           text,
MannerofDeath   text,
Year    integer,
State text,
City    text
);
""")
    dbCursor.close()
except (Exception , pg.Error) as dbError :
    print ("Error while connecting to PostgreSQL", dbError)
finally:
    if(dbConnection): dbConnection.close()


# Load data into postgres

# Input file_path - D:/Database_Programming/project/final_file.csv

import csv
file = input("Enter Input File Directory:")
sql_insert = """INSERT INTO drug_death(ID, Date, Age, Sex, Location, COD, 
Heroin, Cocaine, Fentanyl,FentanylAnalogue, Oxycodone, Oxymorphone, Ethanol, Hydrocodone, Benzodiazepine, Methadone, Amphet, Tramad,
Morphine_NotHeroin, Hydromorphone, Other, OpiateNOS, AnyOpioid, MannerofDeath, Year, State, City)
                VALUES(%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s,
                %s, %s, %s, %s, %s,%s)"""
try:
    conn = pg.connect(user="group_a",
                      password="groupa123",
                      host="87.44.4.32",
                      port="5432",
                      database="proj_grp_a")
    cursor = conn.cursor()
    with open(file, 'r') as f:
        reader = csv.reader(f)
        next(reader) # This skips the 1st row which is the header.
        for record in reader:
            cursor.execute(sql_insert, record)
            conn.commit()
except (Exception, pg.Error) as e:
    print(e)
finally:
        if (conn):
            cursor.close()
            conn.close()
            print("Connection closed.")

# Extract data from Postgres and analysis
sql = """select distinct a.Year, a.City, a.State, a.COD, a.age_bin, 
(Heroin + Cocaine + Fentanyl + FentanylAnalogue + Oxycodone + Oxymorphone + Ethanol + Hydrocodone +
Benzodiazepine + Methadone + Amphet + Tramad + Morphine_NotHeroin + Hydromorphone + OpiateNOS + AnyOpioid) as drug_score 
from
(	select 
	Year,
	City,
	State,	
	Date,
	Age,
	Sex,
	Location,
	COD,
	MannerofDeath,
	case 
	when Age between 14 and 19 then 'teen'
	when Age between 20 and 35 then 'adult_group_1'
	when Age between 36 and 50 then 'adult_group_2'
	when Age between 51 and 64 then 'adult_group_3'
	when Age >64 then 'elderly' end as age_bin,
	
case when Heroin ='Y' then 1 else 0 end as Heroin,
case when Cocaine ='Y' then 1 else 0 end as Cocaine,
case when Fentanyl ='Y' then 1 else 0 end as Fentanyl,
case when FentanylAnalogue ='Y' then 1 else 0 end as FentanylAnalogue,
case when Oxycodone ='Y' then 1 else 0 end as Oxycodone,
case when Oxymorphone ='Y' then 1 else 0 end as Oxymorphone,
case when Ethanol ='Y' then 1 else 0 end as Ethanol,
case when Hydrocodone ='Y' then 1 else 0 end as Hydrocodone,
case when Benzodiazepine ='Y' then 1 else 0 end as Benzodiazepine,
case when Methadone ='Y' then 1 else 0 end as Methadone,
case when Amphet ='Y' then 1 else 0 end as Amphet,
case when Tramad ='Y' then 1 else 0 end as Tramad,
case when Morphine_NotHeroin ='Y' then 1 else 0 end as Morphine_NotHeroin,
case when Hydromorphone ='Y' then 1 else 0 end as Hydromorphone,
case when OpiateNOS ='Y' then 1 else 0 end as OpiateNOS,
case when AnyOpioid ='Y' then 1 else 0 end as AnyOpioid
	from drug_death )a"""

# Create table from subquery for analysis:

import pandas as pd
import pandas.io.sql as sqlio
import psycopg2 as pg

try:
    dbConnection = pg.connect(user = "group_a",
                              password = "groupa123",
                              host = "87.44.4.32",
                              port = "5432",
                              database = "proj_grp_a")
    drug_death_dataframe = sqlio.read_sql_query(sql, dbConnection)
except (Exception , pg.Error) as dbError :
    print ("Error:", dbError)
finally:
    if(dbConnection): dbConnection.close()

# Input file_path - D:/Database_Programming/project/drug_info.csv

drug_death_dataframe.to_csv(input("Enter File Directory_1:"), index=False)
drug_death_dataframe.dtypes

try:
    dbConnection = pg.connect(
    user = "group_a",password = "groupa123",
    host = "87.44.4.32",
    port = "5432",
    database = "proj_grp_a")
    dbConnection.set_isolation_level(0) # AUTOCOMMIT
    dbCursor = dbConnection.cursor()
    dbCursor.execute("""
CREATE TABLE drug_info(
year    integer,
city    text,
state text,
cod                 text,
age_bin text,
drug_score integer
);
""")
    dbCursor.close()
except (Exception , pg.Error) as dbError :
    print ("Error while connecting to PostgreSQL", dbError)
finally:
    if(dbConnection): dbConnection.close()
    
# Insert record into 
import csv
file = input("Enter Input File Directory_1:")
sql_insert = """INSERT INTO drug_info(year, city, state, cod, age_bin, drug_score)
                VALUES(%s, %s, %s, %s, %s, %s)"""
try:
    conn = pg.connect(user="group_a",
                      password="groupa123",
                      host="87.44.4.32",
                      port="5432",
                      database="proj_grp_a")
    cursor = conn.cursor()
    with open(file, 'r') as f:
        reader = csv.reader(f)
        next(reader) # This skips the 1st row which is the header.
        for record in reader:
            cursor.execute(sql_insert, record)
            conn.commit()
except (Exception, pg.Error) as e:
    print(e)
finally:
        if (conn):
            cursor.close()
            conn.close()
            print("Connection closed.")

# Drug info dataframe
        
sql_1 = """select * from(
select year, age_bin, count(*) as count, round(avg(drug_score),2) as avg_drug_score, 
case when state = 'Massachusetts' or state = 'MASSACHUSETTS' then 'MASSACHUSETTS' else state end,
case when city = ''  then 'NA' else city end
from drug_info group by
year, city, state, age_bin
union all
select year, 'ALL' as age_bin, count(*) as count, round(avg(drug_score),2) as avg_drug_score, 
'ALL' as state, 'ALL' as city from drug_info group by year)a""" 
import pandas as pd
import pandas.io.sql as sqlio
import psycopg2 as pg

try:
    dbConnection = pg.connect(user = "group_a",
                              password = "groupa123",
                              host = "87.44.4.32",
                              port = "5432",
                              database = "proj_grp_a")
    drug_info_dataframe = sqlio.read_sql_query(sql_1, dbConnection)
except (Exception , pg.Error) as dbError :
    print ("Error:", dbError)
finally:
    if(dbConnection): dbConnection.close()
    
# Groupby year and age_bin and get count

drug_info_dataframe_1 = drug_info_dataframe.groupby(['year','age_bin'], as_index=False)['count'].sum()

# Groupby state, year and age_bin and get average 
drug_info_dataframe_2 = drug_info_dataframe.groupby(['state','age_bin','year'], as_index=False)['avg_drug_score'].mean()


# Visualization

# Bar Plot
import seaborn as sns

sns.barplot(x='year', y='count', hue='age_bin', data=drug_info_dataframe_1, saturation=1)

# Donut Chart
import plotly.graph_objs as go
colors = ['FireBrick', 'Chocolate', 'SandyBrown', 'Salmon']
fig = go.Figure(data=[go.Pie(
labels=drug_info_dataframe_2.age_bin,
values=drug_info_dataframe_2.avg_drug_score)])
fig.update_traces(hoverinfo='label+percent',
textinfo='value', textfont_size=12,
marker=dict(colors=colors,
line=dict(color='#000000', width=2)), hole=.3)
fig.show()

#Scatter Plot 
import plotly.express as px

fig = px.scatter(drug_info_dataframe.query("year==2018"), x="state", y="count",
      size="year", color="city", 
                 hover_name="year",size_max=20,title='State Wise Drug Death in USA 2018')
fig.show()


# Heat Map
import numpy as np
import plotly.graph_objects as go
fig = go.Figure(data=go.Heatmap(
                   z=np.array(drug_info_dataframe_2['avg_drug_score']),
                   x=np.array(drug_info_dataframe_2['age_bin']),
                   y=np.array(drug_info_dataframe_2['state']),
                   hoverongaps = False))
fig.show()

# Interactive Visulaization

import numpy as np
import pandas as pd

import plotly.graph_objects as go
from ipywidgets import widgets

year = widgets.IntSlider(
    value=1,
    min=2012,
    max=2018,
    step=1,
    description='Year:',
    continuous_update=False
)

container = widgets.HBox(children=[year])

use_age_group = widgets.Dropdown(options=list(drug_info_dataframe['age_bin'].unique()),
    value='teen',
    description='Age_Group:',
)

textbox = widgets.Dropdown(
    description='City:   ',
    value='SOUTHINGTON',
    options=drug_info_dataframe['city'].unique().tolist()
)

state = widgets.Dropdown(options=list(drug_info_dataframe['state'].unique()),
    value='CONNECTICUT',
    description='State:',
)


# Assign an empty figure widget with two traces
trace1 = go.Histogram(x=drug_info_dataframe['avg_drug_score'], opacity=0.75, name='Average Drug Score')
trace2 = go.Histogram(x=drug_info_dataframe['count'], opacity=0.75, name='Death Count')
g = go.FigureWidget(data=[trace1, trace2],
                    layout=go.Layout(
                        title=dict(
                            text='US Drug Death'
                        ),
                        barmode='overlay'
                    ))
def validate():
    if state.value in drug_info_dataframe['state'].unique() and textbox.value in drug_info_dataframe['city'].unique() and \
    use_age_group.value in drug_info_dataframe['age_bin'].unique():
        return True
    else:
        return False


def response(change):
    if validate():
        if use_age_group.value:
            filter_list = [i and j and k and l for i, j, k, l in
                           zip(drug_info_dataframe['year'] == year.value, drug_info_dataframe['city'] == textbox.value,
                               drug_info_dataframe['state'] == state.value, drug_info_dataframe['age_bin'] == use_age_group.value)]
            temp_df = drug_info_dataframe[filter_list]
            print(temp_df)

        else:
            filter_list = [i and j and k for i, j, k in
                           zip(drug_info_dataframe['city'] == 'SOUTHINGTON', drug_info_dataframe['state'] == state.value,
                          drug_info_dataframe['age_bin'] == 'teen')]
            temp_df = drug_info_dataframe[filter_list]
        x1 = temp_df['avg_drug_score']
        x2 = temp_df['count']
        with g.batch_update():
            g.data[0].x = x1
            g.data[1].x = x2
            g.layout.barmode = 'overlay'
            g.layout.xaxis.title = 'Avgerage Drug Score'
            g.layout.yaxis.title = 'Death Count'

state.observe(response, names="value")
textbox.observe(response, names="value")
year.observe(response, names="value")
use_age_group.observe(response, names="value")