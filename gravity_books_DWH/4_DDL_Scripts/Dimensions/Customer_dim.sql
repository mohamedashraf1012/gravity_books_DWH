-- Create Customer Dimension Table
CREATE TABLE Customer_Dim (
    -- Surrogate Key: Auto-incremented primary key for the Data Warehouse
    Customer_SK INT IDENTITY(1,1) PRIMARY KEY,
    
    -- Business Key: Original ID from the source system
    Customer_ID INT NOT NULL,
    
    -- Customer Attributes
    First_Name VARCHAR(200),
    Last_Name VARCHAR(200),
    Full_Name VARCHAR(200),
    Email VARCHAR(350),
    
    -- Metadata and SCD Type 2 Tracking Columns
    ssc TINYINT,            -- Source System Code
    start_date DATETIME,    -- Record validity start date
    end_date DATETIME,      -- Record validity end date
    is_current TINYINT      -- Flag: 1 for current record, 0 for historical
);
