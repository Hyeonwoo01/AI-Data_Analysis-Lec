import logging
import sys
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s [%(levelname)s] %(name)s | %(message)s',
    handlers=[
        logging.StreamHandler(sys.stdout),
        logging.FileHandler('report.log', encoding='utf-8')
    ])

from db import MariaDBHandler

log = logging.getLogger('Pipeline')
