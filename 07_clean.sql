
CREATE TABLE tb_station(
    id INT PRIMARY KEY,
    name VARCHAR(255)

    UNIQUE (name)
);

-- CREATE TABLE tb_weather()

CREATE TABLE tb_temperature(
    id, 
    station_id,

    FOREIGN KEY(station_id) REFERENCES tb_station(id)
);
CREATE TABLE tb_rain();
