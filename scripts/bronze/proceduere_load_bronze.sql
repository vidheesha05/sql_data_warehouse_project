/*
Stored Procedure: Loading into Bronze Layer

Script Purpose: 
This stored procedure code loads data into the bronze layer schema from csv files as 
- Truncates the tables before loading data into them.
- Uses Bulk Insert command to load data from csv files to bronze layer tables
*/


--Created Stored Procedure to run frequently used code

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
