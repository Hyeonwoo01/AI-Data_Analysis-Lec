
CREATE TABLE tb_station(
    id INT PRIMARY KEY, -- 108
    name VARCHAR(255),  -- 서울

    UNIQUE (name)
);

CREATE TABLE tb_temperature(
    id BIGINT AUTO_INCREMENT PRIMARY KEY, 
    station_id INT,

    -- 기온정보들
    average DOUBLE,
    minimum DOUBLE,
    maximum DOUBLE,

    minimum_time VARCHAR(255),
    maximum_time VARCHAR(255),
    
    observed_dt DATE,

    UNIQUE (station_id, observed_dt),
    FOREIGN KEY(station_id) REFERENCES tb_station(id)
);

-- ALTER (중복데이터가 이미 있으면 실행안됨.)
ALTER TABLE tb_temperature ADD CONSTRAINT UNIQUE (station_id, observed_dt);
-- 중복데이터 제거하는 transaction (데이터를 날릴 수 없을 때 - 운영)

-- DROP -> CREATE (데이터 다 날라감)
DROP TABLE tb_temperature;



CREATE TABLE tb_rain(
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    station_id INT,

    -- 강수량 정보들

    observed_dt DATE,

    FOREIGN KEY(station_id) REFERENCES tb_station(id)
);
