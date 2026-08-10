-- 실습 1-1) WHERE
-- Q. 국가가 KR인 고객 조회
-- tb_customer

SELECT *
FROM tb_customer
WHERE country = 'KR';


-- Q. 등급이 ‘GOLD’인 고객 조회
-- tb_customer

SELECT *
FROM tb_customer
WHERE grade = 'GOLD';

-- 실습 1-2) LIKE
-- Q. 이름이 ‘이’로 시작하는 고객 조회
-- tb_customer

SELECT *
FROM tb_customer
WHERE customer_name LIKE '이%';

-- Q. 이름이 ‘수'로 끝나는 고객 조회
-- tb_customer

SELECT *
FROM tb_customer
WHERE customer_name LIKE '%수';

-- Q. 이름에 세제가 들어가는 상품 조회
-- tb_product

SELECT *
FROM tb_product
WHERE product_name LIKE '%세제%';

-- Q. 이름이 ‘이ㅇㅇ’인 고객 조회
-- tb_customer

SELECT *
FROM tb_customer
WHERE customer_name LIKE '이__';

-- AND, OR, NOT 괄호
SELECT *
FROM tb_product
WHERE (category_id=1 OR category_id=2)
    AND unit_price>5000;


-- 실습 1-3) 논리 연산자
-- 국가가 FR이고, 이름이 ‘Ma’로 시작하는 고객 조회
-- tb_customer

SELECT *
FROM tb_customer
WHERE country='FR' 
    AND customer_name LIKE 'Ma%';

-- 국가가 FR이거나 이름이 ‘Smith’로 끝나는 고객 조회
-- tb_customer

SELECT *
FROM tb_customer
WHERE country='FR'
    OR customer_name LIKE '%Smith';

-- 국가가 FR가 아닌 고객 조회
-- tb_customer

SELECT *
FROM tb_customer
WHERE country!='FR';
WHERE country<>'FR';
WHERE NOT country='FR';

-- DATETIME 탐색
SELECT *
FROM tb_order
WHERE DATE_FORMAT(order_dt, '%Y-%m')='2024-03';

WHERE order_dt >= '2024-03-01'
    AND order_dt < '2024-04-01';

-- 실습 1-4
-- Q. 국가가 FR, ES에 사는 고객 조회
-- tb_customer

SELECT *
FROM tb_customer
WHERE country IN ('FR', 'ES');

-- NOT IN 주의사항 비교연산자도 동일
SELECT *
FROM tb_customer
-- WHERE grade <> 'GOLD';
WHERE grade NOT IN ('GOLD')
    OR grade IS NULL;

-- 실습 1-5) BETWEEN
-- Q. 재고 수량이 50에서 100사이인 상품 조회
-- tb_product

SELECT *
FROM tb_product
WHERE stock_qty BETWEEN 50 AND 100;

-- NULL 테스트
SELECT *
FROM tb_customer
-- WHERE grade = NULL;
WHERE grade IS NULL;

-- 실습 1-6)
-- Q. 등급이 NULL인 고객 조회

SELECT *
FROM tb_customer
WHERE grade IS NULL;

-- Q. 등급이 NULL이 아닌 고객 조회

SELECT *
FROM tb_customer
WHERE grade IS NOT NULL;

SELECT customer_name,
    grade,
    IFNULL(grade, '미지정') AS g1,
    COALESCE(grade, city, '알 수 없음') AS g2
FROM tb_customer;

-- WHERE 실습
-- 1. KR이 아닌 GOLD 고객
SELECT *
FROM tb_customer
WHERE country<>'KR' AND grade='GOLD';

-- 2. '세'를 포함한 1만원 이상 상품
SELECT *
FROM tb_product
WHERE product_name LIKE '%세%'
    AND unit_price>=10000;

-- 3. 2024년 1~3월 주문 중 취소 제외
SELECT *
FROM tb_order
WHERE order_dt >= '2024-01-01'
    AND order_dt < '2024-04-01'
    AND status <> 'CANCELED';

-- 4. 등급없는 고객을 '미지정'으로
SELECT customer_name,
    grade,
    IFNULL(grade, '미지정') AS grade
FROM tb_customer;

-- AS: alias

-- ORDER BY - NULL 처리
SELECT *
FROM tb_customer
ORDER BY grade;

SELECT customer_name, 
    grade, 
    grade IS NULL
FROM tb_customer;

SELECT customer_name, grade
FROM tb_customer
ORDER BY grade IS NULL, grade;

-- 실습 2-1) ORDER BY NULL
-- Q. 등급 없는 고객을 '미지정'으로 표시, 
-- 미지정이 맨 뒤에 오도록 정렬하여 조회
-- tb_customer

SELECT customer_name,
    IFNULL(grade, '미지정') AS 등급
FROM tb_customer
ORDER BY grade IS NULL, grade;

-- 실습 2-2) AS
-- Q. 상품명을 '상품명', 가격을 '가격', 
-- 가격에 0.9를 곱한 가격을 '할인가'로 하여 조회
-- tb_product

SELECT p.product_name AS 상품명,
    p.unit_price AS 가격,
    p.unit_price * 0.9 AS 할인가
FROM tb_product AS p;

-- 실습2-3
-- Q. 가격이 5000 미만은 ‘저가’, 
--      5000~30000이면 ‘중가’, 
--      30000 초과는 ‘고가’로 조회
-- tb_product

SELECT product_name,
    unit_price,
    CASE
        WHEN unit_price < 5000 THEN '저가'
        WHEN unit_price < 30000 THEN '중가'
        ELSE '고가'
    END AS 수준
FROM tb_product;

SELECT YEAR(order_dt) AS yr,
    SUM(CASE WHEN MONTH(order_dt)=1 THEN 1 ELSE 0 END) AS m01,
    SUM(CASE WHEN MONTH(order_dt)=2 THEN 1 ELSE 0 END) AS m02,
    SUM(CASE WHEN MONTH(order_dt)=3 THEN 1 ELSE 0 END) AS m03
FROM tb_order
GROUP BY YEAR(order_dt);

-- 실습 2-4)
-- Q. 연도를 행으로, 1~6월을 열로하여 월별 신규 고객수 조회
-- tb_customer

SELECT YEAR(signup_dt) AS yr,
    SUM(CASE WHEN MONTH(signup_dt)=1 THEN 1 ELSE 0 END) AS m01,
    SUM(CASE WHEN MONTH(signup_dt)=2 THEN 1 ELSE 0 END) AS m02,
    SUM(CASE WHEN MONTH(signup_dt)=3 THEN 1 ELSE 0 END) AS m03,
    SUM(CASE WHEN MONTH(signup_dt)=4 THEN 1 ELSE 0 END) AS m04,
    SUM(CASE WHEN MONTH(signup_dt)=5 THEN 1 ELSE 0 END) AS m05,
    SUM(CASE WHEN MONTH(signup_dt)=6 THEN 1 ELSE 0 END) AS m06
FROM tb_customer
GROUP BY YEAR(signup_dt);

-- 실습 3-1) COUNT
-- Q. 국가가 KR인 고객 수 조회
-- tb_customer

SELECT country, COUNT(*) AS 고객수, COUNT(DISTINCT country) AS 국가수
FROM tb_customer
WHERE country='KR';

-- 실습 3-2) SUM
-- Q. 주문된 상품의 총 수량 계산
-- tb_order_item

SELECT SUM(qty) AS 총수량
FROM tb_order_item;

-- 실습 3-3) AVG
-- Q. 전체 상품의 평균 가격 계산
-- tb_product

SELECT ROUND(AVG(unit_price), 2) AS 평균가격
FROM tb_product;

-- 실습 3-4) MIN
-- Q. 가격 최소값 조회
-- tb_product

SELECT product_name, MIN(unit_price) AS 최소가격
FROM tb_product;
-- 주의) 정렬 LIMIT 1과 MIN 집계는 다르다.

-- 실습 3-5) MAX
-- Q. 가격 최대값 조회
-- tb_product

SELECT MAX(unit_price) AS 최대가격
FROM tb_product;

-- 실습 3-6) GROUP BY
-- Q. 국가별 고객 수 조회 (고객 수 기준 오름차순)
-- tb_customer

SELECT country, COUNT(*) AS 고객수
FROM tb_customer
GROUP BY country
ORDER BY 고객수;

-- Q. 국가, 도시별 고객 수 조회 (고객 수 기준 내림차순)
-- tb_customer

SELECT country, city, COUNT(*) AS 고객수
FROM tb_customer
GROUP BY country, city
ORDER BY 고객수 DESC;

-- 실습 3-7) HAVING
-- Q. 국가별로 고객수가 5명 초과인 국가만 조회
-- (고객수기준내림차순)
-- tb_customer

SELECT country, COUNT(*) AS 고객수
FROM tb_customer
GROUP BY country
HAVING 고객수 > 2 -- 집계된 결과에 대해서 필터링
ORDER BY 고객수 DESC;

-- Q. 상품 수가 3개보다 많은 카테고리 조회
-- (상품수기준내림차순)
-- tb_product

SELECT category_id, COUNT(*) AS 상품수
FROM tb_product
GROUP BY category_id
HAVING 상품수 > 3
ORDER BY 상품수 DESC;

-- 실습 4-1) 서브쿼리
-- Q. 평균보다 비싼 상품 조회
-- tb_product
SELECT AVG(unit_price)
FROM tb_product;
-- -> 33.333

SELECT *
FROM tb_product
WHERE unit_price > -- 33.333 값 대신 쿼리
    (SELECT AVG(unit_price) FROM tb_product);

-- Q. 취소한 주문이 있는 고객 조회
-- tb_order, tb_customer
SELECT customer_id
FROM tb_order
WHERE status = 'CANCELED';

SELECT *
FROM tb_customer
WHERE customer_id IN (
    SELECT customer_id
    FROM tb_order
    WHERE status = 'CANCELED'
    );

-- 실습 4-2)
-- Q. 상품의 이름, 가격, 전체 평균 가격, 
-- 가격과 전체 평균 가격의 차이 조회
-- tb_product

SELECT AVG(unit_price)
FROM tb_product;

SELECT product_name, unit_price, 
    (SELECT AVG(unit_price) FROM tb_product) AS 평균가격,
    unit_price - (SELECT AVG(unit_price) FROM tb_product) AS 차이
FROM tb_product;

-- 실습 4-3
-- Q. 월 별 주문 건수를 구한 뒤, 주문 건수가 3건 이상인 달 조회
-- tb_order

SELECT MONTH(order_dt) AS m,
    COUNT(*) AS cnt
FROM tb_order
GROUP BY MONTH(order_dt);

SELECT m, cnt
FROM (
    SELECT MONTH(order_dt) AS m,
        COUNT(*) AS cnt
    FROM tb_order
    GROUP BY MONTH(order_dt)
) AS monthly_order
WHERE cnt >= 7;

-- 실습 4-4) EXISTS
-- Q. 주문한 적 있는 고객 조회
-- tb_order, tb_customer

SELECT *
FROM tb_customer AS c
WHERE EXISTS 
    (SELECT 1
    FROM tb_order AS o 
    WHERE o.customer_id = c.customer_id);
-- 주문테이블에서 고객의 id를 하나씩 확인해서 있으면 1 조회 (주문 개수만큼 나옴)
-- 주문이 존재하면, TRUE -> 해당 행은 조회되고
-- 없으면, FALSE가 나와서 필터링

-- Q. 한번도 주문 안 한 고객 조회
-- tb_order, tb_customer
SELECT *
FROM tb_customer AS c
WHERE NOT EXISTS 
    (SELECT 1
    FROM tb_order AS o 
    WHERE o.customer_id = c.customer_id);

-- 01 이름이 ‘박영희’인 고객의 이름과 등급, 회원가입일자 조회

SELECT customer_name, grade, signup_dt
FROM tb_customer
WHERE customer_name = '박영희';

-- 02 상품명에 ‘세’가 들어가고, 가격이 만원보다 큰 상품의 
-- 상품명과 가격을 가격이 비싼순으로 조회

SELECT product_name, unit_price
FROM tb_product
WHERE product_name LIKE '%세%'
    AND unit_price > 10000
ORDER BY unit_price DESC;

-- 03 카테고리별로 상품 가격의 합, 가장 비싼 상품가격, 
-- 가장 저렴한 상품 가격을 구하세요.

SELECT category_id, SUM(unit_price) AS 총합, 
    MAX(unit_price) AS 가장비싼,
    MIN(unit_price) AS 가장싼
FROM tb_product
GROUP BY category_id;

-- 04 카테고리 별로 총 재고가 300개가 넘을경우 많음, 아니면 적음이 표시된
-- 칼럼을 추가하고, 재고 수 많은 순서대로 조회

SELECT category_id,
    SUM(stock_qty) AS 총재고,
    CASE
        WHEN SUM(stock_qty) > 300 THEN '많음'
        ELSE '적음'
    END AS 수준
FROM tb_product
GROUP BY category_id
ORDER BY 총재고 DESC;

-- 05 국가별 고객수와 백분위(국가별고객수/ 전체고객수* 100)를 구하세요.

-- 전체 고객 수 먼저
SELECT COUNT(*)
FROM tb_customer;

SELECT country, COUNT(*) AS 고객수,
    (SELECT COUNT(*) FROM tb_customer) AS 전체고객수,
    COUNT(*) / (SELECT COUNT(*) FROM tb_customer) * 100 AS 백분위
FROM tb_customer
GROUP BY country;

-- 실습 5-1) INNER JOIN
-- Q. 주문 이력이 있는 고객명과 주문일 조회
-- tb_order, tb_customer

SELECT c.customer_name, o.order_dt
FROM tb_order AS o
    JOIN tb_customer AS c ON o.customer_id=c.customer_id;

-- 실습 5-2)
-- Q. 주문이 없는 고객은 주문id NULL로 고객명, 주문id 조회
-- tb_order, tb_customer

SELECT c.customer_name, o.order_id
FROM tb_customer AS c
    LEFT JOIN tb_order AS o ON c.customer_id=o.customer_id;

-- Q. 모든 상품의 상품별 총 판매 수량
-- tb_product, tb_order_item

SELECT p.product_name, IFNULL(SUM(qty), 0) AS 판매수량
FROM tb_product AS p
    LEFT JOIN tb_order_item AS oi ON oi.product_id=p.product_id
GROUP BY p.product_id;


-- 01 카테고리에 ‘식품’이 들어가는 상품 목록 조회

SELECT p.*, c.category_name
FROM tb_product AS p -- 기준 테이블은 PK 말고, id가 반복되는 테이블
    JOIN tb_category AS c ON p.category_id=c.category_id
WHERE c.category_name LIKE '%식품%';

-- 02 부산에 사는 고객의 주문 목록 조회

SELECT c.customer_name, c.city, o.*
FROM tb_customer AS c
    LEFT JOIN tb_order AS o ON o.customer_id=c.customer_id
WHERE c.city='부산';

-- 실습 6-1) 다중조인
-- Q. 취소되지 않은 주문의 고객명, 상품명, 품목수량, 주문금액조회
-- tb_order, tb_customer, tb_order_item, tb_product

SELECT c.customer_name, p.product_name, 
    oi.qty, 
    oi.qty*p.unit_price AS 주문금액
FROM tb_order AS o
    JOIN tb_customer AS c ON o.customer_id=c.customer_id
    JOIN tb_order_item AS oi ON oi.order_id=o.order_id
    JOIN tb_product AS p ON oi.product_id=p.product_id
WHERE o.status <> 'CANCELED';

-- SELECT c.customer_name, o.order_id, oi.product_id
-- FROM tb_order AS o
--     JOIN tb_customer AS c ON o.customer_id=c.customer_id
--     JOIN tb_order_item AS oi ON oi.order_id=o.order_id;

-- Q. 카테고리별 취소되지 않은 주문건 수 · 수량 · 매출을 
-- 매출 높은 순으로 조회
-- tb_order, tb_order_item, tb_product, tb_category

SELECT c.category_name, 
    COUNT(DISTINCT o.order_id) AS 주문건수,
    -- COUNT(o.order_id) AS 상세건수, ※ 주의
    SUM(oi.qty) AS 수량,
    SUM(oi.qty*oi.unit_price) AS 매출
FROM tb_order AS o
    JOIN tb_order_item AS oi ON o.order_id=oi.order_id
    JOIN tb_product AS p ON oi.product_id=p.product_id
    JOIN tb_category AS c ON p.category_id=c.category_id
WHERE o.status <> 'CANCELED'
GROUP BY c.category_id
ORDER BY 매출 DESC;

-- Q. 취소되지 않은 주문의 고객 별 구매액 TOP 5을 조회
-- tb_order, tb_customer, tb_order_item

SELECT c.customer_name, 
    SUM(oi.qty * oi.unit_price) AS 구매액
FROM tb_order AS o
    JOIN tb_customer AS c ON o.customer_id=c.customer_id
    JOIN tb_order_item AS oi ON oi.order_id=o.order_id
WHERE o.status <> 'CANCELED'
GROUP BY c.customer_id
ORDER BY 구매액 DESC
LIMIT 5;

-- VIEW
CREATE OR REPLACE VIEW v_order_detail AS
SELECT o.order_id, o.order_dt, c.customer_name,
    p.product_name, i.qty,
    i.qty * i.unit_price AS amount
FROM tb_order o
    JOIN tb_customer c ON o.customer_id= c.customer_id
    JOIN tb_order_item i ON o.order_id = i.order_id
    JOIN tb_product p ON i.product_id = p.product_id;

SELECT product_name, SUM(amount) 
FROM v_order_detail
GROUP BY product_name;
