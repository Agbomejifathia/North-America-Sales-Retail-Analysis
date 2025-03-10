# North America Sales Retail Optimization Analysis


## Product Overview
North America Retail sales data analysis. As a analyts,analyse the sales data 
to determine the key insight on:
- Business performance 
- Product trends
- customer behavior: By examining data on products, customers, sales, profits, and returns, 
to identify opportunities for improvement and recommend strategies 
to enhance efficiency and profitability while ensuring an excellent customer experience.


## Data Source
The dataset used is a Retail supply chain Analysis.csv.


## Tool Used
- SQL


## Data Cleaning and Preparation
1. Data importation and inspection.
2. Spllited the table into fact and dimenstion tables, then create ERD.


## Objectives
1. What was the Average delivery days for different  
product subcategory?  
2. What was the Average delivery days for each segment ? 
3.What are the Top 5 Fastest delivered products and Top 5  
slowest delivered products?   
4. Which product Subcategory generate most profit?
5. Which segment generates the most profit?
6. Which Top 5 customers made the most profit?
7. What is the total number of products by Subcategory  


## Data Analysis
### 1. What was the Average delivery days for different  
product subcategory?
```sql
select sub_category, avg(DATEDIFF(day, order_date,ship_date)) as avgdeliverydays
from orderFacttable
left join DimProduct
on orderFacttable.ProductKey = DimProduct.productkey
group by DimProduct.sub_category
/* It takes an average of 32 days to delivery proucts in the chairs and bookcases sub_category,
an average of 34 days to deliver products in the furnishings sub_category and an average of 36 days
to deliver products in the tables subCategory*/
```

### 2. What was the Average delivery days for each segment ?
```sql
select * from orderFacttable
select segment, avg(datediff(day,order_date,ship_date)) as avgdeliverydays
from orderFacttable
group by Segment
order by 2 desc
/* It takes an average of 35 delivery daysto ge products to the corporate customer segment,
an average of 34 delivery days to get products to the customer segment and an average of 
31 delivery days to get products across to the home office customer segment.*/
```
### 3. What are the Top 5 Fastest delivered products and Top 5  
slowest delivered products?  
```sql
select top 5(dp.product_name), DATEDIFF(day, order_date,ship_date) as deliverydays
from orderFacttable as oft
left join DimProduct as dp
on oft.ProductKey = dp.productkey
order by 2 asc;

/* The top 5 fastest delivered products with 0 delivered days are
Sauder Camden County Barrister Bookcase, Planked Cherry Finish
Sauder Inglewood Library Bookcases
O'Sullivan 2-Shelf Heavy-Duty Bookcases
O'Sullivan Plantations 2-Door Library in Landvery Oak
O'Sullivan Plantations 2-Door Library in Landvery Oak
*/

select top 5(dp.product_name), DATEDIFF(day, order_date,ship_date) as deliverydays
from orderFacttable as oft
left join DimProduct as dp
on oft.ProductKey = dp.productkey
order by 2 desc;

/* The top 5 slowest delivered product with 214 deliverey days are
Bush Mission Pointe Library
Hon Multipurpose Stacking Arm Chairs
Global Ergonomic Managers Chair
Tensor Brushed Steel Torchiere Floor Lamp
Howard Miller 11-1/2" Diameter Brentwood Wall Clock
*/
```

###  4.  Which product Subcategory generate most profit?  
```sql
select dp.sub_category, round(sum(oft.profit),2) as TotalProfit
from orderFacttable as oft
left join DimProduct as dp
on oft.ProductKey = dp.productkey
where oft.profit > 0
group by dp.sub_category
order by 2 desc;
/* The subcategory chairs generates the highest profit with a total of $36,471.1
while the least come from table*/
```

### 5. Which segment generates the most profit?
```sql
select segment, round(sum(profit),2) as TotalProfit
from orderFacttable
where profit >0 
group by Segment
order by 2 desc;
/* The consumer customer segment generates the highest profit
while the home office generates the least*/
```

### 6. Which Top 5 customers made the most profit?
```sql
select top 5 (dc.Customer_Name), round(sum(profit),2) as TotalProfit
from orderFacttable as oft
left join DimCustomer as dc
on oft.customer_id = dc.customer_id
where profit >0
group by Customer_Name
order by 2 desc;
/* The top 5 customer generating the highest profit are
Laura Armstrong
Joe Elijah
Seth Vernon
Quincy Jones 
Maria Etezadi
*/
```

### 7. What is the total number of products by Subcategory
```sql
select sub_category, COUNT(product_name) as TotalProduct 
from DimProduct
group by sub_category;
/* The total product for each subcategory are 48,87,186,34 for Bookcases,chairs, Furnishings and tables respectively.
```

## Findings
1. Top Customers: The top 5 customer generating high profit are Laura Armstrong
Joe Elijah, Seth Vernon, Quincy Jones, Maria Etezadi.
2. Profitable Segment: The customer segment generates the highest profit
while the home office generates the least.
3. Subcategory highest profit: chairs generates the highest profit with a total of $36,471.1,
while the least comes from table.
4. Delivery Performance: It takes an average of 35 delivery days to get products of the corporate customer segment,
an average of 34 delivery days to get products to the customer segment and an average of 
31 delivery days to get products across to the home office customer segment.
5. Fastest Delivery: The top 5 fastest delivered products are all bookcases with 0 delivered days are
6. Slowest Delivery:  The top 5 slowest delivered product are wall clock, floor lamp and chairs with 214 deliverey days.


## Recommendation
1. Improve Product Availability: Ensure that fast-selling products, such as bookcases, are consistently available to meet demand.
2. Retains High-Value Customers – Implement loyalty programs, personalized marketing, and dedicated account management.
3. Product Development: Consider expanding the Chairs product line, which generates the most profit, and improving the design and functionality of Tables, which generate the least profit.
4. Enhance Customer Experience: Provide regular updates on delivery times and offer expedited shipping options to improve customer satisfaction.
5. Optimizes Delivery Time – Reduce delays in Tables and Furnishings by improving inventory management, logistics, and offering priority shipping.
6. Optimize Supply Chain: Streamline the supply chain to reduce delivery times, especially for Corporate customers.
7. Ensures Stock Availability – Monitor sales trends and automate restocking for high-demand
8. Data-Driven Decision Making: Continue to analyze sales data to inform business decisions and drive growth.






