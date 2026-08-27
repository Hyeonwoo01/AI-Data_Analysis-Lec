# 멀티스레드
from multiprocessing.dummy import Pool as ThreadPool

# 멀티프로세싱
from multiprocessing import Pool

import requests
import time
from bs4 import BeautifulSoup

def fetch(url, page=1):
    res = requests.get(url, timeout=10)
    time.sleep(0.7)
    print(url, '처리중...')
    return res.text

def parse(html):
    return BeautifulSoup(html, 'html.parser')

if __name__ == '__main__':
    # 13개
    urls = [url.rstrip() for url in open('./urls.txt').readlines()]

    # st = time.time()
    # for url in urls:
    #     result = fetch(url)
    # print('반복문 소요시간: %.2f'%(time.time() - st))

    st = time.time()
    with ThreadPool(3) as pool:
        results = pool.map(fetch, urls)
        # results = pool.starmap(fetch, [('url', 1), ('url', 2)])
    print('멀티스레딩 소요시간: %.2f'%(time.time() - st))
    # print('멀티프로세싱 소요시간: %.2f'%(time.time() - st))

    print('='*10, '파싱')
    st = time.time()
    for result in results:
        parse(result)
    print('반복문 소요시간: %.2f'%(time.time() - st))

    st = time.time()
    with Pool(3) as pool:
        parse_results = pool.map(parse, results)
    print('멀티프로세싱 소요시간: %.2f'%(time.time() - st))
    # 메모리 복사하는 시간 때문에 오히려 더 걸린상황
    # 프로세스 복사 시간이 굉장히 작은 부분이 되도록, 
    # 다른 작업들이 오랜 CPU 계산을 필요로 해야 이점이 커진다.
