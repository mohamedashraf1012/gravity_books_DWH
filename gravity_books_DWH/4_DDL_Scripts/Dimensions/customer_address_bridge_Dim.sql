-- =============================================
--  Create Customer-Address Bridge Table
-- =============================================
CREATE TABLE customer_address_bridge_Dim (
    -- Surrogate Key for the bridge relationship
    customer_address_SK INT IDENTITY(1,1) PRIMARY KEY,
    
    -- Foreign Keys
    customer_sk INT NOT NULL,
    address_sk INT NOT NULL,
    
    -- Relationship Attributes
    status_id INT,
    address_status VARCHAR(30),
    
    -- Tracking columns
    start_date DATETIME,
    end_date DATETIME,
    is_current TINYINT,
    
    -- Unique constraint to prevent duplicate address assignment per customer
    CONSTRAINT UQ_Customer_Address UNIQUE (customer_sk, address_sk),
    
    -- Foreign Key constraints
    CONSTRAINT FK_Cust_Bridge FOREIGN KEY (customer_sk) REFERENCES Customer_Dim(Customer_SK),
    CONSTRAINT FK_Addr_Bridge FOREIGN KEY (address_sk) REFERENCES Address_Dim(address_sk)
);
