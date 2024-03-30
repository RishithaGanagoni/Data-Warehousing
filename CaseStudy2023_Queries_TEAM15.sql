-- Queries

use SP23_ksralawiy
go

DROP VIEW IF EXISTS DATAWAREHOUSE
GO

DROP VIEW IF EXISTS QUERY1A
GO

DROP VIEW IF EXISTS QUERY1B
GO

DROP VIEW IF EXISTS QUERY1C
GO

DROP VIEW IF EXISTS QUERY1D
GO

DROP VIEW IF EXISTS QUERY2A
GO

DROP VIEW IF EXISTS QUERY2B
GO

DROP VIEW IF EXISTS QUERY2C
GO

DROP VIEW IF EXISTS QUERY2D
GO

DROP VIEW IF EXISTS QUERY3A
GO

DROP VIEW IF EXISTS QUERY3B
GO

DROP VIEW IF EXISTS QUERY3C
GO

DROP VIEW IF EXISTS QUERY3D
GO

DROP VIEW IF EXISTS QUERY4
GO

DROP VIEW IF EXISTS QUERY5
GO

-- creating a view for the designed datawarehouse

CREATE VIEW DATAWAREHOUSE AS
SELECT FACT_SALES.Sales_ID,FACT_SALES.Location_ID,FACT_SALES.Menu_ID,FACT_SALES.Store_ID,
FACT_SALES.Product_ID,FACT_SALES.date_key,FACT_SALES.File1ID,FACT_SALES.ReceiptNbr,
FACT_SALES.TransTime,FACT_SALES.ProductGrossAmt,FACT_SALES.Quantity,FACT_SALES.ProductTaxAmt,
FACT_SALES.ProductNetAmt FROM FACT_SALES 
JOIN DIM_DATE ON FACT_SALES.date_key = DIM_DATE.date_key
JOIN DIM_LOCATION ON FACT_SALES.Location_ID = DIM_LOCATION.Location_ID
JOIN DIM_MENU ON FACT_SALES.Menu_ID = DIM_MENU.Menu_ID
JOIN DIM_PRODUCT ON FACT_SALES.Product_ID = DIM_PRODUCT.Product_ID
JOIN DIM_STORE ON FACT_SALES.Store_ID = DIM_STORE.Store_ID
GO


--Queries 
---------------------------------------------------------------------------------------------------
--1.	What are the top 3 locations with respect to profit annually, monthly, weekly and daily?
---------------------------------------------------------------------------------------------------

-- 1a)Profit Annually
CREATE VIEW QUERY1A AS
select top 3 StoreAddress,StoreNbr,storecity,sum(ProductNetAmt) as Profit from 
FACT_SALES join DIM_PRODUCT on FACT_SALES.Product_ID = DIM_PRODUCT.Product_ID
		   join DIM_DATE on FACT_SALES.date_key = DIM_DATE.date_key
		   join DIM_LOCATION on FACT_SALES.Location_ID = DIM_LOCATION.Location_ID
		   join DIM_store on FACT_SALES.Store_ID = DIM_STORE.Store_ID
where year_nbr = 2022
group by StoreAddress,StoreNbr,StoreCity
order by profit desc
GO

-- 1b)Profit Monthly
CREATE VIEW QUERY1B AS
select top 3 StoreAddress,storenbr,storecity,sum(ProductNetAmt) as Profit from 
FACT_SALES join DIM_PRODUCT on FACT_SALES.Product_ID = DIM_PRODUCT.Product_ID
		   join DIM_DATE on FACT_SALES.date_key = DIM_DATE.date_key
		   join DIM_LOCATION on FACT_SALES.Location_ID = DIM_LOCATION.Location_ID
		   join DIM_store on FACT_SALES.Store_ID = DIM_STORE.Store_ID
where year_nbr = 2022 and month_nbr =4
group by StoreAddress,StoreNbr,StoreCity
order by profit desc
GO

-- 1c)Profit Week
CREATE VIEW QUERY1C AS
select top 3 StoreAddress,storenbr,storecity,sum(ProductNetAmt) as Profit from 
FACT_SALES join DIM_PRODUCT on FACT_SALES.Product_ID = DIM_PRODUCT.Product_ID
		   join DIM_DATE on FACT_SALES.date_key = DIM_DATE.date_key
		   join DIM_LOCATION on FACT_SALES.Location_ID = DIM_LOCATION.Location_ID
		   join DIM_store on FACT_SALES.Store_ID = DIM_STORE.Store_ID
where CEILING(DAY(fulldate)/7.0) = 1 and  month_nbr = 1 and year_nbr = 2022
group by StoreAddress,storenbr,storecity
order by profit desc
GO



-- 1d)Profit Daily
CREATE VIEW QUERY1D AS
select top 3 StoreAddress,storenbr,storecity,sum(ProductNetAmt) as Profit from 
FACT_SALES join DIM_PRODUCT on FACT_SALES.Product_ID = DIM_PRODUCT.Product_ID
		   join DIM_DATE on FACT_SALES.date_key = DIM_DATE.date_key
		   join DIM_LOCATION on FACT_SALES.Location_ID = DIM_LOCATION.Location_ID
		   join DIM_store on FACT_SALES.Store_ID = DIM_STORE.Store_ID
where fulldate = '2022-03-31'
group by StoreAddress,storenbr,StoreCity
order by profit desc
GO
--------------------------------------------------------------------------------------------------
--2.	How many customers does each location serve annually, monthly, weekly and daily?
---------------------------------------------------------------------------------------------------

-- 2a)customers Annually
CREATE VIEW QUERY2A AS 
select StoreAddress,storenbr,storecity,count(distinct ReceiptNbr) as 'Total Customers' from 
FACT_SALES join DIM_DATE on FACT_SALES.date_key = DIM_DATE.date_key
		   join DIM_LOCATION on FACT_SALES.Location_ID = DIM_LOCATION.Location_ID
		   join DIM_store on FACT_SALES.Store_ID = DIM_STORE.Store_ID
where year_nbr = 2022
group by StoreAddress,storenbr,storecity
GO


-- 2b)customers Monthly
CREATE VIEW QUERY2B AS
select StoreAddress,storenbr,storecity,count(distinct ReceiptNbr) as 'Total Customers'from 
FACT_SALES join DIM_DATE on FACT_SALES.date_key = DIM_DATE.date_key
		   join DIM_LOCATION on FACT_SALES.Location_ID = DIM_LOCATION.Location_ID
		   join DIM_store on FACT_SALES.Store_ID = DIM_STORE.Store_ID
where year_nbr = 2022 and month_nbr =1
group by StoreAddress,storenbr,storecity
GO

-- 2c) customers Weekly
CREATE VIEW QUERY2C AS
select StoreAddress,storenbr,storecity,count(distinct ReceiptNbr) as 'Total Customers' from 
FACT_SALES join DIM_DATE on FACT_SALES.date_key = DIM_DATE.date_key
		   join DIM_LOCATION on FACT_SALES.Location_ID = DIM_LOCATION.Location_ID
		   join DIM_store on FACT_SALES.Store_ID = DIM_STORE.Store_ID
where CEILING(DAY(fulldate)/7.0) = 1 and  month_nbr = 1 and year_nbr = 2022
group by StoreAddress,storenbr,storecity
GO


-- 2d)customers daily
CREATE VIEW QUERY2D AS
select StoreAddress,storenbr,storecity,count(distinct ReceiptNbr) as 'Total Customers' from 
FACT_SALES join DIM_DATE on FACT_SALES.date_key = DIM_DATE.date_key
		   join DIM_LOCATION on FACT_SALES.Location_ID = DIM_LOCATION.Location_ID
		   join DIM_store on FACT_SALES.Store_ID = DIM_STORE.Store_ID
where fulldate = '2022-01-07'
group by StoreAddress,storenbr,storecity
GO
--------------------------------------------------------------------------------------------------
--3.	What are the top 10 most popular products sold by location annually, monthly, weekly and daily?
---------------------------------------------------------------------------------------------------

-- 3a)top 10 most popular products sold  Annually
CREATE VIEW QUERY3A AS
select top 10 (MenuName) as 'Popular Products' ,StoreAddress,StoreCity from 
FACT_SALES join DIM_DATE on FACT_SALES.date_key = DIM_DATE.date_key
		   join DIM_LOCATION on FACT_SALES.Location_ID = DIM_LOCATION.Location_ID
		   join DIM_PRODUCT on FACT_SALES.Product_ID = DIM_PRODUCT.Product_ID
		   join DIM_store on FACT_SALES.Store_ID = DIM_STORE.Store_ID
where year_nbr = 2022 and storenbr = 17382
group by MenuName,StoreAddress,StoreCity
order by sum(Quantity) desc
GO

-- 3b)top 10 most popular products sold  Monthly
CREATE VIEW QUERY3B AS
select top 10 (MenuName) as 'Popular Products',StoreAddress,StoreCity from 
FACT_SALES join DIM_DATE on FACT_SALES.date_key = DIM_DATE.date_key
		   join DIM_LOCATION on FACT_SALES.Location_ID = DIM_LOCATION.Location_ID
		   join DIM_PRODUCT on FACT_SALES.Product_ID = DIM_PRODUCT.Product_ID
		   join DIM_store on FACT_SALES.Store_ID = DIM_STORE.Store_ID
where year_nbr = 2022 and storenbr = 17382 and month_nbr = 1
group by MenuName,StoreAddress,StoreCity
order by sum(Quantity) desc
GO

-- 3c)top 10 most popular products sold  weekly
CREATE VIEW QUERY3C AS
select top 10 (MenuName) as 'Popular Products',StoreAddress,StoreCity  from 
FACT_SALES join DIM_DATE on FACT_SALES.date_key = DIM_DATE.date_key
		   join DIM_LOCATION on FACT_SALES.Location_ID = DIM_LOCATION.Location_ID
		   join DIM_PRODUCT on FACT_SALES.Product_ID = DIM_PRODUCT.Product_ID
		   join DIM_store on FACT_SALES.Store_ID = DIM_STORE.Store_ID
where CEILING(DAY(fulldate)/7.0) = 3 and year_nbr = 2022 and storenbr = 17382 and month_nbr = 1 and year_nbr = 2022
group by MenuName,StoreAddress,StoreCity
order by sum(Quantity) desc
GO

-- 3d)top 10 most popular products sold  daily
CREATE VIEW QUERY3D AS
select top 10 (MenuName) as 'Popular Products',StoreAddress,StoreCity  from 
FACT_SALES join DIM_DATE on FACT_SALES.date_key = DIM_DATE.date_key
		   join DIM_LOCATION on FACT_SALES.Location_ID = DIM_LOCATION.Location_ID
		   join DIM_PRODUCT on FACT_SALES.Product_ID = DIM_PRODUCT.Product_ID
		   join DIM_store on FACT_SALES.Store_ID = DIM_STORE.Store_ID
where storenbr = 17382 and fulldate = '2022-1-07'
group by MenuName,StoreAddress,StoreCity
order by sum(Quantity) desc
GO

--------------------------------------------------------------------------------------------------
--4.	Which products have no sales or few sales?
--------------------------------------------------------------------------------------------------

CREATE VIEW QUERY4  AS
select top 10 MenuName as Product ,SUM(Quantity) as 'Total Sales' from FACT_SALES
join DIM_PRODUCT on FACT_SALES.Product_ID =DIM_PRODUCT.Product_ID
group by DIM_PRODUCT.menuname
order by SUM(Quantity)
GO
--------------------------------------------------------------------------------------------------
--5.	How is the number of drive-thru lanes impacting sales?
--------------------------------------------------------------------------------------------------

CREATE VIEW QUERY5 AS
select SUM(Quantity) as 'Total Sales',NbrDriveThruLanes  from FACT_SALES
join DIM_STORE on FACT_SALES.Store_ID = DIM_STORE.Store_ID
group by  NbrDriveThruLanes
GO
--------------------------------------------------------------------------------------------------
-- RUN THESE SELECT STATEMENTS TO SEE THE OUTPUT

SELECT * FROM DATAWAREHOUSE
go
SELECT * FROM QUERY1A
go
SELECT * FROM QUERY1B
go
SELECT * FROM QUERY1C
go
SELECT * FROM QUERY1D
go
SELECT * FROM QUERY2A
go
SELECT * FROM QUERY2B
go
SELECT * FROM QUERY2C
go
SELECT * FROM QUERY2D
go
SELECT * FROM QUERY3A
go
SELECT * FROM QUERY3B
go
SELECT * FROM QUERY3C
go
SELECT * FROM QUERY3D
go
SELECT * FROM QUERY4
go
SELECT * FROM QUERY5
go






