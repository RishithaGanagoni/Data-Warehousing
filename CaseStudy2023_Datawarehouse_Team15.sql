-- Datawarehouse

Use SP23_ksralawiy
go


DROP TABLE IF EXISTS FACT_SALES
GO

DROP PROCEDURE if exists DATE_PROCEDURE
GO

DROP TABLE IF EXISTS DIM_LOCATION
GO

DROP TABLE IF EXISTS DIM_MENU
GO

DROP TABLE IF EXISTS DIM_PRODUCT
GO

DROP TABLE IF EXISTS DIM_STORE
GO

DROP TABLE IF EXISTS DIM_DATE
GO



--Creating the dimension tables and fact tables

CREATE TABLE "DIM_LOCATION" (
Location_ID int Identity(1,1) not null Primary Key,
    "StoreAddress" nvarchar(255) not null,
    "StoreCity" nvarchar(255) not null,
    "StoreState" nvarchar(255) not null,
    "StoreDistrict" nvarchar(255) not null,
	"StoreTerritory" nvarchar(255) not null,
	"StoreZipCode" varchar(20) not null,
   
)
GO

CREATE TABLE "DIM_MENU" (
  Menu_ID int Identity(1,1) not null Primary Key,
   "MenuName" nvarchar(255) not null,
   "MenuCategory" nvarchar(255) not null,
   "MenuSubCategory" nvarchar(255) not null,
   "MenuType" nvarchar(255) not null,
)
GO

CREATE TABLE "DIM_STORE" (
 Store_ID int Identity(1,1) not null Primary Key,
   "StoreNbr" int not null,
   "NbrDriveThruLanes" int not null,
   "NbrParkingSpaces" int not null,
   "StoreCapacity" int not null,
   "BuildingType" nvarchar(50) not null,
   "StoreStatus" nvarchar(255) not null,
 
)
GO

CREATE TABLE "DIM_PRODUCT" (
 Product_ID int Identity(1,1) not null Primary Key,
   "ProductNbr" int not null,
   "ProductDesc" nvarchar(255) not null,
    "MenuName" nvarchar(255) not null,
)
GO

CREATE TABLE "DIM_DATE" (
   date_key int PRIMARY KEY,
   fulldate datetime,
   year_nbr int,
   month_nbr int,
   day_nbr int,
   qtr int,
   day_of_week int,
   day_of_year int,
   day_name char(15),
   month_name char(15)
)
go

CREATE PROCEDURE "DATE_PROCEDURE"
as

BEGIN

	DECLARE @date date = '2021-01-01'
	DECLARE @date_key int = 1

	WHILE (@date <= '2023-12-31')
	BEGIN
	   INSERT INTO DIM_DATE(date_key, fulldate, year_nbr, month_nbr, day_nbr, qtr, day_of_week, day_of_year, day_name, month_name)
	   VALUES (@date_key, @date, YEAR(@date), MONTH(@date), DAY(@date), DATEPART(quarter, @date), DATEPART(dw, @date), DATEPART(dy, @date), DATENAME(weekday, @date), DATENAME(month, @date))

	   SET @date = DATEADD(day, 1, @date)
	   SET @date_key = @date_key + 1
	END
END
GO

EXEC DATE_PROCEDURE
GO

CREATE TABLE "FACT_SALES" (
Sales_ID int Identity(1,1) not null Primary Key,
Location_ID int not null Constraint fkfactloc foreign key references DIM_LOCATION(LOCATION_ID),
Menu_ID int not null Constraint fkfactmenu foreign key references DIM_MENU(MENU_ID),
Store_ID int not null Constraint fkfactstore foreign key references DIM_STORE(STORE_ID),
Product_ID int not null Constraint fkfactproduct foreign key references DIM_PRODUCT(PRODUCT_ID),
date_key int not null Constraint fkfactdate foreign key references DIM_DATE(date_key),
File1ID int not null,
ReceiptNbr int not null,
TransTime time(7) not null,
Quantity int not null,
"ProductGrossAmt" numeric(18,4) not null,
"ProductTaxAmt" numeric(18,4) not null,
"ProductNetAmt" numeric(18,4) not null,
"DefaultProductPrice" numeric(18,4) not null,
)
GO



