CREATE TABLE Order_History_Factless_Fact (
    order_history_sk INT IDENTITY(1,1) PRIMARY KEY, 
    History_ID INT NULL,
    Order_ID INT NULL,
    Status_SK INT NULL,
    Date_SK INT NULL,
    Time_SK INT NULL
);