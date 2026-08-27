CREATE DATABASE IF NOT EXISTS weather_db DEFAULT CHARACTER SET utf8mb4;

USE weather_db;

CREATE TABLE raw_item(
    raw_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    source VARCHAR(50) NOT NULL,                -- 수집 출처
    url TEXT,                                   -- 요청 URL
    collected_at DATETIME NOT NULL,             -- 수집 일시
    payload LONGTEXT NOT NULL,                  -- 응답 원본 데이터
    content_hash CHAR(64) NOT NULL,             -- 중복 체크할 Unique한 값
    UNIQUE KEY uq_hash(content_hash),
    KEY idx_source_date(source, collected_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- CLEAN (ERD)
-- CREATE TABLE tb_ (
-- );