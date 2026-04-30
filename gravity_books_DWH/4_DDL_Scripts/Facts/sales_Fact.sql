USE [gravity_books_DWH]
GO

CREATE TABLE [dbo].[Sales_Fact](
    [Sales_fact_SK] [int] IDENTITY(1,1) NOT NULL, 
    [Line_ID] [int] NULL,
    [Order_ID] [int] NULL,
    [Customer_SK] [int] NULL,
    [Book_SK] [int] NULL,
    [Dest_Address_SK] [int] NULL,
    [Shipping_Method_SK] [int] NULL,
    [Date_SK] [int] NULL,
    [Time_SK] [int] NULL,
    [Status_Sk] [int] NULL,
    [price] [decimal](5, 2) NULL,
 CONSTRAINT [PK_Sales_Fact] PRIMARY KEY CLUSTERED ([Sales_fact_SK] ASC)
) ON [PRIMARY];
GO


ALTER TABLE [dbo].[Sales_Fact] WITH CHECK ADD CONSTRAINT [FK_Sales_Fact_Address_Dim] FOREIGN KEY([Dest_Address_SK])
REFERENCES [dbo].[Address_Dim] ([address_sk]);

ALTER TABLE [dbo].[Sales_Fact] WITH CHECK ADD CONSTRAINT [FK_Sales_Fact_Book_DIM] FOREIGN KEY([Book_SK])
REFERENCES [dbo].[Book_DIM] ([book_SK]);

ALTER TABLE [dbo].[Sales_Fact] WITH CHECK ADD CONSTRAINT [FK_Sales_Fact_Customer_Dim] FOREIGN KEY([Customer_SK])
REFERENCES [dbo].[Customer_Dim] ([Customer_SK]);

ALTER TABLE [dbo].[Sales_Fact] WITH CHECK ADD CONSTRAINT [FK_Sales_Fact_Dim_Date] FOREIGN KEY([Date_SK])
REFERENCES [dbo].[Dim_Date] ([Date_SK]);

ALTER TABLE [dbo].[Sales_Fact] WITH CHECK ADD CONSTRAINT [FK_Sales_Fact_Dim_Time] FOREIGN KEY([Time_SK])
REFERENCES [dbo].[Dim_Time] ([Time_SK]);

ALTER TABLE [dbo].[Sales_Fact] WITH CHECK ADD CONSTRAINT [FK_Sales_Fact_Shipping_method_dim] FOREIGN KEY([Shipping_Method_SK])
REFERENCES [dbo].[Shipping_method_dim] ([shipping_method_SK]);

ALTER TABLE [dbo].[Sales_Fact] WITH CHECK ADD CONSTRAINT [FK_Sales_Fact_Status_Junk_Dim] FOREIGN KEY([Status_Sk])
REFERENCES [dbo].[Status_Junk_Dim] ([Status_Sk]);
GO


ALTER TABLE [dbo].[Sales_Fact] CHECK CONSTRAINT ALL;
GO