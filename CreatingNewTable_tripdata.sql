-- run this to create a table

CREATE TABLE dbo.tripdata
(
    ride_id             varchar(16)  NOT NULL,
    rideable_type       varchar(16)  NULL,
    started_at          varchar(32)  NULL,  -- e.g., 26:04.1 (kept as text)
    ended_at            varchar(32)  NULL,  -- e.g., 39:04.5 (kept as text)
    ride_length         varchar(32)  NULL,  -- e.g., 0:06:52 (kept as text)
    day_of_week      varchar(16)   NULL,  -- 1 = Sunday … 7 = Saturday

    start_station_name  nvarchar(64)     NULL,
    start_station_id    varchar(64)      NULL,
    end_station_name    nvarchar(64)     NULL,
    end_station_id      varchar(64)      NULL,

    start_lat           decimal(9,6)  NULL,
    start_lng           decimal(9,6)  NULL,
    end_lat             decimal(9,6)  NULL,
    end_lng             decimal(9,6)  NULL,

    member_casual       varchar(16)   NULL,

    CONSTRAINT PK_tripdata PRIMARY KEY CLUSTERED (ride_id),
    CONSTRAINT CK_tripdata_dow CHECK (day_of_week BETWEEN 1 AND 7)
);

--
--
-- Run this to load data to the table above. it can be repeated, just change the file name.

BULK INSERT dbo.tripdata
FROM 'C:\Users\ferny\OneDrive\Documents\Google certification\Course8CaseStudy\Cyclistic\Processed\202410-divvy-tripdata_Clean.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR   = '0x0a',   -- try 0x0d0a if Windows line endings
    CODEPAGE = '65001',
    TABLOCK
);