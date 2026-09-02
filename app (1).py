import streamlit as st
import matplotlib.pyplot as plt
import seaborn as sns
import plotly.express as px
import numpy as np
import pandas as pd

x = np.linspace(0, 10, 100) # 6.28
y1 = np.sin(x)
y2 = np.cos(x)
y3 = np.tan(x)
y4 = np.tanh(x)

fig, axes = plt.subplots(2, 2)
axes[0, 0].plot(x, y1, label='Sin Wave')
# axes[0, 0].set_title('Sin Function')
axes[0, 0].set_xlabel('X Axis')
axes[0, 0].set_ylabel('Y Axis')
axes[0, 0].legend(bbox_to_anchor=(1.1, 1.2))

axes[0, 1].plot(x, y2)
axes[1, 0].plot(x, y3)
axes[1, 1].plot(x, y4)

st.pyplot(fig)

st.divider()

df = sns.load_dataset('iris')

fig = sns.pairplot(df, hue='species', palette='icefire')

st.pyplot(fig)

with st.expander('데이터셋 상세'):
    st.dataframe(df)

st.divider()

tdf = pd.DataFrame({
    'Category': ['A', 'B', 'C', 'D'],
    'Values': [10, 20, 15, 25]
})

fig = px.bar(tdf, 
             x='Category', 
             y='Values', 
             title='Plotly Example')
st.plotly_chart(fig)
fig = px.bar(tdf, 
             x='Values', 
             y='Category', 
             title='Plotly Example', 
             orientation='h')
st.plotly_chart(fig)


fig = px.scatter(df, 
                 x='sepal_length', 
                 y='petal_length', 
                 color='species')
st.plotly_chart(fig)

fig = px.scatter_3d(df, 
                    x='sepal_length', 
                    y='petal_length', 
                    z='petal_width', 
                    size_max=0.1,
                    color='species')
st.plotly_chart(fig)


import plotly.graph_objects as go

x = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
x_rev = x[::-1]

# Line 1
y1 = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
y1_upper = [2, 3, 4, 5, 6, 7, 8, 9, 10, 11]
y1_lower = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]
y1_lower = y1_lower[::-1]

# Line 2
y2 = [5, 2.5, 5, 7.5, 5, 2.5, 7.5, 4.5, 5.5, 5]
y2_upper = [5.5, 3, 5.5, 8, 6, 3, 8, 5, 6, 5.5]
y2_lower = [4.5, 2, 4.4, 7, 4, 2, 7, 4, 5, 4.75]
y2_lower = y2_lower[::-1]

# Line 3
y3 = [10, 8, 6, 4, 2, 0, 2, 4, 2, 0]
y3_upper = [11, 9, 7, 5, 3, 1, 3, 5, 3, 1]
y3_lower = [9, 7, 5, 3, 1, -.5, 1, 3, 1, -1]
y3_lower = y3_lower[::-1]


fig = go.Figure()

fig.add_trace(go.Scatter(
    x=x+x_rev,
    y=y1_upper+y1_lower,
    fill='toself',
    fillcolor='rgba(0,100,80,0.2)',
    line_color='rgba(255,255,255,0)',
    showlegend=False,
    name='Fair',
))
fig.add_trace(go.Scatter(
    x=x+x_rev,
    y=y2_upper+y2_lower,
    fill='toself',
    fillcolor='rgba(0,176,246,0.2)',
    line_color='rgba(255,255,255,0)',
    name='Premium',
    showlegend=False,
))
fig.add_trace(go.Scatter(
    x=x+x_rev,
    y=y3_upper+y3_lower,
    fill='toself',
    fillcolor='rgba(231,107,243,0.2)',
    line_color='rgba(255,255,255,0)',
    showlegend=False,
    name='Ideal',
))
fig.add_trace(go.Scatter(
    x=x, y=y1,
    line_color='rgb(0,100,80)',
    name='Fair',
))
fig.add_trace(go.Scatter(
    x=x, y=y2,
    line_color='rgb(0,176,246)',
    name='Premium',
))
fig.add_trace(go.Scatter(
    x=x, y=y3,
    line_color='rgb(231,107,243)',
    name='Ideal',
))

fig.update_traces(mode='lines')
st.plotly_chart(fig)


import pandas as pd
df = pd.read_csv('https://raw.githubusercontent.com/plotly/datasets/master/earthquakes-23k.csv')

import plotly.express as px
fig = px.density_map(df, lat='Latitude', lon='Longitude', z='Magnitude', radius=10,
                        center=dict(lat=0, lon=180), zoom=0,
                        map_style="open-street-map")
# fig.show()

st.plotly_chart(fig)

import plotly.express as px
data = dict(
    character=["Eve", "Cain", "Seth", "Enos", "Noam", "Abel", "Awan", "Enoch", "Azura"],
    parent=["", "Eve", "Eve", "Seth", "Seth", "Eve", "Eve", "Awan", "Eve" ],
    value=[10, 14, 12, 10, 2, 6, 6, 4, 4])

fig = px.sunburst(
    data,
    names='character',
    parents='parent',
    values='value',
)

# fig.show()
st.plotly_chart(fig)

import plotly.express as px
df = px.data.tips()
fig = px.histogram(df, x="total_bill", y="tip", color="sex",
                   marginal="violin", # or violin, rug
                   hover_data=df.columns)
# fig.show()

st.plotly_chart(fig)

st.divider()

np.random.seed(42)
n_points = 100
df = pd.DataFrame({
    'x': np.random.rand(n_points),
    'y': np.random.rand(n_points),
    'frame': np.repeat(np.arange(1, 11), n_points // 10),
    'category': np.random.choice(['A', 'B', 'C'], n_points)
})

fig = px.scatter(
    df,
    x='x',
    y='y',
    color='category',
    animation_frame='frame',
    # animation_group='category',
    title='Animated Scatter Plot with Longer Data'
)

st.plotly_chart(fig)

st.divider()

df = sns.load_dataset('tips')

print(df['time'].unique())

# 범주형으로 구분해서
g = sns.FacetGrid(df, 
                  col='time', 
                  row='sex', 
                  margin_titles=True)

# 각 데이터 포인트들을 확인
g.map(sns.scatterplot, 'total_bill', 'tip')
st.pyplot(g)

g = sns.FacetGrid(df, 
                  col='time', 
                  row='sex', 
                  margin_titles=True)
g.map(sns.histplot, 'total_bill')
st.pyplot(g)

