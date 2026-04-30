# 🏗️ DWH Design Approach
## GravityBooks Data Warehouse Project

---

## ⚡ Chosen Approach: Kimball (Bottom-Up)

```
Why Kimball? Because business users need fast answers — not a perfect normalized model.
```

| Criteria | Inmon (Top-Down) | ✅ Kimball (Bottom-Up) |
|----------|-----------------|----------------------|
| Starting point | Enterprise-wide model first | Business question first |
| Time to first value | Long | **Short** |
| Complexity | High | **Moderate** |
| End-user accessibility | Low | **High** |
| Suitable for | Large enterprises | **Departmental / project scope** |
| Our case | ❌ | ✅ |

> **Decision:** Kimball was chosen because GravityBooks is a single-domain project (bookstore sales),  
> and we needed to deliver analytical value quickly from a well-understood OLTP source.

---

## 📐 Dimensional Modeling — Star Schema

The core modeling technique used is **Star Schema**, following Kimball's four-step process:

### Step 1 — Select the Business Process

Two business processes were identified:

```
Process 1: Book Sales Transactions     → Sales_Fact
Process 2: Order Lifecycle Tracking    → Order_History_Factless_Fact
```

---

### Step 2 — Declare the Grain

> The grain is the most atomic level of data the fact table will store.

| Fact Table | Grain |
|------------|-------|
| `Sales_Fact` | **One row per order line item** (one book in one order) |
| `Order_History_Factless_Fact` | **One row per order status event** |

> ⚠️ Grain was declared BEFORE choosing measures or dimensions — this is mandatory in Kimball.

---

### Step 3 — Identify the Dimensions

Dimensions answer the **"who, what, where, when, how"** of each business process:

| Dimension | Answers | Type |
|-----------|---------|------|
| `Book_DIM` | What was sold? | Standard |
| `Author_DIM` | Who wrote it? | Standard |
| `Customer_DIM` | Who bought it? | Standard |
| `Address_DIM` | Where was it shipped? | Standard |
| `Shipping_Method_DIM` | How was it shipped? | Standard |
| `Status_Junk_DIM` | What was the order status? | **Junk** |
| `Date_DIM` | When did it happen? | Role-Playing |

---

### Step 4 — Identify the Facts (Measures)

> Only additive and semi-additive measures are stored in fact tables.

| Fact Table | Measures | Additive? |
|------------|---------|-----------|
| `Sales_Fact` | `price`, `quantity` | ✅ Fully Additive |
| `Sales_Fact` | (derived) `revenue = price × quantity` | ✅ Fully Additive |
| `Order_History_Factless_Fact` | *(no numeric measures)* | — |

---

## 🔗 Special Design Patterns Used

### 1. Factless Fact Table — `Order_History_Factless_Fact`

```
Problem:  Order lifecycle events (placed → shipped → delivered) have no natural measures.
Solution: A Factless Fact table records the EXISTENCE of events.
Benefit:  Enables counting events, tracking status transitions, and churn analysis.

Example query answered:
  "How many orders were placed but never delivered?"
  → COUNT of order keys in Factless Fact WHERE no 'Delivered' status event exists
```

---

### 2. Junk Dimension — `Status_Junk_DIM`

```
Problem:  Order status flags (is_received, is_pending, is_shipped, is_delivered,
          is_cancelled, is_returned) are low-cardinality boolean columns.

          Putting them in the fact table = column bloat.
          Putting each in its own dimension = too many tiny dimensions.

Solution: Combine all flag combinations into ONE Junk Dimension.
          Pre-compute all valid combinations and assign a surrogate key.

Combinations in our data:
  ┌─────────┬─────────────────────────────────────┐
  │ Status  │ Description                         │
  ├─────────┼─────────────────────────────────────┤
  │ 1       │ Order Received                      │
  │ 2       │ Pending Delivery                    │
  │ 3       │ In Progress                         │
  │ 4       │ Delivered                           │
  │ 5       │ Cancelled                           │
  │ 6       │ Returned                            │
  └─────────┴─────────────────────────────────────┘
```

---

### 3. Bridge Tables — Many-to-Many Relationships

```
Problem 1: A book can have MULTIPLE authors.
           Adding author_id directly to Book_DIM breaks atomicity.

Solution:  Book_Author_Bridge_DIM
           Book_DIM ──< Bridge >── Author_DIM

Problem 2: A customer can have MULTIPLE shipping addresses.
           Adding address_id to Customer_DIM = repeating rows.

Solution:  Customer_Address_Bridge_DIM
           Customer_DIM ──< Bridge >── Address_DIM
```

---

### 4. Slowly Changing Dimensions (SCD)

All dimensions use **SCD Type 1 (Overwrite)** for this project:

```
Reason: GravityBooks is a read-heavy analytical system where historical
        attribute tracking (e.g., old customer address) is not a business
        requirement in this phase.

Type 1 → Overwrite old value with new value. No history kept.
Type 2 → Would add start_date, end_date, is_current columns (implemented
          as Derived Columns in SSIS but not activated as full Type 2).
```

> 📌 SCD Type 2 columns (`start_date`, `end_date`, `is_current`) were modeled  
> in `Book_DIM` as **derived columns in SSIS** to allow future upgrade to Type 2.

---

### 5. Date Dimension — Role-Playing

```
The Date_DIM is a single pre-populated calendar table.
It plays MULTIPLE roles in the same fact table:

  Sales_Fact
    ├── order_date_key    → Date_DIM (as "Order Date")
    └── ship_date_key     → Date_DIM (as "Ship Date")  ← same table, different role

This is the Kimball "Role-Playing Dimension" pattern.
```

---

## 🔄 ETL Strategy — SSIS

### Load Order (Dependency-aware)

```
Phase 1 — Reference Dimensions (no FK dependencies):
  Date_DIM → Address_DIM → Author_DIM → Shipping_Method_DIM → Status_Junk_DIM

Phase 2 — Dependent Dimensions:
  Book_DIM → Customer_DIM

Phase 3 — Bridge Tables:
  Book_Author_Bridge_DIM → Customer_Address_Bridge_DIM

Phase 4 — Facts (all dimension keys must exist first):
  Order_History_Factless_Fact → Sales_Fact
```

### Surrogate Key Strategy

```
All dimension tables use IDENTITY surrogate keys (integer).
Natural/business keys from the OLTP are preserved as separate columns.

OLTP key   → kept as: book_id, customer_id, etc.   (for traceability)
DWH key    → new:     book_pk, customer_pk, etc.   (surrogate, stable)
```

### Lookup Pattern in SSIS

```
Every SSIS package follows:
  OLE DB Source (OLTP)
       ↓
  [Lookup: get surrogate key from DWH dimension]
       ↓
  [Derived Column: add SCD columns, calculated fields]
       ↓
  [Conditional Split: new row vs. existing row]
       ↓
  OLE DB Destination (DWH)
```

---

## 📊 SSAS Cube Design

```
Cube Name : Gravity_Books_DWH_view
DSV       : Gravity_Books_DWH_view  (Data Source View)
```

### Measure Groups

| Measure Group | Source Fact | Key Measures |
|---------------|-------------|-------------|
| Sales | `Sales_Fact` | Revenue, Quantity, Order Count |
| Order History | `Order_History_Factless_Fact` | Event Count, Status Distribution |

### Dimensions Linked to Cube

```
[Book_DIM] ────────────────┐
[Author_DIM] ──(bridge)────┤
[Customer_DIM] ────────────┤──── Sales_FACT ──── [Date_DIM]
[Address_DIM] ─────────────┤                         │
[Shipping_Method_DIM] ─────┤                    [Dim_Time]
[Status_Junk_DIM] ─────────┘
```

---

## 📋 Summary

| Design Decision | Choice Made | Reason |
|-----------------|-------------|--------|
| Methodology | Kimball | Fast delivery, business-first |
| Schema type | Star Schema | Query performance, simplicity |
| Fact type 1 | Transactional | One row per line item |
| Fact type 2 | Factless | Order event tracking |
| SCD type | Type 1 (overwrite) | No historical tracking needed yet |
| M:M handling | Bridge Tables | Books↔Authors, Customers↔Addresses |
| Low-cardinality flags | Junk Dimension | Avoid fact table bloat |
| Surrogate keys | IDENTITY integers | Stable, performance-optimized |
| ETL tool | SSIS | Native SQL Server integration |
| OLAP layer | SSAS Multidimensional | Cube for fast aggregation |

---

*📁 Part of the GravityBooks End-to-End Data Warehouse Project*  
*🛠️ Tools: SQL Server · SSIS · SSAS · Kimball Dimensional Modeling*
