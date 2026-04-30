<div align="center">

<img src="https://readme-typing-svg.demolab.com?font=Fira+Code&weight=700&size=30&duration=3000&pause=1000&color=00D4FF&center=true&vCenter=true&width=600&lines=GravityBooks+DWH+%F0%9F%93%9A;End-to-End+Data+Warehouse;Kimball+Approach+%E2%9C%85" alt="Typing SVG" />

<br/>

![GitHub last commit](https://img.shields.io/github/last-commit/mohamedashraf1012/gravity_books_DWH?style=for-the-badge&color=00D4FF&labelColor=0d1117)
![GitHub repo size](https://img.shields.io/github/repo-size/mohamedashraf1012/gravity_books_DWH?style=for-the-badge&color=7C3AED&labelColor=0d1117)
![License](https://img.shields.io/badge/License-MIT-green?style=for-the-badge&labelColor=0d1117)
![Status](https://img.shields.io/badge/Status-Completed%20✅-brightgreen?style=for-the-badge&labelColor=0d1117)

<br/>

> **📦 A full end-to-end Data Warehouse solution built on the GravityBooks OLTP system**  
> *Business Analysis → DWH Design → ETL → OLAP Cube*

</div>

---

## 🗺️ Project Roadmap

```
📋 Business Requirements
        ↓
🔍 Source System Analysis (OLTP)
        ↓
🏗️ DWH Design — Kimball Approach (Star Schema)
        ↓
🗄️ DDL Scripts (SSMS)
        ↓
⚙️ ETL Pipeline (SSIS)
        ↓
📊 OLAP Cube & Analysis (SSAS)
```

---

## 🛠️ Tech Stack

<div align="center">

| Tool | Purpose |
|------|---------|
| ![SQL Server](https://img.shields.io/badge/SQL%20Server-CC2927?style=for-the-badge&logo=microsoftsqlserver&logoColor=white) | Source OLTP & DWH Database |
| ![SSIS](https://img.shields.io/badge/SSIS-0078D4?style=for-the-badge&logo=microsoft&logoColor=white) | ETL Pipeline |
| ![SSAS](https://img.shields.io/badge/SSAS-0078D4?style=for-the-badge&logo=microsoft&logoColor=white) | OLAP Cube & Analysis |
| ![Excel](https://img.shields.io/badge/Excel-217346?style=for-the-badge&logo=microsoftexcel&logoColor=white) | Source-to-Destination Mapping |
| ![Draw.io](https://img.shields.io/badge/Draw.io-F08705?style=for-the-badge&logo=diagramsdotnet&logoColor=white) | ERD & Flow Diagrams |

</div>

---

## 📁 Repository Structure

```
📦 gravity_books_DWH
 ┣ 📂 1_Business_Requirements
 ┃ ┗ 📄 business_questions.md
 ┣ 📂 2_Source_System_OLTP
 ┃ ┣ 📂 ERD_Source
 ┃ ┃  ┗ 🖼️ gravitybooks_source_erd.png
 ┃ ┗ 📂 Source_backup
 ┃   ┗ 📄gravity_books_oltp.bak
 ┣ 📂 3_DWH_Design
 ┃ ┣ 📂 ERD_Destination
 ┃ ┃ ┗ 🖼️ gravitybooks_dwh_erd.png
 ┃ ┣ 📄 Approach.md
 ┃ ┣ 📂 Mapping
 ┃ ┃ ┣ 📊 mapping_excel.xlsx
 ┃ ┃ ┗ 🗺️ mapping_drawio.drawio
 ┃ ┗ 📂 DWH_backup
 ┃   ┗ 📄gravity_books_dwh_olap.bak
 ┣ 📂 4_DDL_Scripts
 ┃ ┣ 📂 Dimensions
 ┃ ┃ ┣ 📄 create_address_dim.sql
 ┃ ┃ ┣ 📄 create_author_dim.sql
 ┃ ┃ ┣ 📄 create_book_dim.sql
 ┃ ┃ ┣ 📄 create_customer_dim.sql
 ┃ ┃ ┣ 📄 create_shipping_method_dim.sql
 ┃ ┃ ┣ 📄 create_status_junk_dim.sql
 ┃ ┃ ┗ 📄 create_date_dim.sql
 ┃ ┗ 📂 Facts
 ┃   ┣ 📄 create_sales_fact.sql
 ┃   ┗ 📄 create_order_history_factless_fact.sql
 ┣ 📂 5_ETL_SSIS
 ┃ ┣ 📄 address_dim_v001.dtsx
 ┃ ┣ 📄 author_dim_v001.dtsx
 ┃ ┣ 📄 Book_Dim_v001.dtsx
 ┃ ┣ 📄 customer_dim_v001.dtsx
 ┃ ┣ 📄 Shipping_method_dim_v001.dtsx
 ┃ ┣ 📄 status_dim_v001.dtsx
 ┃ ┣ 📄 Sales_fact_v001.dtsx
 ┃ ┗ 📄 Order_History_Factless_Fact_v001.dtsx
 ┣ 📂 6_SSAS
 ┃ ┣ 📄 Gravity_Books_DWH_view.cube
 ┃ ┣ 📄 Gravity_Books_DWH_view.dsv
 ┃ ┣ 📄 Address_DIM.dim
 ┃ ┣ 📄 Book_DIM.dim
 ┃ ┣ 📄 Customer_Dim.dim
 ┃ ┣ 📄 Dim_Date.dim
 ┃ ┣ 📄 Dim_Time.dim
 ┃ ┣ 📄 Shipping_Method_Dim.dim
 ┃ ┗ 📄 Status_Junk_Dim.dim
 ┗ 📂 7_Screenshots
   ┣ 📂 data_flow_tasks
   ┣ 📂 cube
   ┣ 📂 data_source_view
   ┗ 📂 mapping
```

---

## 🏗️ DWH Schema Design

### ⭐ Star Schema Overview

```
                    ┌─────────────────┐
                    │   Author_DIM    │
                    │─────────────────│
                    │ author_id (PK)  │
                    │ author_name     │
                    └────────┬────────┘
                             │
        ┌────────────────────┼────────────────────┐
        │                    │                    │
┌───────┴───────┐   ┌────────┴────────┐   ┌──────┴────────┐
│  Book_DIM     │   │  Customer_DIM   │   │  Address_DIM  │
│───────────────│   │─────────────────│   │───────────────│
│ book_pk (PK)  │   │ customer_pk(PK) │   │ address_pk(PK)│
│ title         │   │ first_name      │   │ street        │
│ isbn13        │   │ last_name       │   │ city          │
│ publisher     │   │ email           │   │ country       │
└───────┬───────┘   └────────┬────────┘   └──────┬────────┘
        │                    │                    │
        └────────────────────┼────────────────────┘
                             │
                    ┌────────┴────────┐
                    │   Sales_FACT    │  ← Main Fact Table
                    │─────────────────│
                    │ order_id (FK)   │
                    │ book_pk (FK)    │
                    │ customer_pk(FK) │
                    │ address_pk (FK) │
                    │ date_key (FK)   │
                    │ price           │
                    │ quantity        │
                    └─────────────────┘
```

---

## 📊 Dimensions & Facts

### 📐 Dimension Tables

| Table | Type | Description |
|-------|------|-------------|
| `Book_DIM` | Standard SCD | Books with publisher & language info |
| `Author_DIM` | Standard | Author details |
| `Customer_DIM` | Standard SCD | Customer information |
| `Address_DIM` | Standard | Shipping/billing addresses |
| `Shipping_Method_DIM` | Standard | Delivery methods |
| `Status_Junk_DIM` | **Junk** | Order status flags combined |
| `Date_DIM` | Role-Playing | Calendar date dimension |

### 📈 Fact Tables

| Table | Type | Grain |
|-------|------|-------|
| `Sales_Fact` | Transactional | One row per order line item |
| `Order_History_Factless_Fact` | **Factless** | Order events tracking |

### 🔗 Bridge Tables

| Table | Purpose |
|-------|---------|
| `Book_Author_Bridge_DIM` | Many-to-many: Books ↔ Authors |
| `Customer_Address_Bridge_DIM` | Many-to-many: Customers ↔ Addresses |

---

## ⚙️ ETL Pipeline (SSIS)

Each SSIS package follows this standard flow:

```
[OLE DB Source]
  (GravityBooks OLTP)
       │
       ▼
[Data Transformations]
  • Derived Columns (SCD dates, flags)
  • Lookups (surrogate keys)
  • Data Conversions
       │
       ▼
[Slowly Changing Dimension]
  (Type 1 / Type 2 as needed)
       │
       ▼
[OLE DB Destination]
  (GravityBooks_DWH)
```

**Load Order:**
1. `date_dim` → `address_dim` → `author_dim`
2. `book_dim` → `customer_dim` → `shipping_method_dim` → `status_dim`
3. `book_author_bridge` → `customer_address_bridge`
4. `order_history_factless_fact` → `sales_fact`

---

## 📊 SSAS Cube

**Cube:** `Gravity_Books_DWH_view`

**Measures:**
- Total Sales Amount
- Quantity Sold
- Order Count
- Distinct Customer Count

**Dimensions linked:**
- Book, Author, Customer, Address, Date, Shipping Method, Status

---

## 📸 Screenshots

<details>
<summary>📌 Click to view project diagrams</summary>

### Source ERD (OLTP)
> 📂 `2_Source_System_OLTP/ERD_Source/`

### DWH ERD (Destination)
> 📂 `3_DWH_Design/ERD_Destination/`

### SSIS Data Flow Tasks
> 📂 `7_Screenshots/data_flow_tasks/`

### SSAS Cube & Data Source View
> 📂 `7_Screenshots/cube/` & `7_Screenshots/data_source_view/`

### 📊 Analytics Dashboard
> 📂 [`gravity_books_dashboard.html`](./7_Screenshots/gravity_books_dashboard.html)

### Source-to-Destination Mapping
> 📂 `3_DWH_Design/Mapping/`

</details>

---

## 🚀 How to Run

### 1️⃣ Restore Databases
```sql
-- Restore OLTP Source
RESTORE DATABASE [GravityBooks]
FROM DISK = 'path\to\GravityBooks.bak'

-- Restore DWH
RESTORE DATABASE [GravityBooks_DWH]
FROM DISK = 'path\to\GravityBook_dwh.bak'
```

### 2️⃣ Run DDL Scripts
```
Execute scripts in order from:
📂 4_DDL_Scripts/Dimensions/ → then 📂 4_DDL_Scripts/Facts/
```

### 3️⃣ Run SSIS Packages
```
Open: 5_ETL_SSIS/gravity_books_DWH.dtproj in Visual Studio
Run packages in the load order shown above
```

### 4️⃣ Deploy SSAS Cube
```
Open: 6_SSAS/GravityBooks_SSAS.dwproj in Visual Studio
Deploy → Process → Browse in Excel or SSMS
```

---

## 📬 Contact

<div align="center">

[![LinkedIn](https://img.shields.io/badge/LinkedIn-0A66C2?style=for-the-badge&logo=linkedin&logoColor=white)](https://linkedin.com/in/mohamedashraf1012)
[![GitHub](https://img.shields.io/badge/GitHub-181717?style=for-the-badge&logo=github&logoColor=white)](https://github.com/mohamedashraf1012)

</div>

---

<div align="center">

**⭐ If you found this project helpful, please give it a star!**

*Built with ❤️ using SQL Server · SSIS · SSAS · Kimball Methodology*

</div>
