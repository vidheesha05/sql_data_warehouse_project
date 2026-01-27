/* DDL Script: Create Bronze Layer Tables
This script craetes tables in the bronze layer schema, dropping existing tables if they 
already exists
*/

--Create crm customer info table
IF OBJECT_ID ('bronze.crm_cust_info','U') IS NOT NULL
	DROP TABLE bronze.crm_cust_info;

CREATE TABLE bronze.crm_cust_info (
	cst_id INT,
	cst_key NVARCHAR(50),
	cst_firstname NVARCHAR(50),
	cst_lastname NVARCHAR(50),
	cst_marital_status NVARCHAR(50),
	cst_gndr NVARCHAR(50),
	cst_create_date DATE
);

--Create crm product info table
IF OBJECT_ID('bronze.crm_prd_info','U') IS NOT NULL
	DROP TABLE bronze.crm_prd_info;
CREATE TABLE bronze.crm_prd_info(
	prd_id INT,
	prd_key NVARCHAR(50),
	prd_nm NVARCHAR(50),
	prd_cost INT,
	prd_line NVARCHAR(50),
	prd_start_date DATETIME,
	prd_end_date DATETIME
);

--Create crm sales details
IF OBJECT_ID('bronze.crm_sales_details','U') IS NOT NULL
	DROP TABLE bronze.crm_sales_details;
CREATE TABLE bronze.crm_sales_details(
	sls_ord_num NVARCHAR(50),
	sls_prd_key NVARCHAR(50),
	sls_cust_id INT,
	sls_order_dt INT,
	sls_ship_dt INT,
	sls_due_dt INT,
	sls_sales INT,
	sls_quantity INT,
	sls_price INT
);

--Create erp customer table
IF OBJECT_ID('bronze.erp_cust_az12','U') IS NOT NULL
	DROP TABLE bronze.erp_cust_az12;
CREATE TABLE bronze.erp_cust_az12(
	cid NVARCHAR(50),
	bdate DATE,
	gen NVARCHAR(50)
)

--Create table erp location table
IF OBJECT_ID('bronze.erp_loc_a101','U') IS NOT NULL
	DROP TABLE bronze.erp_loc_a101;
CREATE TABLE bronze.erp_loc_a101(
	cid NVARCHAR(50),
	cntry NVARCHAR(50)
)

--Create table erp px_cat 
IF OBJECT_ID('bronze.erp_px_cat_g1v2','U') IS NOT NULL
	DROP TABLE bronze.erp_px_cat_g1v2;
CREATE TABLE bronze.erp_px_cat_g1v2(
	id NVARCHAR(50),
	cat NVARCHAR(50),
	subcat NVARCHAR(50),
	maintenance NVARCHAR(50) 
)

--Created Stored Procedure to run frequently used code
--EXEC bronze.load_bronze;


CREATE PROCEDURE bronze.load_bronze AS
BEGIN
	DECLARE @start_time DATETIME, @end_time DATETIME;
	BEGIN TRY
	--Loading data into bronze layer of the datawarehouse using BULK INSERT
		PRINT'=========================================';
		PRINT'LOADING BRONZE LAYER';
		PRINT'=========================================';
	
		PRINT'-----------------------------------------';
		PRINT'Loading CRM Tables';
		PRINT'-----------------------------------------';

		SET @start_time = GETDATE();
		PRINT'>>Truncating Table: bronze.crm_cust_info';
		TRUNCATE table bronze.crm_cust_info;
	
		PRINT'>>Inserting Data Into: bronze.crm_cust_info';
		BULK INSERT bronze.crm_cust_info
		FROM 'C:\vidheesha\sql-data-warehouse-project\datasets\source_crm\cust_info.csv'
		WITH (
	
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT'>> Load Duration: '+ cast(DATEDIFF(second, @start_time, @end_time) as NVARCHAR) + ' seconds';
		PRINT'----------------------'

		SET	@start_time = GETDATE();
		PRINT'>>Truncating Table: bronze.crm_prd_info';
		TRUNCATE table bronze.crm_prd_info;

		PRINT'>>Inserting Data Into: bronze.crm_prd_info';
		BULK INSERT bronze.crm_prd_info
		FROM 'C:\vidheesha\sql-data-warehouse-project\datasets\source_crm\prd_info.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT'>> Load Duration: '+cast(DATEDIFF(second,@start_time,@end_time) as NVARCHAR) + 'seconds';
		PRINT'-----------------------'

		SET @start_time = GETDATE();
		PRINT'>>Truncating Table: bronze.crm_sales_details';
		TRUNCATE table bronze.crm_sales_details;

		PRINT'>>Inserting Data Into: bronze.crm_sales_details';
		BULK INSERT bronze.crm_sales_details
		FROM 'C:\vidheesha\sql-data-warehouse-project\datasets\source_crm\sales_details.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT'>>Load Duration: '+cast(DATEDIFF(second,@start_time,@end_time) as NVARCHAR) + ' seconds';
		PRINT'-----------------------'

		PRINT'----------------------------------------';
		PRINT'Loading ERP Tables';
		PRINT'----------------------------------------';

		SET @start_time = GETDATE();
		PRINT'>>Truncating Table: bronze.erp_cust_az12';
		TRUNCATE table bronze.erp_cust_az12;

		PRINT'>>Inserting Data Into: bronze.erp_cust_az12';
		BULK INSERT bronze.erp_cust_az12
		FROM 'C:\vidheesha\sql-data-warehouse-project\datasets\source_erp\cust_az12.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT'>>Load Duration: ' + cast(DATEDIFF(second,@start_time,@end_time) as NVARCHAR) + ' seconds';
		PRINT'------------------------'

		SET @start_time = GETDATE();
		PRINT'>>Truncating Table: bronze.erp_loc_a101';
		TRUNCATE table bronze.erp_loc_a101;

		PRINT'>>Inserting Data Into: bronze.erp_loc_a101';
		BULK INSERT bronze.erp_loc_a101
		FROM 'C:\vidheesha\sql-data-warehouse-project\datasets\source_erp\loc_a101.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT'>>Load Duration: '+ cast(DATEDIFF(second,@start_time,@end_time) as NVARCHAR) + ' seconds';
		PRINT'-----------------------'

		SET @start_time = GETDATE();
		PRINT'>>Truncating Table: bronze.erp_px_cat_g1v2';
		TRUNCATE table bronze.erp_px_cat_g1v2;

		PRINT'>>Inserting Data Into: bronze.erp_px_cat_g1v2';
		BULK INSERT bronze.erp_px_cat_g1v2
		FROM 'C:\vidheesha\sql-data-warehouse-project\datasets\source_erp\px_cat_g1v2.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT'>>Load Duration: ' + cast(DATEDIFF(second,@start_time,@end_time) as NVARCHAR) +  ' seconds';

		END TRY
		BEGIN CATCH
			PRINT'=============================================';
			PRINT'ERROR OCCURED DURING LOADING BRONZE LAYER';
			PRINT'Error Message'+ ERROR_MESSAGE();
			PRINT'=============================================';
		END CATCH
END

EXEC bronze.load_bronze;


