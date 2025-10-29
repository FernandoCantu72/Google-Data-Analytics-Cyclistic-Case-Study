/* ================================================
   Bulk load 12 Divvy CSVs into dbo.tripdata
   - Adjust: @Folder, @ErrorDir, file name pattern, and table schema if needed
   - Requires the CSVs to be extracted locally on the SQL Server machine
   ================================================ */

USE [Cycling];  
GO

/* 0) Target table: create if missing (matches your uploaded file’s columns) */
IF OBJECT_ID(N'dbo.tripdata', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.tripdata
    (
        ride_id             varchar(16)  NOT NULL,
        rideable_type       varchar(13)  NOT NULL,
        started_at          varchar(7)   NOT NULL,  -- e.g., 26:04.1 (kept as text)
        ended_at            varchar(7)   NOT NULL,  -- e.g., 39:04.5
        ride_length         varchar(8)   NOT NULL,  -- e.g., 0:06:52
        day_of_week         tinyint      NOT NULL,  -- 1=Sun ... 7=Sat

        start_station_name  nvarchar(64)     NULL,
        start_station_id    varchar(35)      NULL,
        end_station_name    nvarchar(64)     NULL,
        end_station_id      varchar(35)      NULL,

        start_lat           decimal(9,6) NOT NULL,
        start_lng           decimal(9,6) NOT NULL,
        end_lat             decimal(9,6)     NULL,
        end_lng             decimal(9,6)     NULL,

        member_casual       varchar(6)   NOT NULL
    );

    -- Optional: index for faster lookups
    CREATE UNIQUE INDEX IX_tripdata_ride_id ON dbo.tripdata(ride_id);
END
GO

/* 1) Configure paths
   NOTE: These paths must be readable by the SQL Server **service account**.
   Create the error folder in Windows first to avoid "path not found".
*/
DECLARE @Folder   nvarchar(4000) = N'C:\Data\Divvy\';              -- <-- change to where CSVs live
DECLARE @ErrorDir nvarchar(4000) = N'C:\Data\Divvy\bulk_errors\';  -- <-- make sure this folder exists

/* 2) List the months to load (12 files) */
DECLARE @Files TABLE (base_name varchar(32) PRIMARY KEY);
INSERT INTO @Files(base_name) VALUES
('202410-divvy-tripdata'),
('202411-divvy-tripdata'),
('202412-divvy-tripdata'),
('202501-divvy-tripdata'),
('202502-divvy-tripdata'),
('202503-divvy-tripdata'),
('202504-divvy-tripdata'),
('202505-divvy-tripdata'),
('202506-divvy-tripdata'),
('202507-divvy-tripdata'),
('202508-divvy-tripdata'),
('202509-divvy-tripdata');

/* 3) We’ll try two common filename patterns:
      - *_Clean_csv.csv  (you used this earlier)
      - *.csv            (plain export)
   The script will attempt the first; if missing, it tries the second.
*/
DECLARE @pattern1 nvarchar(128) = N'_Clean_csv.csv';
DECLARE @pattern2 nvarchar(128) = N'.csv';

/* 4) Logging */
DECLARE @Log TABLE
(
    load_ts      datetime2      NOT NULL DEFAULT sysdatetime(),
    file_loaded  nvarchar(4000) NULL,
    rows_loaded  int            NULL,
    status       nvarchar(50)   NOT NULL,
    message      nvarchar(4000) NULL
);

/* 5) Loop through files and BULK INSERT */
DECLARE
    @base_name varchar(32),
    @full1 nvarchar(4000),
    @full2 nvarchar(4000),
    @chosen nvarchar(4000),
    @sql nvarchar(max);

DECLARE file_cur CURSOR FAST_FORWARD FOR
    SELECT base_name FROM @Files ORDER BY base_name;

OPEN file_cur;
FETCH NEXT FROM file_cur INTO @base_name;

WHILE @@FETCH_STATUS = 0
BEGIN
    SET @full1  = @Folder + @base_name + @pattern1; -- e.g., 202410-divvy-tripdata_Clean_csv.csv
    SET @full2  = @Folder + @base_name + @pattern2; -- e.g., 202410-divvy-tripdata.csv
    SET @chosen = NULL;

    -- Check if file exists via xp_fileexist (returns a result set; capture to table var)
    DECLARE @exists TABLE (exist int, isdir int, isarch int);
    DELETE FROM @exists;
    INSERT INTO @exists EXEC master.dbo.xp_fileexist @full1;

    IF EXISTS (SELECT 1 FROM @exists WHERE exist = 1)
        SET @chosen = @full1;
    ELSE
    BEGIN
        DELETE FROM @exists;
        INSERT INTO @exists EXEC master.dbo.xp_fileexist @full2;
        IF EXISTS (SELECT 1 FROM @exists WHERE exist = 1)
            SET @chosen = @full2;
    END

    IF @chosen IS NULL
    BEGIN
        INSERT INTO @Log(status, file_loaded, message)
        VALUES (N'FILE_NOT_FOUND', @Folder + @base_name + N'(_Clean_csv.csv|.csv)', N'No matching CSV found');
        FETCH NEXT FROM file_cur INTO @base_name;
        CONTINUE;
    END

    BEGIN TRY
        -- Use a unique error file per source
        DECLARE @errfile nvarchar(4000) = @ErrorDir + @base_name;

        -- Load it
        SET @sql = N'
BULK INSERT dbo.tripdata
FROM ' + QUOTENAME(@chosen,'''') + N'
WITH (
    FIRSTROW = 2,
    DATAFILETYPE = ''char'',
    FIELDTERMINATOR = '','',
    ROWTERMINATOR   = ''0x0a'',
    CODEPAGE = ''65001'',
    TABLOCK,
    ERRORFILE = ' + QUOTENAME(@errfile,'''') + N'
);';

        EXEC sys.sp_executesql @sql;

        -- Rowcount is session-scoped; capture it right away
        DECLARE @rc int = @@ROWCOUNT;

        INSERT INTO @Log(status, file_loaded, rows_loaded, message)
        VALUES (N'OK', @chosen, @rc, N'Loaded successfully');
    END TRY
    BEGIN CATCH
        INSERT INTO @Log(status, file_loaded, message)
        VALUES (N'ERROR', @chosen,
                CONCAT(N'Error ', ERROR_NUMBER(), N': ', ERROR_MESSAGE()));
    END CATCH

    FETCH NEXT FROM file_cur INTO @base_name;
END

CLOSE file_cur;
DEALLOCATE file_cur;

/* 6) Results */
SELECT * FROM @Log ORDER BY load_ts;
GO