import streamlit as st
import os
from dotenv import load_dotenv
import pandas as pd

# 코드 실행 진입점 = app.py

# 추가 모듈, 파일들
from database.manager import connect, select_order
from pages import home
from components import sidebar, item
from state.initlize import initlize

load_dotenv()

DB_CONFIG = {
    'host': os.getenv('DB_HOST', 'localhost'),
    'port': int(os.getenv('DB_PORT', '3306')),
    'user': os.getenv('DB_USER', 'analysis'),
    'password': os.getenv('DB_PASSWORD', ''),
    'database': os.getenv('DB_NAME', ''),
}

initlize()

conn = connect(DB_CONFIG)

orders = select_order(conn)
df = pd.DataFrame(orders)

conn.close()
st.dataframe(df)

page = sidebar.render()

print(st.session_state['page'])

if st.session_state['page'] == 0:
    home.page()
if st.session_state['page'] == 1:
    st.write('다른 페이지')

    for i in range(10):
        item.Item()