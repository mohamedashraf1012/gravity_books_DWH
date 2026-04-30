# 📋 Business Requirements & Questions
## GravityBooks Data Warehouse Project

> **Approach:** Kimball Dimensional Modeling (Bottom-Up)  
> **Source System:** GravityBooks OLTP Database  
> **Goal:** Build a DWH that enables analytical reporting on book sales, customer behavior, and order operations.

---

## 🎯 Business Goals

The GravityBooks business needs to move from **operational reporting** (OLTP) to **analytical decision-making** (DWH) by answering strategic questions across four key domains:

| Domain | Focus |
|--------|-------|
| 📚 Sales Performance | Revenue, top books, pricing trends |
| 👤 Customer Behavior | Purchase patterns, loyalty, geography |
| 📦 Order Operations | Fulfillment, shipping, order history |
| ✍️ Catalog Intelligence | Author performance, genre trends |

---

## ❓ Business Questions

### 📚 1. Sales & Revenue Analysis

| # | Business Question | Fact Table | Key Dimensions |
|---|-------------------|------------|----------------|
| 1 | What is the **total revenue** generated per month / quarter / year? | Sales_Fact | Date_DIM |
| 2 | Which **books generate the highest revenue**? | Sales_Fact | Book_DIM |
| 3 | What is the **average order value** over time? | Sales_Fact | Date_DIM |
| 4 | Which **price range** of books sells the most? | Sales_Fact | Book_DIM |
| 5 | What is the **total quantity sold** per book per period? | Sales_Fact | Book_DIM, Date_DIM |
| 6 | Which **publishers** contribute most to revenue? | Sales_Fact | Book_DIM |
| 7 | How does **sales performance** compare across different time periods (YoY, MoM)? | Sales_Fact | Date_DIM |

---

### 👤 2. Customer Behavior Analysis

| # | Business Question | Fact Table | Key Dimensions |
|---|-------------------|------------|----------------|
| 8 | Who are the **top customers** by total spend? | Sales_Fact | Customer_DIM |
| 9 | What is the **geographic distribution** of customers (city / country)? | Sales_Fact | Address_DIM, Customer_DIM |
| 10 | Which **countries / cities generate the most revenue**? | Sales_Fact | Address_DIM |
| 11 | How many **unique customers** placed orders per month? | Sales_Fact | Customer_DIM, Date_DIM |
| 12 | What is the **average number of orders per customer**? | Sales_Fact | Customer_DIM |
| 13 | Which customers have **not ordered in the last 6 months** (churn risk)? | Order_History_Factless_Fact | Customer_DIM, Date_DIM |

---

### 📦 3. Order Operations Analysis

| # | Business Question | Fact Table | Key Dimensions |
|---|-------------------|------------|----------------|
| 14 | What is the **total number of orders** placed per period? | Order_History_Factless_Fact | Date_DIM |
| 15 | What is the **distribution of orders by status** (pending, shipped, delivered, cancelled)? | Order_History_Factless_Fact | Status_Junk_DIM |
| 16 | Which **shipping method** is most frequently used? | Sales_Fact | Shipping_Method_DIM |
| 17 | What is the **order fulfillment trend** over time? | Order_History_Factless_Fact | Date_DIM, Status_Junk_DIM |
| 18 | How many orders were **cancelled** and what is the cancellation rate? | Order_History_Factless_Fact | Status_Junk_DIM, Date_DIM |
| 19 | What is the **average time between order events** (order → ship → deliver)? | Order_History_Factless_Fact | Date_DIM |

---

### ✍️ 4. Catalog & Author Intelligence

| # | Business Question | Fact Table | Key Dimensions |
|---|-------------------|------------|----------------|
| 20 | Which **authors have the highest total book sales**? | Sales_Fact | Author_DIM, Book_Author_Bridge |
| 21 | How many **books per author** are in the catalog? | Sales_Fact | Author_DIM, Book_Author_Bridge |
| 22 | Which **languages** do the best-selling books belong to? | Sales_Fact | Book_DIM |
| 23 | What is the **publication year trend** of top-selling books (newer vs older)? | Sales_Fact | Book_DIM, Date_DIM |
| 24 | Which **publishers produce the most ordered books**? | Sales_Fact | Book_DIM |

---

## 🏗️ Dimensional Model Decisions

Based on the business questions above, the following design decisions were made:

### Fact Tables Selected

```
✅ Sales_Fact               → Answers: Revenue, Quantity, Order Value questions
✅ Order_History_Factless   → Answers: Order events, Status, Fulfillment questions
```

### Why Factless Fact?
> Order history events (placed, shipped, delivered) carry **no natural measures**.  
> A Factless Fact table captures the **existence of events** and allows counting as the measure.

### Junk Dimension — Status_Junk_DIM
> Order status flags (is_shipped, is_cancelled, is_delivered) are low-cardinality booleans.  
> Combining them into a **Junk Dimension** avoids polluting the fact table with many small flag columns.

### Bridge Tables Used
| Bridge | Reason |
|--------|--------|
| `Book_Author_Bridge_DIM` | A book can have **multiple authors** → Many-to-Many |
| `Customer_Address_Bridge_DIM` | A customer can have **multiple addresses** → Many-to-Many |

### SCD Strategy
| Dimension | SCD Type | Reason |
|-----------|----------|--------|
| Book_DIM | Type 1 | Overwrite — price corrections acceptable |
| Customer_DIM | Type 1 | Overwrite — contact info updates |
| Address_DIM | Type 1 | Overwrite |
| Author_DIM | Type 1 | Overwrite |
| Shipping_Method_DIM | Type 1 | Static, rarely changes |
| Status_Junk_DIM | Type 1 | Fixed set of combinations |
| Date_DIM | Static | Pre-populated, never changes |

---

## 📐 Kimball Bus Matrix

|  | Book_DIM | Author_DIM | Customer_DIM | Address_DIM | Shipping_Method_DIM | Status_Junk_DIM | Date_DIM |
|--|----------|------------|--------------|-------------|---------------------|-----------------|----------|
| **Sales_Fact** | ✅ | ✅ (via bridge) | ✅ | ✅ | ✅ | ✅ | ✅ |
| **Order_History_Factless_Fact** | ✅ | ❌ | ✅ | ❌ | ✅ | ✅ | ✅ |

---

## ✅ Success Criteria

The DWH is considered successful when it can answer:

- [x] Revenue reports by book, author, publisher, time period
- [x] Customer segmentation by geography and purchase behavior  
- [x] Order fulfillment and status tracking over time
- [x] Shipping method usage analysis
- [x] Author and catalog performance reporting
- [x] All queries run via SSAS cube without hitting the OLTP system

---

*📁 Part of the GravityBooks End-to-End Data Warehouse Project*  
*🛠️ Tools: SQL Server · SSIS · SSAS · Kimball Approach*