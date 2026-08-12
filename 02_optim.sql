-- 쿼리 실행시간 확인
SET profiling = 1;
SELECT COUNT(*) 
FROM tb_big_order 
WHERE member_id=54321;
-- 0.812초 소요
SHOW PROFILES;
SET profiling = 0;

-- 인덱스 설정
CREATE INDEX idx_order_member 
    ON tb_big_order (member_id);

-- 위에 쿼리를 다시 실행
-- 0.002초 소요

-- 특정 테이블 인덱스 확인
SHOW INDEX FROM tb_big_order;


SELECT COUNT(*) AS total,
    COUNT(DISTINCT status) AS status_card,
    COUNT(DISTINCT member_id) AS member_card,
    COUNT(DISTINCT DATE(order_dt)) AS order_dt_card
FROM tb_big_order;
-- 카디널리티가 낮으면, 인덱스 효율을 제대로 뽑을수가 없다.
-- PAID: 333만개 / SHIPPED: 333만개 / CANCELED: 333만개
-- 굳이? 이걸 써야될까

-- 인덱스 삭제
DROP INDEX idx_order_member ON tb_big_order;

-- 복합인덱스
CREATE INDEX idx_m_dt 
    ON tb_big_order (member_id, order_dt);

SELECT COUNT(*)
FROM tb_big_order
-- WHERE member_id=100; -- 0.000초
-- WHERE member_id=100 AND order_dt > '2023-06-01'; -- 0.001초
WHERE order_dt > '2024-06-01'; -- 0.934초


-- 디스크 용량 확인
SELECT table_name,
    ROUND(data_length/1024/1024,1) AS data_mb,
    ROUND(index_length/1024/1024,1) AS index_mb
FROM information_schema.tables
WHERE table_schema='perf_db';

-- EXPLAIN
EXPLAIN 
SELECT * 
FROM tb_big_order
WHERE member_id=54321;

+------+-------------+--------------+------+---------------+----------+---------+-------+------+-------+
| id   | select_type | table        | type | possible_keys | key      | key_len | ref   | rows | Extra |
+------+-------------+--------------+------+---------------+----------+---------+-------+------+-------+
|    1 | SIMPLE      | tb_big_order | ref  | idx_m_dt      | idx_m_dt | 4       | const | 100  |       |
+------+-------------+--------------+------+---------------+----------+---------+-------+------+-------+

EXPLAIN 
SELECT * 
FROM tb_big_order
WHERE order_id=500000;
-- const

EXPLAIN 
SELECT * 
FROM tb_big_order
WHERE member_id=54321;
-- ref

CREATE INDEX idx_order_dt 
    ON tb_big_order (order_dt);

EXPLAIN 
SELECT * 
FROM tb_big_order
WHERE order_dt BETWEEN '2023-05-01' AND '2023-05-07';
-- range
DROP INDEX idx_order_dt ON tb_big_order;

EXPLAIN 
SELECT * 
FROM tb_big_order
WHERE total_amount>100000;
-- ALL

-- ANALYZE
ANALYZE 
SELECT * 
FROM tb_big_order 
WHERE member_id = 54321;

ANALYZE FORMAT=JSON
SELECT m.city, COUNT(*), SUM(o.total_amount)
FROM tb_big_order o
    JOIN tb_big_member m ON o.member_id=m.member_id
WHERE o.order_dt >= '2023-06-01' 
    AND o.order_dt< '2023-07-01'
GROUP BY m.city;

-- CREATE INDEX idx_order_dt 
--     ON tb_big_order (order_dt);

-- DROP INDEX idx_order_dt ON tb_big_order;


CREATE INDEX idx_order_dt 
    ON tb_big_order (order_dt);

ANALYZE 
SELECT COUNT(*) 
FROM tb_big_order
WHERE DATE_FORMAT(order_dt,'%Y-%m') = '2023-07';
-- 1.958s

ANALYZE 
SELECT COUNT(*) FROM tb_big_order
WHERE order_dt>='2023-07-01' AND order_dt<'2023-08-01';
-- 0.070s

DROP INDEX idx_order_dt ON tb_big_order;


-- 서브쿼리 대신 조인

ANALYZE FORMAT=JSON
SELECT member_id,
    (SELECT COUNT(*) FROM tb_big_order o
    WHERE o.member_id=m.member_id) AS 주문건수
FROM tb_big_member m;

ANALYZE FORMAT=JSON
SELECT m.member_id, COUNT(*) AS 주문건수
FROM tb_big_member m
    LEFT JOIN tb_big_order o ON m.member_id=o.member_id
GROUP BY m.member_id;


-- OR -> UNION ALL
ANALYZE FORMAT=JSON
SELECT member_id, order_id
FROM tb_big_order
WHERE member_id = 1234
    OR order_id=987654;
-- 0.0281

ANALYZE FORMAT=JSON
SELECT member_id, order_id 
FROM tb_big_order
WHERE member_id=1234
UNION ALL
SELECT member_id, order_id 
FROM tb_big_order
WHERE order_id=987654;
-- 0.0386

ANALYZE FORMAT=JSON
SELECT *
FROM tb_big_order
LIMIT 20
OFFSET 5000000;
-- 0.78
-- page=1&size=20

ANALYZE FORMAT=JSON
SELECT * 
FROM tb_big_order
WHERE order_id>5000000
LIMIT 20;
-- limit=20&cursor=50;
-- 0.000s
-- 커서 페이지네이션 방식의 문제점
-- -> id 중간에 있는게 삭제되거나하면 순서 꼬임 
-- 그래서 cursor에 쓸 id도 같이 받아서 query에 포함


ANALYZE FORMAT=JSON
SELECT order_id, order_dt, total_amount
FROM tb_big_order
WHERE member_id=777
ORDER BY order_dt DESC
LIMIT 10;
-- member_id, order_dt
