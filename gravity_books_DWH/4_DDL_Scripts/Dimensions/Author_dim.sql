CREATE TABLE Author_DIM (
    Author_SK INT IDENTITY(1,1) PRIMARY KEY, 
    Author_ID INT NOT NULL,                 
    Author_name VARCHAR(400),
    start_date DATETIME,
    end_date DATETIME,
    ssc TINYINT,
    is_current TINYINT
);