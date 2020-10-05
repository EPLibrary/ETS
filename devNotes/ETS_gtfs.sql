/************************************************************************
*
*  The ETS1 database is an alternate database so that the production and
*  import databases can be separated to avoid a catastrophic failure.
*
*************************************************************************/

USE ETS;

IF OBJECT_ID('ETS1_trip_stop_datetimes') IS NOT NULL
	DROP VIEW ETS1_trip_stop_datetimes;
IF OBJECT_ID('ETS1_stop_times') IS NOT NULL
	DROP TABLE ETS1_stop_times;
IF OBJECT_ID('ETS1_drop_off_types') IS NOT NULL
	DROP TABLE ETS1_drop_off_types;
IF OBJECT_ID('ETS1_pickup_types') IS NOT NULL
	DROP TABLE ETS1_pickup_types;
IF OBJECT_ID('ETS1_transfers') IS NOT NULL
	DROP TABLE ETS1_transfers;
IF OBJECT_ID('ETS1_transfer_types') IS NOT NULL
	DROP TABLE ETS1_transfer_types;
IF OBJECT_ID('ETS1_location_types') IS NOT NULL
	DROP TABLE ETS1_location_types;
IF OBJECT_ID('ETS1_trips') IS NOT NULL
	DROP TABLE ETS1_trips;
IF OBJECT_ID('ETS1_stops') IS NOT NULL
	DROP TABLE ETS1_stops;
IF OBJECT_ID('ETS1_shapes') IS NOT NULL
	DROP TABLE ETS1_shapes;
IF OBJECT_ID('ETS1_routes') IS NOT NULL
	DROP TABLE ETS1_routes;
IF OBJECT_ID('ETS1_route_types') IS NOT NULL
	DROP TABLE ETS1_route_types;
IF OBJECT_ID('ETS1_stop_routes') IS NOT NULL
	DROP TABLE ETS1_stop_routes;
IF OBJECT_ID('ETS1_calendar') IS NOT NULL
	DROP TABLE ETS1_calendar;
IF OBJECT_ID('ETS1_calendar_dates') IS NOT NULL
	DROP TABLE ETS1_calendar_dates;
IF OBJECT_ID('ETS1_agency') IS NOT NULL
	DROP TABLE ETS1_agency;


CREATE TABLE ETS1_agency (
	aID INT NOT NULL IDENTITY PRIMARY KEY,
	agency_id varchar(511) NULL, -- Typically 1, 2, 3, but I learned my lesson, so varchar it is.
	agency_name nvarchar(255) NOT NULL,
	agency_url nvarchar(1024) NOT NULL,
	agency_timezone nvarchar(255) NOT NULL,
	agency_lang varchar(15) NULL,
	agency_phone varchar(16) NULL,
	agency_fare_url varchar(1024) NULL,
	agency_email varchar(1024) NULL
)

CREATE TABLE ETS1_calendar (
	cID INT NOT NULL IDENTITY PRIMARY KEY,
	service_id varchar(255) NOT NULL,
	monday BIT NOT NULL,
	tuesday BIT NOT NULL,
	wednesday BIT NOT NULL,
	thursday BIT NOT NULL,
	friday BIT NOT NULL,
	saturday BIT NOT NULL,
	sunday BIT NOT NULL,
	start_date DATE NOT NULL,
	end_date DATE NOT NULL
)

CREATE TABLE ETS1_calendar_dates (
	cdID INT NOT NULL IDENTITY PRIMARY KEY,
	service_id varchar(255) NOT NULL,
	date DATE NOT NULL,
	exception_type INT NOT NULL,
	UNIQUE(service_id,date)
)

CREATE INDEX ix_ETS1_C_service_id ON ETS1_calendar_dates(service_id)
CREATE INDEX ix_ETS1_C_date ON ETS1_calendar_dates(date)

CREATE TABLE ETS1_route_types (
	route_type INT PRIMARY KEY,
	route_type_name nvarchar(255) NOT NULL,
	route_type_desc nvarchar(1024) NULL
)

INSERT INTO ETS1_route_types VALUES
(0, 'Tram, Streetcar, Light Rail', 'Any light rail or street level system within a metropolitan area.'),
(1, 'Subway, Metro', 'Any underground rail system within a metropolitan area.'),
(2, 'Rail', 'Used for intercity or long-distance travel.'),
(3, 'Bus', 'Used for short- and long-distance bus routes.'),
(4, 'Ferry', 'Used for short- and long-distance boat service.'),
(5, 'Cable Car', 'Used for street-level cable cars where the cable runs beneath the car.'),
(6, 'Gondola, Suspended cable car.', 'Typically used for aerial cable cars where the car is suspended from the cable.'),
(7, 'Funicular', 'Any rail system designed for steep inclines.')

--DELETE FROM ETS1_routes
--DROP TABLE ETS1_routes
--2018-06-11 - updated route_id to be varchar to allow for Strathcona & St. Albert's format.
-- I'm concerned about the performance ramifications of this.
CREATE TABLE ETS1_routes (
	route_id VARCHAR(20) PRIMARY KEY,
	agency_id VARCHAR(511) NULL,
	route_short_name nvarchar(511) NOT NULL,
	route_long_name nvarchar(1023) NOT NULL,
	route_desc nvarchar(1023) NULL,
	route_type INT NOT NULL FOREIGN KEY REFERENCES ETS1_route_types(route_type),
	route_url nvarchar(1023) NULL,
	route_color varchar(20),
	route_text_color varchar(20)
	--UNIQUE(route_id)
)

CREATE TABLE ETS1_shapes (
	shape_id varchar(255),
	shape_pt_lat float(8) NOT NULL,
	shape_pt_lon float(8) NOT NULL,
	shape_pt_sequence INT NOT NULL,
	PRIMARY KEY (shape_id, shape_pt_sequence)
)

--INSERT INTO ETS1_shapes VALUES('1-89-1',53.53864,-113.42325,1)
CREATE TABLE ETS1_stops (
	stop_id VARCHAR(20) PRIMARY KEY,
	stop_code VARCHAR(20) NULL,
	stop_name nvarchar(512) NOT NULL,
	stop_desc nvarchar(1023) NULL,
	stop_lat float(8) NOT NULL,
	stop_lon float(8) NOT NULL,
	zone_id varchar(30) NULL,
	stop_url nvarchar(1023) NULL,
	location_type INT NULL, --0/blank = stop, 1 = Station, 2 = Entrance/Exit, 3 = Generic Node, 4 Boarding Area
	parent_station VARCHAR(20) NULL,
	level_id varchar(20) NULL, -- This is new, not sure what will be stored here, likely INT but I'm not making that mistake again.
	is_lrt bit NULL, --optional field added after import by my own code for simplicity
	exclusive bit NULL --can specify that this stop is not used by other agencies
)


CREATE TABLE ETS1_trips (
	route_id VARCHAR(20) FOREIGN KEY REFERENCES ETS1_routes(route_id),
	service_id varchar(255), --FOREIGN KEY REFERENCES ETS1_calendar_dates(service_id),
	trip_id VARCHAR(255) PRIMARY KEY,
	trip_headsign nvarchar(255) NULL,
	direction_id bit NULL, --0 = outbound, 1 = inbound
	block_id  varchar(30) NULL, /* Identifies the block to which the trip belongs. A block consists of two or more sequential trips made using the same vehicle, where a passenger can transfer from one trip to the next just by staying in the vehicle. The block_id must be referenced by two or more trips in trips.txt. */
	shape_id varchar(255) NULL, --REFERENCES ETS1_shapes(shape_id)
	wheelchair_accessible BIT,
	bikes_allowed BIT
)


CREATE INDEX ix_ETS1_trip_id ON ETS1_trips(trip_id)
CREATE INDEX ix_ETS1_T_service_id ON ETS1_trips(service_id)

CREATE TABLE ETS1_transfer_types (
	transfer_type INT PRIMARY KEY,
	transfer_type_name nvarchar(255) NOT NULL,
	transfer_type_desc nvarchar(1024) NULL
)
INSERT INTO ETS1_transfer_types VALUES
(0, 'Recommended', 'This is a recommended transfer point between two routes.'),
(1, 'Timed', ' This is a timed transfer point between two routes. The departing vehicle is expected to wait for the arriving one, with  to ,transfer between routes.'),
(2, 'Requires Min. Time', 'This transfer requires a minimum amount of time between arrival and departure to ensure a connection. The time  by ,min_transfer_time.'),
(3, 'Not Possible', 'Transfers are not possible between routes at this location.')

CREATE TABLE ETS1_location_types (
	location_type INT PRIMARY KEY,
	location_type_name nvarchar(255) NOT NULL,
	location_type_desc nvarchar(1024) NULL
)
INSERT INTO ETS1_location_types VALUES
(0, 'Stop/Platform', 'A location where passengers board or disembark from a transit vehicle. Is called a platform when defined within a parent_station.'),
(1, 'Station', 'A physical structure or area that contains one or more platform.'),
(2, 'Entrance/Exit', 'A location where passengers can enter or exit a station from the street. If an entrance/exit belongs to multiple stations, it can be linked by pathways to both, but the data provider must pick one of them as parent.'),
(3, 'Generic Node', 'A location within a station, not matching any other location_type, which can be used to link together pathways define in pathways.txt.'),
(4, 'Boarding Area', 'A specific location on a platform, where passengers can board and/or alight vehicles.')


CREATE TABLE ETS1_transfers (
	from_stop_id VARCHAR(255) NOT NULL REFERENCES ETS1_trips(trip_id),
	to_stop_id VARCHAR(255) NOT NULL REFERENCES ETS1_trips(trip_id),
	transfer_type INT NULL REFERENCES ETS1_transfer_types(transfer_type),
	min_transfer_time INT NULL, -- value in seconds
	PRIMARY KEY (from_stop_id, to_stop_id)
)


--WTH is trip_pattern.txt? It doesn't have a header and isn't documented in https://developers.google.com/transit/gtfs/reference/


CREATE TABLE ETS1_pickup_types (
	pickup_type INT PRIMARY KEY,
	pickup_type_name nvarchar(255) NOT NULL,
	pickup_type_desc nvarchar(1024) NULL
)
INSERT INTO ETS1_pickup_types VALUES
(0, 'Regular', 'Regularly scheduled pickup'),
(1, 'No pickup', 'No pickup available'),
(2, 'Phone', 'Must phone agency to arrange pickup'),
(3, 'Coordinate with Driver', 'Must coordinate with driver to arrange pickup')

CREATE TABLE ETS1_drop_off_types (
	drop_off_type INT PRIMARY KEY,
	drop_off_type_name nvarchar(255) NOT NULL,
	drop_off_type_desc nvarchar(1024) NULL
)
INSERT INTO ETS1_drop_off_types VALUES
(0, 'Regular', 'Regularly scheduled drop off'),
(1, 'No drop off', 'No drop off available'),
(2, 'Phone', 'Must phone agency to arrange drop off'),
(3, 'Coordinate with Driver', 'Must coordinate with driver to arrange drop off')


--INSERT INTO ETS1_stops VALUES(1001,1001,'Abbottsfield Transit Centre',NULL,53.571965,-113.390362,NULL,NULL,0,NULL)
--DROP TABLE ETS1_stop_times
CREATE TABLE ETS1_stop_times (
	--stimeID INT IDENTITY PRIMARY KEY, --I don't use this so removing it might save me from running out of keys later
	trip_id VARCHAR(255) NOT NULL REFERENCES ETS1_trips(trip_id),
	arrival_time varchar(8) NOT NULL, ---not used in practice. Can't store as time because they can go over 24:00 (even over 25:00)
	departure_hour int NOT NULL, --The hour and minute will be broken up here so they can be stored as INT for faster sorting
	departure_minute int NOT NULL,
	departure_second int NOT NULL,
	--departure_time varchar(8) NOT NULL, --Removed because this will now be split into hour/minute integers for smaller storage and faster operation
	stop_id VARCHAR(20) NOT NULL FOREIGN KEY REFERENCES ETS1_stops(stop_id),
	stop_sequence int NOT NULL, --integer
	--for proper normalization, stop_sequence really should be another DB table, but since it only seems to ever be one number, that's not so necesssary
	stop_headsign nvarchar(255) NULL,
	pickup_type INT DEFAULT 0 FOREIGN KEY REFERENCES ETS1_pickup_types(pickup_type),
	drop_off_type INT DEFAULT 0 FOREIGN KEY REFERENCES ETS1_drop_off_types(drop_off_type),
	shape_dist_traveled FLOAT(8) NULL, --theoretically could be a float, but is only ever int LOOKS LIKE I WAS WRONG ABOUT THIS!
	timepoint BIT NULL -- This should only ever be 1 or 0
)


--Table that allows quickly sorting nearby stops. This gets recreated every time the update is done.
CREATE TABLE ETS1_stop_routes (
stop_id VARCHAR(20) NOT NULL,
route_id varchar(20) NOT NULL,
agency_id varchar(511) NOT NULL, 
PRIMARY KEY (stop_id, route_id, agency_id)
)

--Create some indicies on stop_times to improve certain operations
--DROP INDEX ix_ETS1_departure_hour ON ETS1_stop_times
--DROP INDEX ix_ETS1_departure_minute ON ETS1_stop_times
--DROP INDEX ix_ETS1_stop_id ON ETS1_stop_times
--DROP INDEX ix_ETS1_stop_sequence ON ETS1_stop_times
--DROP INDEX ix_ETS1_STIME_trip_id ON ETS1_stop_times
--DROP INDEX ix_ETS1_STIME_stop_id_trip_id ON ETS1_stop_times
-- For some reason these indexes seem to be slowing things down way more than helping.
--CREATE INDEX ix_ETS1_departure_hour ON ETS1_stop_times(departure_hour)
--CREATE INDEX ix_ETS1_departure_minute ON ETS1_stop_times(departure_minute)
--CREATE INDEX ix_ETS1_stop_id ON ETS1_stop_times(stop_id)
--CREATE INDEX ix_ETS1_stop_sequence ON ETS1_stop_times(stop_sequence)
--CREATE INDEX ix_ETS1_STIME_trip_id ON ETS1_stop_times(trip_id)
-- This index helps a lot, slows down imports by several seconds
--CREATE NONCLUSTERED INDEX ix_ETS1_STIME_stop_id_trip_id ON ETS1_stop_times (stop_id) INCLUDE (trip_id)

--This index gives me a 5x improvement
CREATE NONCLUSTERED INDEX ix_ETS1_STIME_trip_id_stop_id_stop_sequence ON [dbo].[ETS1_stop_times] ([trip_id],[stop_id],[stop_sequence])
--This index also speeds up the query a fair bit more
CREATE NONCLUSTERED INDEX ix_ETS1_stop_id ON [dbo].[ETS1_stop_times] ([stop_id]) INCLUDE ([trip_id])
--The benefits of this one seem insignificant
--CREATE NONCLUSTERED INDEX ix_ETS1_stopId_pickup_type ON [dbo].[ETS_stop_times] ([stop_id],[pickup_type]) INCLUDE ([trip_id],[arrival_time],[departure_hour],[departure_minute],[stop_sequence],[stop_headsign],[drop_off_type],[shape_dist_traveled])
CREATE NONCLUSTERED INDEX ix_ETS1_trip_id_stop_id_stop_sequence ON [dbo].[ETS1_stop_times] ([trip_id],[stop_id],[stop_sequence])


GO

--DROP VIEW ETS1_trip_stop_datetimes
-- Creates a very useful view from the stop_times
CREATE VIEW ETS1_trip_stop_datetimes WITH SCHEMABINDING AS
SELECT --TOP 10000
CASE WHEN departure_hour > 23 THEN
CONVERT(datetime, DATEADD(d, 1, date), 121)+CONVERT(datetime, CAST(departure_hour%24 AS varchar)+':'+CAST(departure_minute AS varchar), 121)
ELSE
CONVERT(datetime, date, 121)+CONVERT(datetime, CAST(departure_hour AS varchar)+':'+CAST(departure_minute AS varchar), 121)
END --CASE
AS ActualDateTime,
stime.trip_id, stime.arrival_time, stime.departure_hour, stime.departure_minute,stop_id, stime.stop_sequence, stime.stop_headsign, stime.pickup_type, stime.drop_off_type,
stime.shape_dist_traveled, stime.timepoint, t.route_id, t.service_id, t.trip_headsign, t.direction_id, t.block_id, t.shape_id, r.route_short_name, r.route_long_name, c.date, c.exception_type
FROM dbo.ETS1_stop_times stime
JOIN dbo.ETS1_trips t ON stime.trip_id=t.trip_id
JOIN dbo.ETS1_routes r ON t.route_id=r.route_id
JOIN dbo.ETS1_calendar_dates c ON c.service_id=t.service_id

GO




/************************************************************************
*
*  The ETS2 database is an alternate database so that the production and
*  import databases can be separated to avoid a catastrophic failure.
*
*************************************************************************/

IF OBJECT_ID('ETS2_trip_stop_datetimes') IS NOT NULL
	DROP VIEW ETS2_trip_stop_datetimes;
IF OBJECT_ID('ETS2_stop_times') IS NOT NULL
	DROP TABLE ETS2_stop_times;
IF OBJECT_ID('ETS2_drop_off_types') IS NOT NULL
	DROP TABLE ETS2_drop_off_types;
IF OBJECT_ID('ETS2_pickup_types') IS NOT NULL
	DROP TABLE ETS2_pickup_types;
IF OBJECT_ID('ETS2_transfers') IS NOT NULL
	DROP TABLE ETS2_transfers;
IF OBJECT_ID('ETS2_transfer_types') IS NOT NULL
	DROP TABLE ETS2_transfer_types;
IF OBJECT_ID('ETS2_location_types') IS NOT NULL
	DROP TABLE ETS2_location_types;
IF OBJECT_ID('ETS2_trips') IS NOT NULL
	DROP TABLE ETS2_trips;
IF OBJECT_ID('ETS2_stops') IS NOT NULL
	DROP TABLE ETS2_stops;
IF OBJECT_ID('ETS2_shapes') IS NOT NULL
	DROP TABLE ETS2_shapes;
IF OBJECT_ID('ETS2_routes') IS NOT NULL
	DROP TABLE ETS2_routes;
IF OBJECT_ID('ETS2_route_types') IS NOT NULL
	DROP TABLE ETS2_route_types;
IF OBJECT_ID('ETS2_stop_routes') IS NOT NULL
	DROP TABLE ETS2_stop_routes;
IF OBJECT_ID('ETS2_calendar') IS NOT NULL
	DROP TABLE ETS2_calendar;
IF OBJECT_ID('ETS2_calendar_dates') IS NOT NULL
	DROP TABLE ETS2_calendar_dates;
IF OBJECT_ID('ETS2_agency') IS NOT NULL
	DROP TABLE ETS2_agency;


CREATE TABLE ETS2_agency (
	aID INT NOT NULL IDENTITY PRIMARY KEY,
	agency_id varchar(511) NULL, -- Typically 1, 2, 3, but I learned my lesson, so varchar it is.
	agency_name nvarchar(255) NOT NULL,
	agency_url nvarchar(1024) NOT NULL,
	agency_timezone nvarchar(255) NOT NULL,
	agency_lang varchar(15) NULL,
	agency_phone varchar(16) NULL,
	agency_fare_url varchar(1024) NULL,
	agency_email varchar(1024) NULL
)


CREATE TABLE ETS2_calendar (
	cID INT NOT NULL IDENTITY PRIMARY KEY,
	service_id varchar(255) NOT NULL,
	monday BIT NOT NULL,
	tuesday BIT NOT NULL,
	wednesday BIT NOT NULL,
	thursday BIT NOT NULL,
	friday BIT NOT NULL,
	saturday BIT NOT NULL,
	sunday BIT NOT NULL,
	start_date DATE NOT NULL,
	end_date DATE NOT NULL
)


CREATE TABLE ETS2_calendar_dates (
	cdID INT NOT NULL IDENTITY PRIMARY KEY,
	service_id varchar(255) NOT NULL,
	date DATE NOT NULL,
	exception_type INT NOT NULL,
	UNIQUE(service_id,date)
)



CREATE INDEX ix_ETS2_C_service_id ON ETS2_calendar_dates(service_id)
CREATE INDEX ix_ETS2_C_date ON ETS2_calendar_dates(date)


CREATE TABLE ETS2_route_types (
	route_type INT PRIMARY KEY,
	route_type_name nvarchar(255) NOT NULL,
	route_type_desc nvarchar(1024) NULL
)

INSERT INTO ETS2_route_types VALUES
(0, 'Tram, Streetcar, Light Rail', 'Any light rail or street level system within a metropolitan area.'),
(1, 'Subway, Metro', 'Any underground rail system within a metropolitan area.'),
(2, 'Rail', 'Used for intercity or long-distance travel.'),
(3, 'Bus', 'Used for short- and long-distance bus routes.'),
(4, 'Ferry', 'Used for short- and long-distance boat service.'),
(5, 'Cable Car', 'Used for street-level cable cars where the cable runs beneath the car.'),
(6, 'Gondola, Suspended cable car.', 'Typically used for aerial cable cars where the car is suspended from the cable.'),
(7, 'Funicular', 'Any rail system designed for steep inclines.')

--DELETE FROM ETS2_routes
--DROP TABLE ETS2_routes
--2018-06-11 - updated route_id to be varchar to allow for Strathcona & St. Albert's format.
-- I'm concerned about the performance ramifications of this.
CREATE TABLE ETS2_routes (
	route_id VARCHAR(20) PRIMARY KEY,
	agency_id varchar(255) NULL,
	route_short_name nvarchar(511) NOT NULL,
	route_long_name nvarchar(1023) NOT NULL,
	route_desc nvarchar(1023) NULL,
	route_type INT NOT NULL FOREIGN KEY REFERENCES ETS2_route_types(route_type),
	route_url nvarchar(1023) NULL,
	route_color varchar(20),
	route_text_color varchar(20)
	--UNIQUE(route_id)
)

--SELECT * FROM ETS2_routes
--INSERT INTO ETS2_routes VALUES(1,1,'West Edmonton Mall - Downtown - Capilano',NULL,3,NULL)

CREATE TABLE ETS2_shapes (
	shape_id varchar(255),
	shape_pt_lat float(8) NOT NULL,
	shape_pt_lon float(8) NOT NULL,
	shape_pt_sequence INT NOT NULL,
	PRIMARY KEY (shape_id, shape_pt_sequence)
)


--INSERT INTO ETS2_shapes VALUES('1-89-1',53.53864,-113.42325,1)
CREATE TABLE ETS2_stops (
	stop_id VARCHAR(20) PRIMARY KEY,
	stop_code VARCHAR(20) NULL,
	stop_name nvarchar(512) NOT NULL,
	stop_desc nvarchar(1023) NULL,
	stop_lat float(8) NOT NULL,
	stop_lon float(8) NOT NULL,
	zone_id varchar(30) NULL,
	stop_url nvarchar(1023) NULL,
	location_type INT NULL, --0/blank = stop, 1 = Station, 2 = Entrance/Exit, 3 = Generic Node, 4 Boarding Area
	parent_station VARCHAR(20) NULL,
	level_id varchar(20) NULL, -- This is new, not sure what will be stored here, likely INT but I'm not making that mistake again.
	is_lrt bit NULL, --optional field added after import by my own code for simplicity
	exclusive bit NULL --can specify that this stop is not used by other agencies
)


CREATE TABLE ETS2_trips (
	route_id VARCHAR(20) FOREIGN KEY REFERENCES ETS2_routes(route_id),
	service_id varchar(255), --FOREIGN KEY REFERENCES ETS2_calendar_dates(service_id),
	trip_id VARCHAR(255) PRIMARY KEY,
	trip_headsign nvarchar(255) NULL,
	direction_id bit NULL, --0 = outbound, 1 = inbound
	block_id  varchar(30) NULL, /* Identifies the block to which the trip belongs. A block consists of two or more sequential trips made using the same vehicle, where a passenger can transfer from one trip to the next just by staying in the vehicle. The block_id must be referenced by two or more trips in trips.txt. */
	shape_id varchar(255) NULL, --REFERENCES ETS2_shapes(shape_id)
	wheelchair_accessible BIT,
	bikes_allowed BIT
)

CREATE INDEX ix_ETS2_trip_id ON ETS2_trips(trip_id)
CREATE INDEX ix_ETS2_T_service_id ON ETS2_trips(service_id)

CREATE TABLE ETS2_transfer_types (
	transfer_type INT PRIMARY KEY,
	transfer_type_name nvarchar(255) NOT NULL,
	transfer_type_desc nvarchar(1024) NULL
)
INSERT INTO ETS2_transfer_types VALUES
(0, 'Recommended', 'This is a recommended transfer point between two routes.'),
(1, 'Timed', ' This is a timed transfer point between two routes. The departing vehicle is expected to wait for the arriving one, with  to ,transfer between routes.'),
(2, 'Requires Min. Time', 'This transfer requires a minimum amount of time between arrival and departure to ensure a connection. The time  by ,min_transfer_time.'),
(3, 'Not Possible', 'Transfers are not possible between routes at this location.')

CREATE TABLE ETS2_location_types (
	location_type INT PRIMARY KEY,
	location_type_name nvarchar(255) NOT NULL,
	location_type_desc nvarchar(1024) NULL
)
INSERT INTO ETS2_location_types VALUES
(0, 'Stop/Platform', 'A location where passengers board or disembark from a transit vehicle. Is called a platform when defined within a parent_station.'),
(1, 'Station', 'A physical structure or area that contains one or more platform.'),
(2, 'Entrance/Exit', 'A location where passengers can enter or exit a station from the street. If an entrance/exit belongs to multiple stations, it can be linked by pathways to both, but the data provider must pick one of them as parent.'),
(3, 'Generic Node', 'A location within a station, not matching any other location_type, which can be used to link together pathways define in pathways.txt.'),
(4, 'Boarding Area', 'A specific location on a platform, where passengers can board and/or alight vehicles.')


CREATE TABLE ETS2_transfers (
	from_stop_id VARCHAR(255) NOT NULL REFERENCES ETS2_trips(trip_id),
	to_stop_id VARCHAR(255) NOT NULL REFERENCES ETS2_trips(trip_id),
	transfer_type INT NULL REFERENCES ETS2_transfer_types(transfer_type),
	min_transfer_time INT NULL, -- value in seconds
	PRIMARY KEY (from_stop_id, to_stop_id)
)

--WTH is trip_pattern.txt? It doesn't have a header and isn't documented in https://developers.google.com/transit/gtfs/reference/


CREATE TABLE ETS2_pickup_types (
	pickup_type INT PRIMARY KEY,
	pickup_type_name nvarchar(255) NOT NULL,
	pickup_type_desc nvarchar(1024) NULL
)
INSERT INTO ETS2_pickup_types VALUES
(0, 'Regular', 'Regularly scheduled pickup'),
(1, 'No pickup', 'No pickup available'),
(2, 'Phone', 'Must phone agency to arrange pickup'),
(3, 'Coordinate with Driver', 'Must coordinate with driver to arrange pickup')

CREATE TABLE ETS2_drop_off_types (
	drop_off_type INT PRIMARY KEY,
	drop_off_type_name nvarchar(255) NOT NULL,
	drop_off_type_desc nvarchar(1024) NULL
)
INSERT INTO ETS2_drop_off_types VALUES
(0, 'Regular', 'Regularly scheduled drop off'),
(1, 'No drop off', 'No drop off available'),
(2, 'Phone', 'Must phone agency to arrange drop off'),
(3, 'Coordinate with Driver', 'Must coordinate with driver to arrange drop off')


--INSERT INTO ETS2_stops VALUES(1001,1001,'Abbottsfield Transit Centre',NULL,53.571965,-113.390362,NULL,NULL,0,NULL)
--DROP TABLE ETS2_stop_times
CREATE TABLE ETS2_stop_times (
	--stimeID INT IDENTITY PRIMARY KEY, --I don't use this so removing it might save me from running out of keys later
	trip_id VARCHAR(255) NOT NULL REFERENCES ETS2_trips(trip_id),
	arrival_time varchar(8) NOT NULL, ---not used in practice. Can't store as time because they can go over 24:00 (even over 25:00)
	departure_hour int NOT NULL, --The hour and minute will be broken up here so they can be stored as INT for faster sorting
	departure_minute int NOT NULL,
	departure_second int NOT NULL,
	--departure_time varchar(8) NOT NULL, --Removed because this will now be split into hour/minute integers for smaller storage and faster operation
	stop_id VARCHAR(20) NOT NULL FOREIGN KEY REFERENCES ETS2_stops(stop_id),
	stop_sequence int NOT NULL, --integer
	--for proper normalization, stop_sequence really should be another DB table, but since it only seems to ever be one number, that's not so necesssary
	stop_headsign nvarchar(255) NULL,
	pickup_type INT DEFAULT 0 FOREIGN KEY REFERENCES ETS2_pickup_types(pickup_type),
	drop_off_type INT DEFAULT 0 FOREIGN KEY REFERENCES ETS2_drop_off_types(drop_off_type),
	shape_dist_traveled FLOAT(8) NULL, --theoretically could be a float, but is only ever int LOOKS LIKE I WAS WRONG ABOUT THIS!
	timepoint BIT NULL -- This should only ever be 1 or 0
)

--Table that allows quickly sorting nearby stops. This gets recreated every time the update is done.
CREATE TABLE ETS2_stop_routes (
stop_id VARCHAR(20) NOT NULL,
route_id varchar(20) NOT NULL,
agency_id VARCHAR(511) NOT NULL, 
PRIMARY KEY (stop_id, route_id, agency_id)
)

--Create some indicies on stop_times to improve certain operations
--DROP INDEX ix_ETS2_departure_hour ON ETS2_stop_times
--DROP INDEX ix_ETS2_departure_minute ON ETS2_stop_times
--DROP INDEX ix_ETS2_stop_id ON ETS2_stop_times
--DROP INDEX ix_ETS2_stop_sequence ON ETS2_stop_times
--DROP INDEX ix_ETS2_STIME_trip_id ON ETS2_stop_times
--DROP INDEX ix_ETS2_STIME_stop_id_trip_id ON ETS2_stop_times
-- For some reason these indexes seem to be slowing things down way more than helping.
--CREATE INDEX ix_ETS2_departure_hour ON ETS2_stop_times(departure_hour)
--CREATE INDEX ix_ETS2_departure_minute ON ETS2_stop_times(departure_minute)
--CREATE INDEX ix_ETS2_stop_id ON ETS2_stop_times(stop_id)
--CREATE INDEX ix_ETS2_stop_sequence ON ETS2_stop_times(stop_sequence)
--CREATE INDEX ix_ETS2_STIME_trip_id ON ETS2_stop_times(trip_id)
-- This index helps a lot, slows down imports by several seconds
--CREATE NONCLUSTERED INDEX ix_ETS2_STIME_stop_id_trip_id ON ETS2_stop_times (stop_id) INCLUDE (trip_id)

--This index gives me a 5x improvement
CREATE NONCLUSTERED INDEX ix_ETS2_STIME_trip_id_stop_id_stop_sequence ON [dbo].[ETS2_stop_times] ([trip_id],[stop_id],[stop_sequence])
--This index also speeds up the query a fair bit more
CREATE NONCLUSTERED INDEX ix_ETS2_stop_id ON [dbo].[ETS2_stop_times] ([stop_id]) INCLUDE ([trip_id])
--The benefits of this one seem insignificant
--CREATE NONCLUSTERED INDEX ix_ETS2_stopId_pickup_type ON [dbo].[ETS_stop_times] ([stop_id],[pickup_type]) INCLUDE ([trip_id],[arrival_time],[departure_hour],[departure_minute],[stop_sequence],[stop_headsign],[drop_off_type],[shape_dist_traveled])
CREATE NONCLUSTERED INDEX ix_ETS2_trip_id_stop_id_stop_sequence ON [dbo].[ETS2_stop_times] ([trip_id],[stop_id],[stop_sequence])


GO

--DROP VIEW ETS2_trip_stop_datetimes
-- Creates a very useful view from the stop_times
CREATE VIEW ETS2_trip_stop_datetimes WITH SCHEMABINDING AS
SELECT --TOP 10000
CASE WHEN departure_hour > 23 THEN
CONVERT(datetime, DATEADD(d, 1, date), 121)+CONVERT(datetime, CAST(departure_hour%24 AS varchar)+':'+CAST(departure_minute AS varchar), 121)
ELSE
CONVERT(datetime, date, 121)+CONVERT(datetime, CAST(departure_hour AS varchar)+':'+CAST(departure_minute AS varchar), 121)
END --CASE
AS ActualDateTime,
stime.trip_id, stime.arrival_time, stime.departure_hour, stime.departure_minute,stop_id, stime.stop_sequence, stime.stop_headsign, stime.pickup_type, stime.drop_off_type,
stime.shape_dist_traveled, stime.timepoint, t.route_id, t.service_id, t.trip_headsign, t.direction_id, t.block_id, t.shape_id, r.route_short_name, r.route_long_name, c.date, c.exception_type
FROM dbo.ETS2_stop_times stime
JOIN dbo.ETS2_trips t ON stime.trip_id=t.trip_id
JOIN dbo.ETS2_routes r ON t.route_id=r.route_id
JOIN dbo.ETS2_calendar_dates c ON c.service_id=t.service_id

GO


/************************************************************************
*
*  The ETS_activedb
*  Specifies which datbase is the active database, and which is the download database.
*
*************************************************************************/


IF OBJECT_ID('ETS_activedb') IS NOT NULL
	DROP TABLE ETS_activedb;
GO

CREATE TABLE ETS_activedb (
	dbid INT IDENTITY PRIMARY KEY,
	prefix varchar(20) NOT NULL,
	description varchar(256) NULL,
	active bit NOT NULL,
	updated datetime NULL
)

INSERT INTO ETS_activedb (prefix, description, active) VALUES('ETS1', 'Primary ETS Database', 1)
INSERT INTO ETS_activedb (prefix, description, active) VALUES('ETS2', 'Secondary ETS Database', 0)



IF OBJECT_ID('ETS_LRTStations') IS NOT NULL
	DROP TABLE ETS_LRTStations;
GO


CREATE TABLE ETS_LRTStations(
	StationID int IDENTITY(1,1) NOT NULL,
	StationCode varchar(20) NOT NULL,
	StationName nvarchar(255) NOT NULL,
	Coordinates varchar(30) NULL,
	CostFromOrigin float NOT NULL,
	Type varchar(255) NULL,
	stop_id1 varchar(20) NULL,
	stop_id2 varchar(20) NULL,
	AdditionalInfo nvarchar(1024) NULL,
	Abbr varchar(8) NULL
)

GO
SET IDENTITY_INSERT ETS_LRTStations ON 

INSERT ETS_LRTStations (StationID, StationCode, StationName, Coordinates, CostFromOrigin, Type, stop_id1, stop_id2, AdditionalInfo, Abbr) VALUES
(1, N'Century Park', N'Century Park', N'53.457740, -113.516420', 1000, N'Surface', 4982, 4982, NULL, N'CentPrk'),
(2, N'Southgate', N'Southgate', N'53.485716, -113.516885', 1004, N'Surface', 2114, 2113, NULL, N'SGate'),
(3, N'South Campus', N'South Campus/Fort Edmonton Park', N'53.502937, -113.528425', 1008, N'Surface', 2116, 2115, NULL, N'SCampus'),
(4, N'McKernan', N'McKernan/Belgravia', N'53.512400, -113.525762', 1010, N'Surface', 9982, 9981, NULL, N'McKrnan'),
(5, N'Health Sciences', N'Health Sciences/Jubilee', N'53.519929, -113.525934', 1012, N'Surface', 2014, 2019, NULL, N'HlthSci'),
(6, N'University', N'University', N'53.525137, -113.521555', 1014, N'Underground', 2969, 2316, NULL, N'Univrsty'),
(7, N'Grandin', N'Grandin/Government Centre', N'53.5367641, -113.5103814', 1016, N'Underground', 1754, 1925, NULL, N'Grandin'),
(8, N'Corona', N'Corona', N'53.5407428, -113.5045129', 1018, N'Underground', 1926, 1891, NULL, N'Corona'),
(9, N'Enterprise', N'Bay/Enterprise Square', N'53.540976, -113.498197', 1019, N'Underground', 1985, 1774, NULL, N'Bay/Ent'),
(10, N'Central', N'Central', N'53.541029, -113.491723', 1021, N'Underground', 1863, 1935, NULL, N'Central'),
(11, N'Churchill', N'Churchill', N'53.544309, -113.48917', 1022, N'Underground', 1691, 1876, NULL, N'Churchl'),
(12, N'Stadium', N'Stadium', N'53.559794, -113.471030', 1025, N'Surface', 1981, 1723, NULL, N'Stadium'),
(13, N'Coliseum', N'Coliseum', N'53.570662, -113.458589', 1028, N'Surface', 1742, 1889, NULL, N'Coliseum'),
(14, N'Belvedere', N'Belvedere', N'53.588340, -113.432873', 1032, N'Surface', 7830, 7692, NULL, N'Belvdr'),
(15, N'Clareview', N'Clareview', N'53.601662, -113.411959', 1035, N'Surface', 7977, 7977, NULL, N'Clarevw'),
(16, N'MacEwan', N'MacEwan', N'53.547677, -113.498245', 1025, N'Surface', 1117, 1118, NULL, N'MacEwan'),
(17, N'Kingsway', N'Kingsway/RAH', N'53.557968, -113.501446', 1028, N'Surface', 1115, 1114, NULL, N'Kingswy'),
(18, N'NAIT', N'NAIT', N'53.565970, -113.505724', 1030, N'Surface', 1116, 1116, NULL, N'NAIT')
SET IDENTITY_INSERT ETS_LRTStations OFF
GO

IF OBJECT_ID('ETSRT_update_log') IS NULL
CREATE TABLE ETSRT_update_log(
	[upid] [int] IDENTITY(1,1) NOT NULL,
	[StartTime] [datetime] NULL,
	[EndTime] [datetime] NULL,
	[Success] [bit] NULL,
	[Comment] [varchar](1024) NULL,
	[Filesize] [int] NULL,
	[Records] [int] NULL,
	PRIMARY KEY CLUSTERED (upid)
)

IF OBJECT_ID('ETSRT1_stop_time_update') IS NULL
CREATE TABLE ETSRT1_stop_time_update(
	[trip_id] [int] NULL,
	[delay] [int] NULL,
	[departure_uncertainty] [int] NULL,
	[time] [int] NULL,
	[schedule_relationship] [varchar](255) NULL,
	[stop_id] [varchar](20) NOT NULL,
	[stop_sequence] [int] NOT NULL
) ON [PRIMARY]

IF OBJECT_ID('ETSRT1_trip_update') IS NULL
CREATE TABLE ETSRT1_trip_update(
	[id] [int] NOT NULL,
	[route_id] [varchar](20) NULL,
	[schedule_relationship] [varchar](255) NULL,
	[start_datetime] [datetime] NOT NULL,
	PRIMARY KEY CLUSTERED (id, start_datetime ASC)
)
GO

IF OBJECT_ID('ETSRT_update') IS NOT NULL
DROP VIEW ETSRT_update

GO

CREATE VIEW ETSRT_update AS (SELECT *, DATEDIFF(ms,StartTime,EndTime) AS Runtime_ms , DATEDIFF(s,(SELECT StartTime FROM dbo.ETSRT_update_log
WHERE upid = (l.upid-1)), StartTime) AS SecondsSinceLastUpdate FROM dbo.ETSRT_update_log l)

