select * from [Sales Retail];
select * from DimCustomer

--To create a DimCustomer table from Sales Retail table
select * into DimCustomer
from
	(select Customer_ID, Segment, Customer_Name from [Sales Retail])
as DimC

with CTE_DimC
as
	(select Customer_ID, segment, Customer_Name, ROW_NUMBER() over (partition by Customer_ID, Customer_Name order by Customer_ID asc) as rownum
	from DimCustomer
	)
delete from CTE_DimC
where rownum > 1 --To remove duplicate from DimCustomer table

--To create a DimLocation table from Sales Retail table
select * into DimLocation
from
	(select Postal_code, Country, City, State, Region
	from [Sales Retail]
	)
as DimL

Select * from DimLocation

with CTE_Diml
as
	(select Postal_code, Country,City, State, Region, ROW_NUMBER() over (partition by Postal_code, Country,City, State, Region order by Postal_code asc) as rownum
	from DimLocation
	)
delete from CTE_DimL
where rownum > 1


--To create the table for product from sales retail table
select * into DimProduct
from
	(select product_id, category, sub_category, product_name
	from [Sales Retail]
	)
as DimP


with CTE_DimP
as 
	(select product_id, category, sub_category, product_name, ROW_NUMBER() over (partition by product_id, category, sub_category, product_name order by product_id) as rownum
	from DimProduct
	)
delete from CTE_DimP
where rownum > 1


--To create our saleFacttable
select * into orderFacttable
from
	(select order_id, order_date, ship_date, ship_mode, customer_id, Segment, postal_code, retail_sales_people, product_ID, returned, sales, quantity, discount, profit
	from [Sales Retail]
	)
as orderfact

select * from orderFacttable

with CTE_orderfact
as
	(select * ,
	ROW_NUMBER() over (partition by 
	order_id, 
	order_date, 
	ship_date, 
	ship_mode, 
	customer_id, 
	Segment, 
	postal_code, 
	retail_sales_people, 
	product_ID, 
	returned, 
	sales, 
	quantity, 
	discount, 
	profit order by order_id asc
	) as rownum
	from orderFacttable
	)
delete from CTE_orderfact
where rownum > 1

SELECT * FROM DimProduct;
where product_id = 'FUR-FU-10004091'


--To add a surrogate key called productkey to serve as the unique identifier for the table Dimproduct
alter table DimProduct 
add productkey int identity(1,1) primary key;

--To add the ProductKey to the orderFacttable
alter table orderFacttable
add ProductKey int;

update orderFacttable
set ProductKey = DimProduct.ProductKey
from orderFacttable
join DimProduct
ON orderFacttable.product_ID = DimProduct.product_id

alter table orderFacttable
drop column product_id

alter table DimProduct
drop column product_id


--To add a unique identifier to the orderFacttable
alter table orderFacttable
add row_id int identity (1,1);

SELECT * FROM orderFacttable
where order_id = 'CA-2014-102652'

select * from orderFacttable

alter table orderFacttable
drop column row_id

--Exploratory Analysis
--What was the Average delivery days for diffrent product subcategory?
select * from orderFacttable
select * from DimProduct

select sub_category, avg(DATEDIFF(day, order_date,ship_date)) as avgdeliverydays
from orderFacttable
left join DimProduct
on orderFacttable.ProductKey = DimProduct.productkey
group by DimProduct.sub_category
/* It takes an average of 32 days to delivery proucts in the chairs and bookcases sub_category,
an average of 34 days to deliver products in the furnishings sub_category and an average of 36 days
to deliver products in the tables subCategory*/


-- What was thee Average delivery days for each segment
select * from orderFacttable
select segment, avg(datediff(day,order_date,ship_date)) as avgdeliverydays
from orderFacttable
group by Segment
order by 2 desc
/* It takes an average of 35 delivery daysto ge products to the corporate customer segment,
an average of 34 delivery days to get products to the customer segment and an average of 
31 delivery days to get products across to the home office customer segment.*/


--What are the Top 5 Fastest delivered products and Top 5 slowest delivered products?
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

--Which product Subcategory generate most profit?
select dp.sub_category, round(sum(oft.profit),2) as TotalProfit
from orderFacttable as oft
left join DimProduct as dp
on oft.ProductKey = dp.productkey
where oft.profit > 0
group by dp.sub_category
order by 2 desc;
/* The subcategory chairs generates the highest profit with a total of $36,471.1
while the least come from table*/

--Which segment generates the most profit?
select segment, round(sum(profit),2) as TotalProfit
from orderFacttable
where profit >0 
group by Segment
order by 2 desc;
/* T consumer customer segment generates the highest profit
while the home office generates the least*/

--Which Top 5 customers made the most profit?
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


--What is the total number of product by subcategogry
select sub_category, COUNT(product_name) as TotalProduct 
from DimProduct
group by sub_category;
/* The total product for each subcategory are 48,87,186,34 for Bookcases,chairs, Furnishings and tables respectively.































