# -*- coding: utf-8 -*-
"""
Created on Thu Oct 15 21:18:21 2020

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

tree1_url = ('https://data.cityofnewyork.us/resource/uvpi-gqnh.json?' +\
        '$select=health,spc_common,boroname,count(tree_id)'  +\
        '&$group=health,boroname,spc_common').replace(' ', '%20')

tree1 = pd.read_json(tree1_url).dropna()
hs = tree1.groupby(['spc_common', 'health'])


app.layout = html.Div(children=[
    html.H1(children='Question1: Proportion of Trees in Health Status'),


    dcc.Dropdown(
         id="tree_type",
         options=[{'label': i, 'value': i} for i in (tree1.spc_common).unique()],
         placeholder = 'Select The type of the Tree'
         ),
    
    dcc.Dropdown(
         id="borough",
         options=[{'label': i, 'value': i} for i in (tree1.boroname).unique()],
         placeholder = 'Select A Borough'
         ),
       
     dcc.Graph(
        id = 'Trees_health'    
    )
   ])


@app.callback(
    dash.dependencies.Output('Trees_health', 'figure'),
    [dash.dependencies.Input('tree_type', 'value'),
    dash.dependencies.Input('borough', 'value')])


def update_figure(tree_type, borough):
    filtered = tree1.loc[(tree1.spc_common == tree_type) & (tree1.boroname ==borough)]
    fig = px.bar(filtered, x="health", y="count_tree_id")
   
    return fig



if __name__ == '__main__':
    app.run_server(debug=False,port=3100)
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    

    