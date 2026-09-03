import streamlit as st
from sqlalchemy import create_engine, \
    Table, Column, Integer, String, MetaData
import pandas as pd
from faker import Faker

# SQLite DB 연결
engine = create_engine('sqlite:///users.db')
metadata = MetaData()

# 테이블 정의
users_table = Table('users', metadata,
                    Column('id', Integer, primary_key=True),
                    Column('name', String),
                    Column('email', String),
                    Column('address', String))

# DB에 테이블 생성
metadata.create_all(engine)


fake = Faker()

def generate_fake_data(n=10):
    with engine.connect() as conn:
        # ORM - Object Relation Mapping
        conn.execute(users_table.delete())

        for _ in range(n):
            conn.execute(users_table.insert().values(
                name=fake.name(),
                email=fake.email(),
                address=fake.address()
            ))
        conn.commit()

if st.button('Generate Fake Data'):
    generate_fake_data(20)
    st.success('Fake data generated !')

# @st.cache_data
def load_data():
    with engine.connect() as conn:
        query = "SELECT * FROM users"
        return pd.read_sql(query, conn)

data = load_data()
st.dataframe(data)

st.write('자동배포 테스트')