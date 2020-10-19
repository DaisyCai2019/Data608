# -*- coding: utf-8 -*-
"""
Created on Sat Oct 17 18:45:35 2020

@author: Mengqin Cai
"""

import dash
import dash_core_components as dcc
import dash_html_components as html
import plotly.express as px
import pandas as pd
import plotly.graph_objs as go

external_stylesheets = ['https://codepen.io/chriddyp/pen/bWLwgP.css']

app = dash.Dash(__name__, external_stylesheets=external_stylesheets)

#read the data

tree2_url = ('https://data.cityofnewyork.us/resource/uvpi-gqnh.json?' +\
        '$select=health,spc_common,boroname,steward,count(tree_id)'+\
        '&$group=health,boroname,spc_common,steward').replace(' ', '%20')

tree2 = pd.read_json(tree2_url).dropna()


app.layout = html.Div(children=[
    html.H1(children='Question2: Stewards Impact On The Health of Trees'),


    dcc.Dropdown(
         id="tree_type",
         options=[{'label': i, 'value': i} for i in (tree2.spc_common).unique()],
         placeholder = 'Select The type of the Tree'
         ),
    
    dcc.Dropdown(
         id="health",
         options=[{'label': i, 'value': i} for i in (tree2.health).unique()],
         placeholder = 'Select The Health Status'
         ),
       
     dcc.Graph(
        id = 'Trees_Steward'    
    )
   ])


@app.callback(
    dash.dependencies.Output('Trees_Steward', 'figure'),
    [dash.dependencies.Input('tree_type', 'value'),
    dash.dependencies.Input('health', 'value')])


def update_figure(tree_type, health):
    filtered = tree2.loc[(tree2.spc_common == tree_type) & (tree2.health ==health)]
    fig2 = px.bar(filtered, x="steward", y="count_tree_id")
                
    return fig2



if __name__ == '__main__':
    app.run_server(debug=False,port=2010)


    
    
    
    
    
    