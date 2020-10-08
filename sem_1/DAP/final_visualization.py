# Python imports
import numpy as np
import pandas as pd
import plotly.graph_objects as go
from ipywidgets import widgets
import plotly.io as pio

# Load data from postgres to a dataframe for final visualization
sql_1 = 'select * from final_table_new' 

import pandas as pd
import pandas.io.sql as sqlio
import psycopg2 as pg


try:
    dbConnection = pg.connect(user = "group_a",
                              password = "groupa123",
                              host = "87.44.4.32",
                              port = "5432",
                              database = "proj_grp_a")
    final_table = sqlio.read_sql_query(sql_1, dbConnection)
except (Exception , pg.Error) as dbError :
    print ("Error:", dbError)
finally:
    if(dbConnection): dbConnection.close()

# Mapping file directory - "C:/Users/shrey/Downloads/DAP/latitude.csv"

lat=pd.read_csv(input("Enter Mapping File:"))
lat.head()
lat['state']= lat['state'].str.upper()

# Join Final table with State Code for getting location code for Map
final_ll = final_table.merge(lat, on='state', how='left')

# Melt the data to columns
df_melt = pd.melt(df,id_vars=["year", "state","total_population","state_code"], value_vars = ["drug_death_cnt","murder_cnt", "cancer_death_cnt", "hiv_death_cnt", "unintenional_injury_death_cnt", 
                  "stroke_death_cnt","heart_disease_death_cnt"],var_name = 'type_of_death',value_name="death_count")
                  
df_melt['type_of_death'] = df_melt['type_of_death'].str.replace('drug_death_cnt', 'Drugs')
df_melt['type_of_death'] = df_melt['type_of_death'].str.replace('murder_cnt', 'Murder')
df_melt['type_of_death'] = df_melt['type_of_death'].str.replace('cancer_death_cnt', 'Cancer')
df_melt['type_of_death'] = df_melt['type_of_death'].str.replace('hiv_death_cnt', 'HIV')
df_melt['type_of_death'] = df_melt['type_of_death'].str.replace('unintenional_injury_death_cnt', 'Unintential Injury')
df_melt['type_of_death'] = df_melt['type_of_death'].str.replace('stroke_death_cnt', 'Stroke')
df_melt['type_of_death'] = df_melt['type_of_death'].str.replace('heart_disease_death_cnt', 'Heart Disease')

# Visualization code for Geo Map
import numpy as np
import pandas as pd
import plotly
import plotly.graph_objects as go
from ipywidgets import widgets
import plotly.io as pio
import plotly.figure_factory as ff


year = widgets.IntSlider(
    value=1,
    min=2014,
    max=2015,
    step=1,
    description='Year:',
    continuous_update=False
)
type_of_death = widgets.Dropdown(options=list(df_melt['type_of_death'].unique()),
    value='Murder',
    description='Death Type:',
)

container = widgets.HBox(children=[year, type_of_death])

fig = go.Choropleth(locations=df_melt["state_code"],  # DataFrame column with locations
                    z=df_melt["death_count"].astype(float),  # DataFrame column with color values
                    locationmode = "USA-states",
                    colorscale = 'hsv',
                    colorbar_title = 'US Death 2014-2015',
                    autocolorscale = False,
                    text = df_melt['state']) # Set to plot as US States

g = go.FigureWidget(data=[fig]).update_layout(geo_scope='usa')


def validate():
    if type_of_death.value in df_melt['type_of_death'].unique():
        return True
    else:
        return False

def response(change):
    if validate():
        if type_of_death.value:
            filter_list = [i and j for i, j in
                           zip(df_melt['year'] == year.value, df_melt['type_of_death'] == type_of_death.value)]
            temp_df = df_melt[filter_list]
            print(temp_df)

 
        else:
            filter_list = [i  for i in
                           zip(df_melt['type_of_death'] == 'murder_cnt')]
            temp_df = df_melt[filter_list]
        x1 = temp_df['state_code']
        x2 = temp_df['death_count'].astype('float')
        x3 = temp_df['state']
        with g.batch_update():
            g.data[0].locations = x1
            g.data[0].z = x2
            g.data[0].text = x3
            g.layout.xaxis.title = 'State'
            g.layout.yaxis.title = 'Death Count'
 
year.observe(response, names="value")
type_of_death.observe(response, names="value")

final = widgets.VBox([container,g])

final