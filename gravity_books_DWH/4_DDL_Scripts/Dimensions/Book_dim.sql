CREATE TABLE Book_DIM (
    book_SK INT IDENTITY(1,1) PRIMARY KEY,   
    book_PK INT NOT NULL,                    
    pubilisher_pk INT,
    Language_pk INT,
    title VARCHAR(400),
    isbn13 VARCHAR(50),
    num_pages INT,
    pubilication_date DATE,
    language_code VARCHAR(50),
    language_name VARCHAR(50),
    publisher_name NVARCHAR(1000),           
    start_date DATETIME,
    end_date DATETIME,
    is_current TINYINT,
    ssc TINYINT
);