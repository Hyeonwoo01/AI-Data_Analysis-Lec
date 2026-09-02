import streamlit as st
import numpy as np
import matplotlib.pyplot as plt

frequency = st.slider('Frequency', 1, 10, 5)
amplitude = st.slider('Amplitude', 1, 10, 1)

x = np.linspace(0, 10, 500)
y = amplitude * np.sin(x * frequency)

fig, ax = plt.subplots()
ax.plot(x, y)
ax.set_title(f'Sine Wave: Frequency={frequency}, Amplitude={amplitude}')
ax.set_xlabel('X Axis')
ax.set_ylabel('Y Axis')

st.pyplot(fig)

st.write('슬라이더를 사용하여 사인파의 주파수와 ' \
'진폭을 조정할 수 있습니다.')
