import os
from dotenv import load_dotenv
import pymysql
from pymysql.cursors import DictCursor

# 클래스와 함수 설계 시 고려할 것
# coupling 연결성 <> 독립성
# cohesion 응집력

class MariaDBHandler:
    # 생성자에서 환경변수 불러와 설정하는 건 종속적이 됨.
    def __init__(self, host, port, user, password, database):
        self.DB_CONFIG = {
            'host': host,
            'port': int(port),
            'user': user,
            'password': password,
            'database': database,
            'charset': 'utf8mb4',
            'autocommit': False,
        }

        # 접속 시도해서 잘 연결되는지 체크
        conn = self._connect()
        if conn: conn.close()

    def _connect(self):
        """연결 처리 로직"""
        try:
            conn = pymysql.connect(cursorclass=DictCursor, **self.DB_CONFIG)
            return conn
        except pymysql.err.OperationalError as e:
            print(f'연결 오류: {e}')
            return None
    
    def _run(self, sql, args=(), is_select=False): 
        """
        SQL 쿼리 실행 함수
        """
        try:
            with self.conn.cursor() as cur:
                cur.execute(sql, args)
                if is_select:
                    return cur.fetchall()
            self.conn.commit()
        except pymysql.err.OperationalError as e:
            print(f'[트랜잭션 에러]: {e}, 롤백합니다')
            self.conn.rollback()
        
    def insert(self, table: str, cols: list[str], values):
        assert len(cols) == len(values), '칼럼 길이가 다릅니다.'

        sql = f"""
            INSERT INTO {table}({','.join(cols)})
                VALUES ({','.join(['%s']*len(values))})
        """

        self._run(sql, values)

    def select(self, table, cols): 
        sql = f"""
        SELECT {','.join(cols)}
        FROM {table}
        """

        return self._run(sql, is_select=True)

    def query(self, sql_raw):
        # 자유도 높은 쿼리 원본 그대로 실행해주는 애
        return self._run(sql_raw, is_select=True)

    def update(self): ...
    def delete(self): ...

    def __enter__(self):
        self.conn = self._connect()

    def __exit__(self, exc_type, exc, tb):
        self.conn.close()

if __name__ == '__main__':
    load_dotenv()

    DB_CONFIG = {
        'host': os.environ.get('DB_HOST', '127.0.0.1'),
        'port': int(os.environ.get('DB_PORT', '3306')),
        'user': os.environ.get('DB_USER', 'analyst'),
        'password': os.environ.get('DB_PASSWORD', ''),
        'database': os.environ.get('DB_NAME', 'shop_db'),
    }

    handler = MariaDBHandler(**DB_CONFIG)

    # 한 커넥션
    with handler:
        handler.insert(
            'tb_student', 
            ['name', 'email', 'phone', 'major'],
            ('김철수', 'chulsoo@ss.ss', '1234-5678', '컴공')
        )
        students = handler.select('tb_student', ['*'])

        print(students)
    # 커넥션 종료

    print('프로그램 종료')
