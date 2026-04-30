
CREATE TABLE Shipping_method_dim (
    shipping_method_SK INT IDENTITY(1,1) PRIMARY KEY,
    Method_id INT,             
    method_name VARCHAR(100),
    shipping_fixed_cost DECIMAL(6,2),
    start_date DATETIME,
    end_date DATETIME,
    ssc tinyINT,
    is_current TINYINT           
);