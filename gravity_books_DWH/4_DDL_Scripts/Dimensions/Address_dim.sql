CREATE TABLE Address_Dim (
    -- Surrogate Key: Primary Key with Auto-increment
    address_sk INT IDENTITY(1,1) PRIMARY KEY,
    
    -- Business Key from Source System
    address_id INT,
    
    -- Attributes
    country_id INT,
    street_name VARCHAR(200),
    street_number VARCHAR(50),
    city VARCHAR(100),
    country_name VARCHAR(200),
    full_address VARCHAR(200),
    
    -- SCD Type 2 Tracking Columns
    start_date DATETIME,
    end_date DATETIME,
    is_current TINYINT, -- 1 for current, 0 for historical
    ssc TINYINT         -- Source System Code (optional)
);