

def fetch_detail(url):
    if url == 'http://www.segyebiz.com/newsView/20260825509578?OutUrl=naver':
        raise 

def parse(res):
    ...

from tqdm import tqdm
import logging
logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s [%(levelname)s] %(message)s",
    handlers=[
    logging.FileHandler("crawler_detail.log", encoding="utf -8"),
    logging.StreamHandler(),
    ],
)
logger = logging.getLogger('crawler_detail')
import time

urls = [l.strip().split(',') for l in open('./urls.csv', 'r').readlines()]
# url, status
# status pending만
todos = [url for url, status in urls if status == 'PEDNING']

stats = {'ok': 0, 'failed': 0, 'skip': 0}

def marking(url, status):
    content = open('./urls.csv').read()
    content = content.replace(f'{url},PEDNING', f'{url},{status}')
    open('./urls.csv', 'w').write(content)

for url in tqdm(todos, desc="네이버 뉴스 디테일 수집"):
    try:
        res = fetch_detail(url)
        news = parse(res)
        stats['ok'] += 1

        # mark done
        marking(url, 'DONE')

    except Exception as e:
        logger.warning(f'에러 발생: {e}')
        stats['skip'] += 1

        # mark failed
        # content = open('./urls.csv').read()
        # content = content.replace(f'{url},PEDNING', f'{url},FAILED')
        # open('./urls.csv', 'w').write(content)
        marking(url, 'FAILED')
        
        continue
    finally:
        time.sleep(0.5) # 매너
