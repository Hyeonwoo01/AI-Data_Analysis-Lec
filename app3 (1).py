import streamlit as st
import numpy as np
import pandas as pd
import seaborn as sns
import plotly.express as px

np.random.seed(42)
n_points = 100

df = pd.DataFrame({
    'x': np.random.rand(n_points),
    'y': np.random.rand(n_points),
    'category': np.random.choice(['A', 'B', 'C'], n_points)
})

color_palettes = ['deep', 'muted', 'pastel', 'dark', 
                  'colorblind', 'icefire']

selected_palette = st.selectbox(
    'Seaborn 색상 팔레트 선택', 
    options=color_palettes
)
palette_colors = sns.color_palette(selected_palette, n_colors=3).as_hex()
# 해당 palette 컬러들의 hex 코드
print('색상 팔레트 hex 코드', palette_colors)

fig = px.scatter(df, x='x', y='y', color='category', 
                 title='Scatter Plot with Seaborn Color Palette',
                 color_discrete_sequence=palette_colors)

st.plotly_chart(fig)

st.write('선택 상자를 사용하여 Seaborn의 색상 팔레트를 적용할 수 있습니다.')
