-- 데이터베이스 생성
CREATE DATABASE study_db
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_unicode_ci;

-- 데이터베이스 목록 조회
SHOW DATABASES;

-- 데이터베이스 사용
USE study_db;

-- 사용자 생성
CREATE USER 'analyst'@'localhost' IDENTIFIED BY 'test1234';
-- 주소 자리에 올 수 있는 것
-- 특정 IP: 192.33.223.123
-- 전체 주소: %
-- 내 컴퓨터: localhost

-- 권한 부여
GRANT ALL PRIVILEGES ON study_db.* TO 'analyst'@'localhost';
-- ALL PRIVILEGES: 모든 권한
-- SELECT: SELECT 권한만

SHOW GRANTS FOR 'analyst'@'localhost';


-- 날짜 시간 관련 주요 함수
SELECT NOW() AS now_dt,
    CURDATE() AS today,
    DATE_FORMAT(NOW(), '%Y-%m-%d %H:%i') AS dt_format,
    DATE_ADD(NOW(), INTERVAL 7 DAY) AS next_7day,
    DATEDIFF('2026-12-25', CURDATE()) AS christmas_dday,
    YEAR(NOW()), MONTH(NOW()), DAY(NOW()),
    HOUR(NOW()), MINUTE(NOW()), DAYOFWEEK(NOW()),
    ELT(DAYOFWEEK(NOW()), '일', '월', '화', '수', '목', '금', '토')
;
-- | 2026-08-07 13:13:23 
-- | 2026-08-07 
-- | 2026-08-07 13:13 
-- | 2026-08-14 13:13:23 
-- |            140
-- | 2026 |  8 |  7
-- |   13 | 13 |  6
-- | 금

-- 실습 5-1) 테이블을 두 개 생성해주세요

USE study_db;

CREATE TABLE tb_student(
    student_id INT NOT NULL AUTO_INCREMENT,
    name VARCHAR(16) NOT NULL,
    age INT,
    address VARCHAR(255),
    PRIMARY KEY(student_id)
);

CREATE TABLE tb_grade(
    student_id INT, -- student table의 student_id와 data type 동일하게
    math INT,
    science INT,
    english INT
);

-- 실습 5-2) 

-- 테이블 목록 조회
-- SHOW TABLES;
-- 특정 테이블의 칼럼 정보 조회
-- SHOW FULL COLUMNS FROM tb_student;

-- 학생 테이블에 이메일 컬럼을 추가해주세요. (ADD COLUMN)
ALTER TABLE tb_student ADD COLUMN email VARCHAR(255);

-- 학생 테이블의 이름 칼럼의 타입을 수정해주세요. (MODIFY)
ALTER TABLE tb_student MODIFY name VARCHAR(32);

-- 학생 테이블의 주소 칼럼을 addr로 바꾸고, 타입도 같이 변경해주세요(CHANGE)
ALTER TABLE tb_student CHANGE address addr VARCHAR(128);

-- 학생 테이블의 이메일 칼럼을 삭제해주세요. (DROP COLUMN)
ALTER TABLE tb_student DROP COLUMN email;

-- 실습 5-3) 각 테이블에 데이터를 입력해주세요.

--학생테이블
INSERT INTO tb_student(name, age, addr)
    VALUES ('홍길동', 30, '인천');

INSERT INTO tb_student(name, age, addr)
    VALUES ('이연걸', 60, '서울'),
        ('이몽룡', 42, '대전'),
        ('성춘향', 27, '경기');

-- 기본 조회
SELECT * FROM tb_student;

--성적테이블
INSERT INTO tb_grade(student_id, math, english, science)
    VALUES (1, 90, 80, 50),
        (2, 69, 76, 65),
        (3, 98, 87, 97),
        (4, 87, 67, 79);

-- -- Foreign Key 설정
-- ALTER TABLE tb_grade 
--     ADD CONSTRAINT fk_student_grade 
--         FOREIGN KEY (student_id) REFERENCES tb_student(student_id);

-- INSERT INTO tb_grade(student_id, math, english, science)
--     VALUES (5, 90, 80, 50);

-- 실습 5-4)
-- 성적 테이블에서 수학 점수가 70점 미만인 학생의 점수를 70점으로 수정해주세요
SELECT * 
FROM tb_grade 
WHERE math < 70;

UPDATE tb_grade 
    SET math = 70 
WHERE math < 70;

-- FK 제약조건을 통해, 학생 테이블에 있는 id만 성적 테이블에 추가할 수 있었음.
-- 만약 반대로, 학생을 지우려고 할 때 해당 학생의 성적 데이터가 있으면 
--      참조 무결성이 깨지기 때문에 삭제할 수 없다.


-- 실습 6-1)
-- Q. 고객의 이름과 국가를 조회
-- tb_customer
SELECT customer_name, country
FROM tb_customer;

-- 칼럼 확인용
SELECT * FROM tb_customer LIMIT 2;
SHOW FULL COLUMNS FROM tb_customer;

-- Q. 고객의 정보 전체 조회
-- tb_customer
SELECT * FROM tb_customer;

-- 실습 6-2)
-- Q. 고객의 국가 목록 조회(중복 없이)
-- tb_customer

SELECT DISTINCT country
FROM tb_customer;

-- Q. 고객의 국가, 도시 목록 조회(중복 없이)
-- tb_customer
SELECT DISTINCT country, city
FROM tb_customer;

-- 실습 6-3)

-- Q. 고객 이름을 오름차순으로 조회
-- tb_customer

SELECT customer_name
FROM tb_customer
ORDER BY customer_name ASC;

-- Q. 상품 가격 내림차순으로 조회
-- tb_product

-- 칼럼 확인
SELECT * FROM tb_product LIMIT 2;

SELECT product_name, unit_price
FROM tb_product
ORDER BY unit_price DESC;

-- Q. 카테고리별로 비싼순으로 조회
-- tb_product

SELECT category_id, product_name, unit_price
FROM tb_product
ORDER BY category_id ASC, unit_price DESC;

-- category_id = 1 -> 가격 비싼 순
-- category_id = 2 -> 가격 비싼 순

-- 실습 6-4)

-- Q. 고객 5명만 조회
-- tb_customer
SELECT *
FROM tb_customer
-- ORDER BY
LIMIT 5;

-- Q. 그 다음 5명 조회
-- tb_customer
SELECT *
FROM tb_customer
-- ORDER BY
LIMIT 5
OFFSET 5;

-- Q. 판매 가격 TOP 3 조회
-- tb_product

SELECT *
FROM tb_product
ORDER BY unit_price DESC
LIMIT 3;
