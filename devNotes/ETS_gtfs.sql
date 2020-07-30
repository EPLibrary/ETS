/************************************************************************
*
*  The ETS1 database is an alternate database so that the production and
*  import databases can be separated to avoid a catastrophic failure.
*
*************************************************************************/

USE ETS;


IF OBJECT_ID('ETS1_stop_times_all_agencies') IS NOT NULL
	DROP VIEW ETS1_stop_times_all_agencies;
IF OBJECT_ID('ETS1_trips_all_agencies') IS NOT NULL
	DROP VIEW ETS1_trips_all_agencies;
IF OBJECT_ID('ETS1_stops_all_agencies_unique') IS NOT NULL
	DROP VIEW ETS1_stops_all_agencies_unique;
IF OBJECT_ID('ETS1_stops_all_agencies') IS NOT NULL
	DROP VIEW ETS1_stops_all_agencies;
IF OBJECT_ID('ETS1_shapes_all_agencies') IS NOT NULL
	DROP VIEW ETS1_shapes_all_agencies;
IF OBJECT_ID('ETS1_routes_all_agencies') IS NOT NULL
	DROP VIEW ETS1_routes_all_agencies;
IF OBJECT_ID('ETS1_agency_all_agencies') IS NOT NULL
	DROP VIEW ETS1_agency_all_agencies;
IF OBJECT_ID('ETS1_trip_stop_datetimes_all_agencies') IS NOT NULL
	DROP VIEW ETS1_trip_stop_datetimes_all_agencies;
IF OBJECT_ID('ETS1_trip_stop_datetimes') IS NOT NULL
	DROP VIEW ETS1_trip_stop_datetimes;
IF OBJECT_ID('ETS1_trip_stop_datetimes_StAlbert') IS NOT NULL
	DROP VIEW ETS1_trip_stop_datetimes_StAlbert;
IF OBJECT_ID('ETS1_trip_stop_datetimes_Strathcona') IS NOT NULL
	DROP VIEW ETS1_trip_stop_datetimes_Strathcona;
IF OBJECT_ID('ETS1_stop_times') IS NOT NULL
	DROP TABLE ETS1_stop_times;
IF OBJECT_ID('ETS1_stop_times_StAlbert') IS NOT NULL
	DROP TABLE ETS1_stop_times_StAlbert;
IF OBJECT_ID('ETS1_stop_times_Strathcona') IS NOT NULL
	DROP TABLE ETS1_stop_times_Strathcona;
IF OBJECT_ID('ETS1_drop_off_types') IS NOT NULL
	DROP TABLE ETS1_drop_off_types;
IF OBJECT_ID('ETS1_pickup_types') IS NOT NULL
	DROP TABLE ETS1_pickup_types;
IF OBJECT_ID('ETS1_transfers') IS NOT NULL
	DROP TABLE ETS1_transfers;
IF OBJECT_ID('ETS1_transfers_StAlbert') IS NOT NULL
	DROP TABLE ETS1_transfers_StAlbert;
IF OBJECT_ID('ETS1_transfers_Strathcona') IS NOT NULL
	DROP TABLE ETS1_transfers_Strathcona;
IF OBJECT_ID('ETS1_transfer_types') IS NOT NULL
	DROP TABLE ETS1_transfer_types;
IF OBJECT_ID('ETS1_trips') IS NOT NULL
	DROP TABLE ETS1_trips;
IF OBJECT_ID('ETS1_trips_StAlbert') IS NOT NULL
	DROP TABLE ETS1_trips_StAlbert;
IF OBJECT_ID('ETS1_trips_Strathcona') IS NOT NULL
	DROP TABLE ETS1_trips_Strathcona;
IF OBJECT_ID('ETS1_stops') IS NOT NULL
	DROP TABLE ETS1_stops;
IF OBJECT_ID('ETS1_stops_StAlbert') IS NOT NULL
	DROP TABLE ETS1_stops_StAlbert;
IF OBJECT_ID('ETS1_stops_Strathcona') IS NOT NULL
	DROP TABLE ETS1_stops_Strathcona;
IF OBJECT_ID('ETS1_shapes') IS NOT NULL
	DROP TABLE ETS1_shapes;
IF OBJECT_ID('ETS1_shapes_StAlbert') IS NOT NULL
	DROP TABLE ETS1_shapes_StAlbert;
IF OBJECT_ID('ETS1_shapes_Strathcona') IS NOT NULL
	DROP TABLE ETS1_shapes_Strathcona;
IF OBJECT_ID('ETS1_routes') IS NOT NULL
	DROP TABLE ETS1_routes;
IF OBJECT_ID('ETS1_routes_StAlbert') IS NOT NULL
	DROP TABLE ETS1_routes_StAlbert;
IF OBJECT_ID('ETS1_routes_Strathcona') IS NOT NULL
	DROP TABLE ETS1_routes_Strathcona;
IF OBJECT_ID('ETS1_route_types') IS NOT NULL
	DROP TABLE ETS1_route_types;
IF OBJECT_ID('ETS1_stop_routes_all_agencies') IS NOT NULL
	DROP TABLE ETS1_stop_routes_all_agencies;
IF OBJECT_ID('ETS1_calendar') IS NOT NULL
	DROP TABLE ETS1_calendar;
IF OBJECT_ID('ETS1_calendar_StAlbert') IS NOT NULL
	DROP TABLE ETS1_calendar_StAlbert;
IF OBJECT_ID('ETS1_calendar_Strathcona') IS NOT NULL
	DROP TABLE ETS1_calendar_Strathcona;
IF OBJECT_ID('ETS1_calendar_dates') IS NOT NULL
	DROP TABLE ETS1_calendar_dates;
IF OBJECT_ID('ETS1_calendar_dates_StAlbert') IS NOT NULL
	DROP TABLE ETS1_calendar_dates_StAlbert;
IF OBJECT_ID('ETS1_calendar_dates_Strathcona') IS NOT NULL
	DROP TABLE ETS1_calendar_dates_Strathcona;
IF OBJECT_ID('ETS1_calendar_dates_complete_StAlbert') IS NOT NULL
	DROP TABLE ETS1_calendar_dates_complete_StAlbert;
IF OBJECT_ID('ETS1_calendar_dates_complete_Strathcona') IS NOT NULL
	DROP TABLE ETS1_calendar_dates_complete_Strathcona;
IF OBJECT_ID('ETS1_agency') IS NOT NULL
	DROP TABLE ETS1_agency;
IF OBJECT_ID('ETS1_agency_StAlbert') IS NOT NULL
	DROP TABLE ETS1_agency_StAlbert;
IF OBJECT_ID('ETS1_agency_Strathcona') IS NOT NULL
	DROP TABLE ETS1_agency_Strathcona;


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

CREATE TABLE ETS1_agency_StAlbert (
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

CREATE TABLE ETS1_agency_Strathcona (
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

CREATE TABLE ETS1_calendar_StAlbert (
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

CREATE TABLE ETS1_calendar_Strathcona (
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

CREATE TABLE ETS1_calendar_dates_StAlbert (
	cdID INT NOT NULL IDENTITY PRIMARY KEY,
	service_id varchar(255) NOT NULL,
	date DATE NOT NULL,
	exception_type INT NOT NULL,
	UNIQUE(service_id,date)
)

CREATE TABLE ETS1_calendar_dates_Strathcona (
	cdID INT NOT NULL IDENTITY PRIMARY KEY,
	service_id varchar(255) NOT NULL,
	date DATE NOT NULL,
	exception_type INT NOT NULL,
	UNIQUE(service_id,date)
)

--calendar_dates_complete is a version of calendar dates that just has every date in it, like Edmonton's, so this can be used in the main view
CREATE TABLE ETS1_calendar_dates_complete_StAlbert (
	cdcID INT NOT NULL IDENTITY PRIMARY KEY,
	service_id varchar(255) NOT NULL,
	date DATE NOT NULL,
	exception_type INT NOT NULL,
	UNIQUE(service_id,date)
)

CREATE TABLE ETS1_calendar_dates_complete_Strathcona (
	cdcID INT NOT NULL IDENTITY PRIMARY KEY,
	service_id varchar(255) NOT NULL,
	date DATE NOT NULL,
	exception_type INT NOT NULL,
	UNIQUE(service_id,date)
)


CREATE INDEX ix_ETS1_C_service_id ON ETS1_calendar_dates(service_id)
CREATE INDEX ix_ETS1_C_date ON ETS1_calendar_dates(date)

CREATE INDEX ix_ETS1_C_service_id_SA ON ETS1_calendar_dates_StAlbert(service_id)
CREATE INDEX ix_ETS1_C_date_SA ON ETS1_calendar_dates_StAlbert(date)

CREATE INDEX ix_ETS1_C_service_id_SC ON ETS1_calendar_dates_Strathcona(service_id)
CREATE INDEX ix_ETS1_C_date_SC ON ETS1_calendar_dates_Strathcona(date)

CREATE INDEX ix_ETS1_CC_service_id_SA ON ETS1_calendar_dates_complete_StAlbert(service_id)
CREATE INDEX ix_ETS1_CC_date_SA ON ETS1_calendar_dates_complete_StAlbert(date)

CREATE INDEX ix_ETS1_CC_service_id_SC ON ETS1_calendar_dates_complete_Strathcona(service_id)
CREATE INDEX ix_ETS1_CC_date_SC ON ETS1_calendar_dates_complete_Strathcona(date)

--INSERT INTO ETS1_calendar_dates VALUES('1-Saturday-1-JUN17-0000010',	'20170715',	1)
--SELECT * FROM ETS1_calendar_dates

--
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

CREATE TABLE ETS1_routes_StAlbert (
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

CREATE TABLE ETS1_routes_Strathcona (
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

--SELECT * FROM ETS1_routes
--INSERT INTO ETS1_routes VALUES(1,1,'West Edmonton Mall - Downtown - Capilano',NULL,3,NULL)

CREATE TABLE ETS1_shapes (
	shape_id varchar(255),
	shape_pt_lat float(8) NOT NULL,
	shape_pt_lon float(8) NOT NULL,
	shape_pt_sequence INT NOT NULL,
	PRIMARY KEY (shape_id, shape_pt_sequence)
)

CREATE TABLE ETS1_shapes_StAlbert (
	shape_id varchar(255),
	shape_pt_lat float(8) NOT NULL,
	shape_pt_lon float(8) NOT NULL,
	shape_pt_sequence INT NOT NULL,
	PRIMARY KEY (shape_id, shape_pt_sequence)
)

CREATE TABLE ETS1_shapes_Strathcona (
	shape_id varchar(255),
	shape_pt_lat float(8) NOT NULL,
	shape_pt_lon float(8) NOT NULL,
	shape_pt_sequence INT NOT NULL,
	PRIMARY KEY (shape_id, shape_pt_sequence)
)

--INSERT INTO ETS1_shapes VALUES('1-89-1',53.53864,-113.42325,1)
CREATE TABLE ETS1_stops (
	stop_id VARCHAR(20) PRIMARY KEY,
	stop_code INT NULL,
	stop_name nvarchar(512) NOT NULL,
	stop_desc nvarchar(1023) NULL,
	stop_lat float(8) NOT NULL,
	stop_lon float(8) NOT NULL,
	zone_id varchar(30) NULL,
	stop_url nvarchar(1023) NULL,
	location_type bit NULL, --0/blank = stop, 1 = Station
	parent_station VARCHAR(20) NULL,
	is_lrt bit NULL, --optional field added after import by my own code for simplicity
	exclusive bit NULL --can specify that this stop is not used by other agencies
)

--Experimental tables for other transit agencies
--DROP TABLE ETS1_stops_StAlbert
CREATE TABLE ETS1_stops_StAlbert (
	stop_id VARCHAR(20) PRIMARY KEY,
	stop_code INT NULL,
	stop_name nvarchar(512) NOT NULL,
	stop_desc nvarchar(1023) NULL,
	stop_lat float(8) NOT NULL,
	stop_lon float(8) NOT NULL,
	zone_id varchar(30) NULL,
	stop_url nvarchar(1023) NULL,
	location_type bit NULL, --0/blank = stop, 1 = Station
	parent_station VARCHAR(20) NULL,
	is_lrt bit NULL, --optional field added after import by my own code for simplicity
	exclusive bit NULL --can specify that this stop is not used by other agencies
)

--DROP TABLE ETS1_stops_Strathcona
CREATE TABLE ETS1_stops_Strathcona (
	stop_id VARCHAR(20) PRIMARY KEY,
	stop_code INT NULL,
	stop_name nvarchar(512) NOT NULL,
	stop_desc nvarchar(1023) NULL,
	stop_lat float(8) NOT NULL,
	stop_lon float(8) NOT NULL,
	zone_id varchar(30) NULL,
	stop_url nvarchar(1023) NULL,
	location_type bit NULL, --0/blank = stop, 1 = Station
	parent_station VARCHAR(20) NULL,
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
--DROP TABLE ETS1_trips_StAlbert
CREATE TABLE ETS1_trips_StAlbert (
	route_id VARCHAR(20) FOREIGN KEY REFERENCES ETS1_routes_StAlbert(route_id),
	service_id varchar(255), --FOREIGN KEY REFERENCES ETS1_calendar_dates(service_id),
	trip_id VARCHAR(255) PRIMARY KEY,
	trip_headsign nvarchar(255) NULL,
	direction_id bit NULL, --0 = outbound, 1 = inbound
	block_id varchar(30) NULL, /* Identifies the block to which the trip belongs. A block consists of two or more sequential trips made using the same vehicle, where a passenger can transfer from one trip to the next just by staying in the vehicle. The block_id must be referenced by two or more trips in trips.txt. */
	shape_id varchar(255) NULL, --REFERENCES ETS1_shapes(shape_id)
	wheelchair_accessible BIT,
	bikes_allowed BIT
)
--DROP TABLE ETS1_trips_Strathcona
CREATE TABLE ETS1_trips_Strathcona (
	route_id VARCHAR(20) FOREIGN KEY REFERENCES ETS1_routes_Strathcona(route_id),
	service_id varchar(255), --FOREIGN KEY REFERENCES ETS1_calendar_dates(service_id),
	trip_id VARCHAR(255) PRIMARY KEY,
	trip_headsign nvarchar(255) NULL,
	direction_id bit NULL, --0 = outbound, 1 = inbound
	block_id varchar(30) NULL, /* Identifies the block to which the trip belongs. A block consists of two or more sequential trips made using the same vehicle, where a passenger can transfer from one trip to the next just by staying in the vehicle. The block_id must be referenced by two or more trips in trips.txt. */
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

CREATE TABLE ETS1_transfers (
	from_stop_id VARCHAR(255) NOT NULL REFERENCES ETS1_trips(trip_id),
	to_stop_id VARCHAR(255) NOT NULL REFERENCES ETS1_trips(trip_id),
	transfer_type INT NULL REFERENCES ETS1_transfer_types(transfer_type),
	min_transfer_time INT NULL, -- value in seconds
	PRIMARY KEY (from_stop_id, to_stop_id)
)

CREATE TABLE ETS1_transfers_StAlbert (
	from_stop_id VARCHAR(255) NOT NULL REFERENCES ETS1_trips_StAlbert(trip_id),
	to_stop_id VARCHAR(255) NOT NULL REFERENCES ETS1_trips_StAlbert(trip_id),
	transfer_type INT NULL REFERENCES ETS1_transfer_types(transfer_type),
	min_transfer_time INT NULL, -- value in seconds
	PRIMARY KEY (from_stop_id, to_stop_id)
)

CREATE TABLE ETS1_transfers_Strathcona (
	from_stop_id VARCHAR(255) NOT NULL REFERENCES ETS1_trips_Strathcona(trip_id),
	to_stop_id VARCHAR(255) NOT NULL REFERENCES ETS1_trips_Strathcona(trip_id),
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

CREATE TABLE ETS1_stop_times_StAlbert (
	--stimeID INT IDENTITY PRIMARY KEY, --I don't use this so removing it might save me from running out of keys later
	trip_id VARCHAR(255) NOT NULL REFERENCES ETS1_trips_StAlbert(trip_id),
	arrival_time varchar(8) NOT NULL, ---not used in practice. Can't store as time because they can go over 24:00 (even over 25:00)
	departure_hour int NOT NULL, --The hour and minute will be broken up here so they can be stored as INT for faster sorting
	departure_minute int NOT NULL,
	departure_second int NOT NULL,
	--departure_time varchar(8) NOT NULL, --Removed because this will now be split into hour/minute integers for smaller storage and faster operation
	stop_id VARCHAR(20) NOT NULL FOREIGN KEY REFERENCES ETS1_stops_StAlbert(stop_id),
	stop_sequence int NOT NULL, --integer
	--for proper normalization, stop_sequence really should be another DB table, but since it only seems to ever be one number, that's not so necesssary
	stop_headsign nvarchar(255) NULL,
	pickup_type INT DEFAULT 0 FOREIGN KEY REFERENCES ETS1_pickup_types(pickup_type),
	drop_off_type INT DEFAULT 0 FOREIGN KEY REFERENCES ETS1_drop_off_types(drop_off_type),
	shape_dist_traveled FLOAT(8) NULL, --theoretically could be a float, but is only ever int LOOKS LIKE I WAS WRONG ABOUT THIS!
	timepoint BIT NULL -- This should only ever be 1 or 0
)

CREATE TABLE ETS1_stop_times_Strathcona (
	--stimeID INT IDENTITY PRIMARY KEY, --I don't use this so removing it might save me from running out of keys later
	trip_id VARCHAR(255) NOT NULL REFERENCES ETS1_trips_Strathcona(trip_id),
	arrival_time varchar(8) NOT NULL, ---not used in practice. Can't store as time because they can go over 24:00 (even over 25:00)
	departure_hour int NOT NULL, --The hour and minute will be broken up here so they can be stored as INT for faster sorting
	departure_minute int NOT NULL,
	departure_second int NOT NULL,
	--departure_time varchar(8) NOT NULL, --Removed because this will now be split into hour/minute integers for smaller storage and faster operation
	stop_id VARCHAR(20) NOT NULL FOREIGN KEY REFERENCES ETS1_stops_Strathcona(stop_id),
	stop_sequence int NOT NULL, --integer
	--for proper normalization, stop_sequence really should be another DB table, but since it only seems to ever be one number, that's not so necesssary
	stop_headsign nvarchar(255) NULL,
	pickup_type INT DEFAULT 0 FOREIGN KEY REFERENCES ETS1_pickup_types(pickup_type),
	drop_off_type INT DEFAULT 0 FOREIGN KEY REFERENCES ETS1_drop_off_types(drop_off_type),
	shape_dist_traveled FLOAT(8) NULL, --theoretically could be a float, but is only ever int LOOKS LIKE I WAS WRONG ABOUT THIS!
	timepoint BIT NULL -- This should only ever be 1 or 0
)

--Table that allows quickly sorting nearby stops. This gets recreated every time the update is done.
CREATE TABLE ETS1_stop_routes_all_agencies (
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


CREATE NONCLUSTERED INDEX ix_ETS1_STIME_trip_id_stop_id_stop_sequence_SA ON [dbo].[ETS1_stop_times_StAlbert] ([trip_id],[stop_id],[stop_sequence])
--This index also speeds up the query a fair bit more
CREATE NONCLUSTERED INDEX ix_ETS1_stop_id_SA ON [dbo].[ETS1_stop_times_StAlbert] ([stop_id]) INCLUDE ([trip_id])
--The benefits of this one seem insignificant
--CREATE NONCLUSTERED INDEX ix_ETS1_stopId_pickup_type ON [dbo].[ETS_stop_times] ([stop_id],[pickup_type]) INCLUDE ([trip_id],[arrival_time],[departure_hour],[departure_minute],[stop_sequence],[stop_headsign],[drop_off_type],[shape_dist_traveled])
CREATE NONCLUSTERED INDEX ix_ETS1_trip_id_stop_id_stop_sequence_SA ON [dbo].[ETS1_stop_times_StAlbert] ([trip_id],[stop_id],[stop_sequence])


CREATE NONCLUSTERED INDEX ix_ETS1_STIME_trip_id_stop_id_stop_sequence_SC ON [dbo].[ETS1_stop_times_Strathcona] ([trip_id],[stop_id],[stop_sequence])
--This index also speeds up the query a fair bit more
CREATE NONCLUSTERED INDEX ix_ETS1_stop_id_SC ON [dbo].[ETS1_stop_times_Strathcona] ([stop_id]) INCLUDE ([trip_id])
--The benefits of this one seem insignificant
--CREATE NONCLUSTERED INDEX ix_ETS1_stopId_pickup_type ON [dbo].[ETS_stop_times] ([stop_id],[pickup_type]) INCLUDE ([trip_id],[arrival_time],[departure_hour],[departure_minute],[stop_sequence],[stop_headsign],[drop_off_type],[shape_dist_traveled])
CREATE NONCLUSTERED INDEX ix_ETS1_trip_id_stop_id_stop_sequence_SC ON [dbo].[ETS1_stop_times_Strathcona] ([trip_id],[stop_id],[stop_sequence])

GO

--View containing all agencies with my hardcoded agency IDs
CREATE VIEW ETS1_agency_all_agencies WITH SCHEMABINDING AS
SELECT 1 AS agency_id, agency_name, agency_url, agency_timezone, agency_lang, agency_phone FROM dbo.ETS1_agency
UNION
SELECT 2 AS agency_id, agency_name, agency_url, agency_timezone, agency_lang, agency_phone FROM dbo.ETS1_agency_StAlbert
UNION 
SELECT 3 AS agency_id, agency_name, agency_url, agency_timezone, agency_lang, agency_phone FROM dbo.ETS1_agency_Strathcona

GO

CREATE VIEW ETS1_routes_all_agencies WITH SCHEMABINDING AS
SELECT route_id, route_short_name, route_long_name, route_desc, route_type, route_url, route_color, route_text_color, 1 AS agency_id
FROM dbo.ETS1_routes UNION
SELECT route_id, route_short_name, route_long_name, route_desc, route_type, route_url, route_color, route_text_color, 2 AS agency_id
FROM dbo.ETS1_routes_StAlbert UNION
SELECT route_id, route_short_name, route_long_name, route_desc, route_type, route_url, route_color, route_text_color, 3 AS agency_id
FROM dbo.ETS1_routes_Strathcona

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

CREATE VIEW ETS1_trip_stop_datetimes_StAlbert WITH SCHEMABINDING AS
SELECT --TOP 10000
CASE WHEN departure_hour > 23 THEN
CONVERT(datetime, DATEADD(d, 1, date), 121)+CONVERT(datetime, CAST(departure_hour%24 AS varchar)+':'+CAST(departure_minute AS varchar), 121)
ELSE
CONVERT(datetime, date, 121)+CONVERT(datetime, CAST(departure_hour AS varchar)+':'+CAST(departure_minute AS varchar), 121)
END --CASE
AS ActualDateTime,
stime.trip_id, stime.arrival_time, stime.departure_hour, stime.departure_minute,stop_id, stime.stop_sequence, stime.stop_headsign, stime.pickup_type, stime.drop_off_type,
stime.shape_dist_traveled, stime.timepoint,  t.route_id, t.service_id, t.trip_headsign, t.direction_id, t.block_id, t.shape_id, r.route_short_name, r.route_long_name, c.date, c.exception_type
FROM dbo.ETS1_stop_times_StAlbert stime
JOIN dbo.ETS1_trips_StAlbert t ON stime.trip_id=t.trip_id
JOIN dbo.ETS1_routes_StAlbert r ON t.route_id=r.route_id
JOIN dbo.ETS1_calendar_dates_complete_StAlbert c ON c.service_id=t.service_id

GO

CREATE VIEW ETS1_trip_stop_datetimes_Strathcona WITH SCHEMABINDING AS
SELECT --TOP 10000
CASE WHEN departure_hour > 23 THEN
CONVERT(datetime, DATEADD(d, 1, date), 121)+CONVERT(datetime, CAST(departure_hour%24 AS varchar)+':'+CAST(departure_minute AS varchar), 121)
ELSE
CONVERT(datetime, date, 121)+CONVERT(datetime, CAST(departure_hour AS varchar)+':'+CAST(departure_minute AS varchar), 121)
END --CASE
AS ActualDateTime,
stime.trip_id, stime.arrival_time, stime.departure_hour, stime.departure_minute,stop_id, stime.stop_sequence, stime.stop_headsign, stime.pickup_type, stime.drop_off_type,
stime.shape_dist_traveled, stime.timepoint,  t.route_id, t.service_id, t.trip_headsign, t.direction_id, t.block_id, t.shape_id, r.route_short_name, r.route_long_name, c.date, c.exception_type
FROM dbo.ETS1_stop_times_Strathcona stime
JOIN dbo.ETS1_trips_Strathcona t ON stime.trip_id=t.trip_id
JOIN dbo.ETS1_routes_Strathcona r ON t.route_id=r.route_id
JOIN dbo.ETS1_calendar_dates_complete_Strathcona c ON c.service_id=t.service_id

GO

--This view adds a unique id based on the zone_id to create a unique identifier
--June 11, 2019 - Edmonton started adding zone IDs and Strathcona removed theirs. I just make up a city code for non-edmonton cities and prepent that now.
--St. Albert starts with StA, Strathcona Str, Edmonton are just the regular ID
--DROP VIEW ETS1_stops_all_agencies_unique 
CREATE VIEW ETS1_stops_all_agencies_unique WITH SCHEMABINDING AS
SELECT CONCAT(left(REPLACE(city_code, '. ', ''), 3), stop_id) AS astop_id,
stop_id, stop_code, stop_name, stop_desc, stop_lat, stop_lon, zone_id, stop_url, location_type, parent_station, is_lrt, exclusive
FROM (SELECT '' AS city_code, stop_id, stop_code, stop_name, stop_desc, stop_lat, stop_lon, zone_id, stop_url, location_type, parent_station, is_lrt, exclusive FROM dbo.ETS1_stops
UNION SELECT 'StA' AS city_code, stop_id, stop_code, stop_name, stop_desc, stop_lat, stop_lon, zone_id, stop_url, location_type, parent_station, is_lrt, exclusive FROM dbo.ETS1_stops_StAlbert
UNION SELECT 'Str' AS city_code, stop_id, stop_code, stop_name, stop_desc, stop_lat, stop_lon, zone_id, stop_url, location_type, parent_station, is_lrt, exclusive FROM dbo.ETS1_stops_Strathcona)
AS allstops WHERE exclusive=1

GO

--DROP VIEW ETS1_stops_all_agencies
CREATE VIEW ETS1_stops_all_agencies WITH SCHEMABINDING AS
SELECT stop_id, stop_code, stop_name, stop_desc, stop_lat, stop_lon, zone_id, stop_url, location_type, parent_station, is_lrt, exclusive, 1 AS agency_id FROM dbo.ETS1_stops
UNION SELECT stop_id, stop_code, stop_name, stop_desc, stop_lat, stop_lon, zone_id, stop_url, location_type, parent_station, is_lrt, exclusive, 2 AS agency_id FROM dbo.ETS1_stops_StAlbert
UNION SELECT stop_id, stop_code, stop_name, stop_desc, stop_lat, stop_lon, zone_id, stop_url, location_type, parent_station, is_lrt, exclusive, 3 AS agency_id FROM dbo.ETS1_stops_Strathcona

GO

--Create a view of all trips
CREATE VIEW ETS1_trips_all_agencies WITH SCHEMABINDING AS
SELECT route_id, service_id, trip_id, trip_headsign, direction_id, block_id, shape_id, wheelchair_accessible, bikes_allowed, 1 AS agency_id
FROM dbo.ETS1_trips
UNION SELECT route_id, service_id, trip_id, trip_headsign, direction_id, block_id, shape_id, wheelchair_accessible, bikes_allowed, 2 AS agency_id
FROM dbo.ETS1_trips_StAlbert
UNION SELECT route_id, service_id, trip_id, trip_headsign, direction_id, block_id, shape_id, wheelchair_accessible, bikes_allowed, 3 AS agency_id
FROM dbo.ETS1_trips_Strathcona

GO

--View of all shapes
CREATE VIEW ETS1_shapes_all_agencies WITH SCHEMABINDING AS
SELECT shape_id, shape_pt_lat, shape_pt_lon, shape_pt_sequence, 1 AS agency_id FROM dbo.ETS1_shapes
UNION SELECT shape_id, shape_pt_lat, shape_pt_lon, shape_pt_sequence, 2 AS agency_id FROM dbo.ETS1_shapes_StAlbert
UNION SELECT shape_id, shape_pt_lat, shape_pt_lon, shape_pt_sequence, 3 AS agency_id  FROM dbo.ETS1_shapes_Strathcona

GO

--DROP VIEW ETS1_stop_times_all_agencies
CREATE VIEW ETS1_stop_times_all_agencies WITH SCHEMABINDING AS
SELECT trip_id, arrival_time, departure_hour, departure_minute, departure_second, stop_id, stop_sequence, stop_headsign, pickup_type, drop_off_type, shape_dist_traveled, timepoint, 1 AS agency_id
FROM dbo.ETS1_stop_times UNION
SELECT trip_id, arrival_time, departure_hour, departure_minute, departure_second, stop_id, stop_sequence, stop_headsign, pickup_type, drop_off_type, shape_dist_traveled, timepoint, 2 AS agency_id
FROM dbo.ETS1_stop_times_StAlbert UNION
SELECT trip_id, arrival_time, departure_hour, departure_minute, departure_second, stop_id, stop_sequence, stop_headsign, pickup_type, drop_off_type, shape_dist_traveled, timepoint, 3 AS agency_id
FROM dbo.ETS1_stop_times_Strathcona

GO

--The big kahuna
CREATE VIEW ETS1_trip_stop_datetimes_all_agencies WITH SCHEMABINDING AS
SELECT
1 AS agency_id, ActualDateTime, trip_id, arrival_time, departure_hour, departure_minute, stop_id, stop_headsign, pickup_type, drop_off_type, shape_dist_traveled, timepoint, route_id, service_id, trip_headsign, direction_id, block_id, shape_id, route_short_name, route_long_name, date, exception_type
FROM dbo.ETS1_trip_stop_datetimes
UNION SELECT
2 AS agency_id, ActualDateTime, trip_id, arrival_time, departure_hour, departure_minute, stop_id, stop_headsign, pickup_type, drop_off_type, shape_dist_traveled, timepoint, route_id, service_id, trip_headsign, direction_id, block_id, shape_id, route_short_name, route_long_name, date, exception_type
FROM dbo.ETS1_trip_stop_datetimes_Strathcona
UNION SELECT
3 AS agency_id, ActualDateTime, trip_id, arrival_time, departure_hour, departure_minute, stop_id, stop_headsign, pickup_type, drop_off_type, shape_dist_traveled, timepoint, route_id, service_id, trip_headsign, direction_id, block_id, shape_id, route_short_name, route_long_name, date, exception_type
FROM dbo.ETS1_trip_stop_datetimes_StAlbert

GO

/************************************************************************
*
*  The ETS2 database is an alternate database so that the production and
*  import databases can be separated to avoid a catastrophic failure.
*
*************************************************************************/

IF OBJECT_ID('ETS2_stop_times_all_agencies') IS NOT NULL
	DROP VIEW ETS2_stop_times_all_agencies;
IF OBJECT_ID('ETS2_trips_all_agencies') IS NOT NULL
	DROP VIEW ETS2_trips_all_agencies;
IF OBJECT_ID('ETS2_stops_all_agencies_unique') IS NOT NULL
	DROP VIEW ETS2_stops_all_agencies_unique;
IF OBJECT_ID('ETS2_stops_all_agencies') IS NOT NULL
	DROP VIEW ETS2_stops_all_agencies;
IF OBJECT_ID('ETS2_shapes_all_agencies') IS NOT NULL
	DROP VIEW ETS2_shapes_all_agencies;
IF OBJECT_ID('ETS2_routes_all_agencies') IS NOT NULL
	DROP VIEW ETS2_routes_all_agencies;
IF OBJECT_ID('ETS2_agency_all_agencies') IS NOT NULL
	DROP VIEW ETS2_agency_all_agencies;
IF OBJECT_ID('ETS2_trip_stop_datetimes_all_agencies') IS NOT NULL
	DROP VIEW ETS2_trip_stop_datetimes_all_agencies;
IF OBJECT_ID('ETS2_trip_stop_datetimes') IS NOT NULL
	DROP VIEW ETS2_trip_stop_datetimes;
IF OBJECT_ID('ETS2_trip_stop_datetimes_StAlbert') IS NOT NULL
	DROP VIEW ETS2_trip_stop_datetimes_StAlbert;
IF OBJECT_ID('ETS2_trip_stop_datetimes_Strathcona') IS NOT NULL
	DROP VIEW ETS2_trip_stop_datetimes_Strathcona;
IF OBJECT_ID('ETS2_stop_times') IS NOT NULL
	DROP TABLE ETS2_stop_times;
IF OBJECT_ID('ETS2_stop_times_StAlbert') IS NOT NULL
	DROP TABLE ETS2_stop_times_StAlbert;
IF OBJECT_ID('ETS2_stop_times_Strathcona') IS NOT NULL
	DROP TABLE ETS2_stop_times_Strathcona;
IF OBJECT_ID('ETS2_drop_off_types') IS NOT NULL
	DROP TABLE ETS2_drop_off_types;
IF OBJECT_ID('ETS2_pickup_types') IS NOT NULL
	DROP TABLE ETS2_pickup_types;
IF OBJECT_ID('ETS2_transfers') IS NOT NULL
	DROP TABLE ETS2_transfers;
IF OBJECT_ID('ETS2_transfers_StAlbert') IS NOT NULL
	DROP TABLE ETS2_transfers_StAlbert;
IF OBJECT_ID('ETS2_transfers_Strathcona') IS NOT NULL
	DROP TABLE ETS2_transfers_Strathcona;
IF OBJECT_ID('ETS2_transfer_types') IS NOT NULL
	DROP TABLE ETS2_transfer_types;
IF OBJECT_ID('ETS2_trips') IS NOT NULL
	DROP TABLE ETS2_trips;
IF OBJECT_ID('ETS2_trips_StAlbert') IS NOT NULL
	DROP TABLE ETS2_trips_StAlbert;
IF OBJECT_ID('ETS2_trips_Strathcona') IS NOT NULL
	DROP TABLE ETS2_trips_Strathcona;
IF OBJECT_ID('ETS2_stops') IS NOT NULL
	DROP TABLE ETS2_stops;
IF OBJECT_ID('ETS2_stops_StAlbert') IS NOT NULL
	DROP TABLE ETS2_stops_StAlbert;
IF OBJECT_ID('ETS2_stops_Strathcona') IS NOT NULL
	DROP TABLE ETS2_stops_Strathcona;
IF OBJECT_ID('ETS2_shapes') IS NOT NULL
	DROP TABLE ETS2_shapes;
IF OBJECT_ID('ETS2_shapes_StAlbert') IS NOT NULL
	DROP TABLE ETS2_shapes_StAlbert;
IF OBJECT_ID('ETS2_shapes_Strathcona') IS NOT NULL
	DROP TABLE ETS2_shapes_Strathcona;
IF OBJECT_ID('ETS2_routes') IS NOT NULL
	DROP TABLE ETS2_routes;
IF OBJECT_ID('ETS2_routes_StAlbert') IS NOT NULL
	DROP TABLE ETS2_routes_StAlbert;
IF OBJECT_ID('ETS2_routes_Strathcona') IS NOT NULL
	DROP TABLE ETS2_routes_Strathcona;
IF OBJECT_ID('ETS2_route_types') IS NOT NULL
	DROP TABLE ETS2_route_types;
IF OBJECT_ID('ETS2_stop_routes_all_agencies') IS NOT NULL
	DROP TABLE ETS2_stop_routes_all_agencies;
IF OBJECT_ID('ETS2_calendar') IS NOT NULL
	DROP TABLE ETS2_calendar;
IF OBJECT_ID('ETS2_calendar_StAlbert') IS NOT NULL
	DROP TABLE ETS2_calendar_StAlbert;
IF OBJECT_ID('ETS2_calendar_Strathcona') IS NOT NULL
	DROP TABLE ETS2_calendar_Strathcona;
IF OBJECT_ID('ETS2_calendar_dates') IS NOT NULL
	DROP TABLE ETS2_calendar_dates;
IF OBJECT_ID('ETS2_calendar_dates_StAlbert') IS NOT NULL
	DROP TABLE ETS2_calendar_dates_StAlbert;
IF OBJECT_ID('ETS2_calendar_dates_Strathcona') IS NOT NULL
	DROP TABLE ETS2_calendar_dates_Strathcona;
IF OBJECT_ID('ETS2_calendar_dates_complete_StAlbert') IS NOT NULL
	DROP TABLE ETS2_calendar_dates_complete_StAlbert;
IF OBJECT_ID('ETS2_calendar_dates_complete_Strathcona') IS NOT NULL
	DROP TABLE ETS2_calendar_dates_complete_Strathcona;
IF OBJECT_ID('ETS2_agency') IS NOT NULL
	DROP TABLE ETS2_agency;
IF OBJECT_ID('ETS2_agency_StAlbert') IS NOT NULL
	DROP TABLE ETS2_agency_StAlbert;
IF OBJECT_ID('ETS2_agency_Strathcona') IS NOT NULL
	DROP TABLE ETS2_agency_Strathcona;

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

CREATE TABLE ETS2_agency_StAlbert (
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

CREATE TABLE ETS2_agency_Strathcona (
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

CREATE TABLE ETS2_calendar_StAlbert (
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

CREATE TABLE ETS2_calendar_Strathcona (
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

CREATE TABLE ETS2_calendar_dates_StAlbert (
	cdID INT NOT NULL IDENTITY PRIMARY KEY,
	service_id varchar(255) NOT NULL,
	date DATE NOT NULL,
	exception_type INT NOT NULL,
	UNIQUE(service_id,date)
)

CREATE TABLE ETS2_calendar_dates_Strathcona (
	cdID INT NOT NULL IDENTITY PRIMARY KEY,
	service_id varchar(255) NOT NULL,
	date DATE NOT NULL,
	exception_type INT NOT NULL,
	UNIQUE(service_id,date)
)

--calendar_dates_complete is a version of calendar dates that just has every date in it, like Edmonton's, so this can be used in the main view
CREATE TABLE ETS2_calendar_dates_complete_StAlbert (
	cdcID INT NOT NULL IDENTITY PRIMARY KEY,
	service_id varchar(255) NOT NULL,
	date DATE NOT NULL,
	exception_type INT NOT NULL,
	UNIQUE(service_id,date)
)

CREATE TABLE ETS2_calendar_dates_complete_Strathcona (
	cdcID INT NOT NULL IDENTITY PRIMARY KEY,
	service_id varchar(255) NOT NULL,
	date DATE NOT NULL,
	exception_type INT NOT NULL,
	UNIQUE(service_id,date)
)


CREATE INDEX ix_ETS2_C_service_id ON ETS2_calendar_dates(service_id)
CREATE INDEX ix_ETS2_C_date ON ETS2_calendar_dates(date)

CREATE INDEX ix_ETS2_C_service_id_SA ON ETS2_calendar_dates_StAlbert(service_id)
CREATE INDEX ix_ETS2_C_date_SA ON ETS2_calendar_dates_StAlbert(date)

CREATE INDEX ix_ETS2_C_service_id_SC ON ETS2_calendar_dates_Strathcona(service_id)
CREATE INDEX ix_ETS2_C_date_SC ON ETS2_calendar_dates_Strathcona(date)

CREATE INDEX ix_ETS2_CC_service_id_SA ON ETS2_calendar_dates_complete_StAlbert(service_id)
CREATE INDEX ix_ETS2_CC_date_SA ON ETS2_calendar_dates_complete_StAlbert(date)

CREATE INDEX ix_ETS2_CC_service_id_SC ON ETS2_calendar_dates_complete_Strathcona(service_id)
CREATE INDEX ix_ETS2_CC_date_SC ON ETS2_calendar_dates_complete_Strathcona(date)

--INSERT INTO ETS2_calendar_dates VALUES('1-Saturday-1-JUN17-0000010',	'20170715',	1)
--SELECT * FROM ETS2_calendar_dates

--
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

CREATE TABLE ETS2_routes_StAlbert (
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

CREATE TABLE ETS2_routes_Strathcona (
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

CREATE TABLE ETS2_shapes_StAlbert (
	shape_id varchar(255),
	shape_pt_lat float(8) NOT NULL,
	shape_pt_lon float(8) NOT NULL,
	shape_pt_sequence INT NOT NULL,
	PRIMARY KEY (shape_id, shape_pt_sequence)
)

CREATE TABLE ETS2_shapes_Strathcona (
	shape_id varchar(255),
	shape_pt_lat float(8) NOT NULL,
	shape_pt_lon float(8) NOT NULL,
	shape_pt_sequence INT NOT NULL,
	PRIMARY KEY (shape_id, shape_pt_sequence)
)

--INSERT INTO ETS2_shapes VALUES('1-89-1',53.53864,-113.42325,1)
CREATE TABLE ETS2_stops (
	stop_id VARCHAR(20) PRIMARY KEY,
	stop_code INT NULL,
	stop_name nvarchar(512) NOT NULL,
	stop_desc nvarchar(1023) NULL,
	stop_lat float(8) NOT NULL,
	stop_lon float(8) NOT NULL,
	zone_id varchar(30) NULL,
	stop_url nvarchar(1023) NULL,
	location_type bit NULL, --0/blank = stop, 1 = Station
	parent_station VARCHAR(20) NULL,
	is_lrt bit NULL, --optional field added after import by my own code for simplicity
	exclusive bit NULL --can specify that this stop is not used by other agencies
)

--Experimental tables for other transit agencies
--DROP TABLE ETS2_stops_StAlbert
CREATE TABLE ETS2_stops_StAlbert (
	stop_id VARCHAR(20) PRIMARY KEY,
	stop_code INT NULL,
	stop_name nvarchar(512) NOT NULL,
	stop_desc nvarchar(1023) NULL,
	stop_lat float(8) NOT NULL,
	stop_lon float(8) NOT NULL,
	zone_id varchar(30) NULL,
	stop_url nvarchar(1023) NULL,
	location_type bit NULL, --0/blank = stop, 1 = Station
	parent_station VARCHAR(20) NULL,
	is_lrt bit NULL, --optional field added after import by my own code for simplicity
	exclusive bit NULL --can specify that this stop is not used by other agencies
)

--DROP TABLE ETS2_stops_Strathcona
CREATE TABLE ETS2_stops_Strathcona (
	stop_id VARCHAR(20) PRIMARY KEY,
	stop_code INT NULL,
	stop_name nvarchar(512) NOT NULL,
	stop_desc nvarchar(1023) NULL,
	stop_lat float(8) NOT NULL,
	stop_lon float(8) NOT NULL,
	zone_id varchar(30) NULL,
	stop_url nvarchar(1023) NULL,
	location_type bit NULL, --0/blank = stop, 1 = Station
	parent_station VARCHAR(20) NULL,
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
--DROP TABLE ETS2_trips_StAlbert
CREATE TABLE ETS2_trips_StAlbert (
	route_id VARCHAR(20) FOREIGN KEY REFERENCES ETS2_routes_StAlbert(route_id),
	service_id varchar(255), --FOREIGN KEY REFERENCES ETS2_calendar_dates(service_id),
	trip_id VARCHAR(255) PRIMARY KEY,
	trip_headsign nvarchar(255) NULL,
	direction_id bit NULL, --0 = outbound, 1 = inbound
	block_id varchar(30) NULL, /* Identifies the block to which the trip belongs. A block consists of two or more sequential trips made using the same vehicle, where a passenger can transfer from one trip to the next just by staying in the vehicle. The block_id must be referenced by two or more trips in trips.txt. */
	shape_id varchar(255) NULL, --REFERENCES ETS2_shapes(shape_id)
	wheelchair_accessible BIT,
	bikes_allowed BIT
)
--DROP TABLE ETS2_trips_Strathcona
CREATE TABLE ETS2_trips_Strathcona (
	route_id VARCHAR(20) FOREIGN KEY REFERENCES ETS2_routes_Strathcona(route_id),
	service_id varchar(255), --FOREIGN KEY REFERENCES ETS2_calendar_dates(service_id),
	trip_id VARCHAR(255) PRIMARY KEY,
	trip_headsign nvarchar(255) NULL,
	direction_id bit NULL, --0 = outbound, 1 = inbound
	block_id varchar(30) NULL, /* Identifies the block to which the trip belongs. A block consists of two or more sequential trips made using the same vehicle, where a passenger can transfer from one trip to the next just by staying in the vehicle. The block_id must be referenced by two or more trips in trips.txt. */
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

CREATE TABLE ETS2_transfers (
	from_stop_id VARCHAR(255) NOT NULL REFERENCES ETS2_trips(trip_id),
	to_stop_id VARCHAR(255) NOT NULL REFERENCES ETS2_trips(trip_id),
	transfer_type INT NULL REFERENCES ETS2_transfer_types(transfer_type),
	min_transfer_time INT NULL, -- value in seconds
	PRIMARY KEY (from_stop_id, to_stop_id)
)

CREATE TABLE ETS2_transfers_StAlbert (
	from_stop_id VARCHAR(255) NOT NULL REFERENCES ETS2_trips_StAlbert(trip_id),
	to_stop_id VARCHAR(255) NOT NULL REFERENCES ETS2_trips_StAlbert(trip_id),
	transfer_type INT NULL REFERENCES ETS2_transfer_types(transfer_type),
	min_transfer_time INT NULL, -- value in seconds
	PRIMARY KEY (from_stop_id, to_stop_id)
)

CREATE TABLE ETS2_transfers_Strathcona (
	from_stop_id VARCHAR(255) NOT NULL REFERENCES ETS2_trips_Strathcona(trip_id),
	to_stop_id VARCHAR(255) NOT NULL REFERENCES ETS2_trips_Strathcona(trip_id),
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

CREATE TABLE ETS2_stop_times_StAlbert (
	--stimeID INT IDENTITY PRIMARY KEY, --I don't use this so removing it might save me from running out of keys later
	trip_id VARCHAR(255) NOT NULL REFERENCES ETS2_trips_StAlbert(trip_id),
	arrival_time varchar(8) NOT NULL, ---not used in practice. Can't store as time because they can go over 24:00 (even over 25:00)
	departure_hour int NOT NULL, --The hour and minute will be broken up here so they can be stored as INT for faster sorting
	departure_minute int NOT NULL,
	departure_second int NOT NULL,
	--departure_time varchar(8) NOT NULL, --Removed because this will now be split into hour/minute integers for smaller storage and faster operation
	stop_id VARCHAR(20) NOT NULL FOREIGN KEY REFERENCES ETS2_stops_StAlbert(stop_id),
	stop_sequence int NOT NULL, --integer
	--for proper normalization, stop_sequence really should be another DB table, but since it only seems to ever be one number, that's not so necesssary
	stop_headsign nvarchar(255) NULL,
	pickup_type INT DEFAULT 0 FOREIGN KEY REFERENCES ETS2_pickup_types(pickup_type),
	drop_off_type INT DEFAULT 0 FOREIGN KEY REFERENCES ETS2_drop_off_types(drop_off_type),
	shape_dist_traveled FLOAT(8) NULL, --theoretically could be a float, but is only ever int LOOKS LIKE I WAS WRONG ABOUT THIS!
	timepoint BIT NULL -- This should only ever be 1 or 0
)

CREATE TABLE ETS2_stop_times_Strathcona (
	--stimeID INT IDENTITY PRIMARY KEY, --I don't use this so removing it might save me from running out of keys later
	trip_id VARCHAR(255) NOT NULL REFERENCES ETS2_trips_Strathcona(trip_id),
	arrival_time varchar(8) NOT NULL, ---not used in practice. Can't store as time because they can go over 24:00 (even over 25:00)
	departure_hour int NOT NULL, --The hour and minute will be broken up here so they can be stored as INT for faster sorting
	departure_minute int NOT NULL,
	departure_second int NOT NULL,
	--departure_time varchar(8) NOT NULL, --Removed because this will now be split into hour/minute integers for smaller storage and faster operation
	stop_id VARCHAR(20) NOT NULL FOREIGN KEY REFERENCES ETS2_stops_Strathcona(stop_id),
	stop_sequence int NOT NULL, --integer
	--for proper normalization, stop_sequence really should be another DB table, but since it only seems to ever be one number, that's not so necesssary
	stop_headsign nvarchar(255) NULL,
	pickup_type INT DEFAULT 0 FOREIGN KEY REFERENCES ETS2_pickup_types(pickup_type),
	drop_off_type INT DEFAULT 0 FOREIGN KEY REFERENCES ETS2_drop_off_types(drop_off_type),
	shape_dist_traveled FLOAT(8) NULL, --theoretically could be a float, but is only ever int LOOKS LIKE I WAS WRONG ABOUT THIS!
	timepoint BIT NULL -- This should only ever be 1 or 0
)

--Table that allows quickly sorting nearby stops. This gets recreated every time the update is done.
CREATE TABLE ETS2_stop_routes_all_agencies (
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


CREATE NONCLUSTERED INDEX ix_ETS2_STIME_trip_id_stop_id_stop_sequence_SA ON [dbo].[ETS2_stop_times_StAlbert] ([trip_id],[stop_id],[stop_sequence])
--This index also speeds up the query a fair bit more
CREATE NONCLUSTERED INDEX ix_ETS2_stop_id_SA ON [dbo].[ETS2_stop_times_StAlbert] ([stop_id]) INCLUDE ([trip_id])
--The benefits of this one seem insignificant
--CREATE NONCLUSTERED INDEX ix_ETS2_stopId_pickup_type ON [dbo].[ETS_stop_times] ([stop_id],[pickup_type]) INCLUDE ([trip_id],[arrival_time],[departure_hour],[departure_minute],[stop_sequence],[stop_headsign],[drop_off_type],[shape_dist_traveled])
CREATE NONCLUSTERED INDEX ix_ETS2_trip_id_stop_id_stop_sequence_SA ON [dbo].[ETS2_stop_times_StAlbert] ([trip_id],[stop_id],[stop_sequence])


CREATE NONCLUSTERED INDEX ix_ETS2_STIME_trip_id_stop_id_stop_sequence_SC ON [dbo].[ETS2_stop_times_Strathcona] ([trip_id],[stop_id],[stop_sequence])
--This index also speeds up the query a fair bit more
CREATE NONCLUSTERED INDEX ix_ETS2_stop_id_SC ON [dbo].[ETS2_stop_times_Strathcona] ([stop_id]) INCLUDE ([trip_id])
--The benefits of this one seem insignificant
--CREATE NONCLUSTERED INDEX ix_ETS2_stopId_pickup_type ON [dbo].[ETS_stop_times] ([stop_id],[pickup_type]) INCLUDE ([trip_id],[arrival_time],[departure_hour],[departure_minute],[stop_sequence],[stop_headsign],[drop_off_type],[shape_dist_traveled])
CREATE NONCLUSTERED INDEX ix_ETS2_trip_id_stop_id_stop_sequence_SC ON [dbo].[ETS2_stop_times_Strathcona] ([trip_id],[stop_id],[stop_sequence])

GO

--View containing all agencies with my hardcoded agency IDs
CREATE VIEW ETS2_agency_all_agencies WITH SCHEMABINDING AS
SELECT 1 AS agency_id, agency_name, agency_url, agency_timezone, agency_lang, agency_phone FROM dbo.ETS2_agency
UNION
SELECT 2 AS agency_id, agency_name, agency_url, agency_timezone, agency_lang, agency_phone FROM dbo.ETS2_agency_StAlbert
UNION
SELECT 3 AS agency_id, agency_name, agency_url, agency_timezone, agency_lang, agency_phone FROM dbo.ETS2_agency_Strathcona

GO

CREATE VIEW ETS2_routes_all_agencies WITH SCHEMABINDING AS
SELECT route_id, route_short_name, route_long_name, route_desc, route_type, route_url, route_color, route_text_color, 1 AS agency_id
FROM dbo.ETS2_routes UNION
SELECT route_id, route_short_name, route_long_name, route_desc, route_type, route_url, route_color, route_text_color, 2 AS agency_id
FROM dbo.ETS2_routes_StAlbert UNION
SELECT route_id, route_short_name, route_long_name, route_desc, route_type, route_url, route_color, route_text_color, 3 AS agency_id
FROM dbo.ETS2_routes_Strathcona

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

CREATE VIEW ETS2_trip_stop_datetimes_StAlbert WITH SCHEMABINDING AS
SELECT --TOP 10000
CASE WHEN departure_hour > 23 THEN
CONVERT(datetime, DATEADD(d, 1, date), 121)+CONVERT(datetime, CAST(departure_hour%24 AS varchar)+':'+CAST(departure_minute AS varchar), 121)
ELSE
CONVERT(datetime, date, 121)+CONVERT(datetime, CAST(departure_hour AS varchar)+':'+CAST(departure_minute AS varchar), 121)
END --CASE
AS ActualDateTime,
stime.trip_id, stime.arrival_time, stime.departure_hour, stime.departure_minute,stop_id, stime.stop_sequence, stime.stop_headsign, stime.pickup_type, stime.drop_off_type,
stime.shape_dist_traveled, stime.timepoint,  t.route_id, t.service_id, t.trip_headsign, t.direction_id, t.block_id, t.shape_id, r.route_short_name, r.route_long_name, c.date, c.exception_type
FROM dbo.ETS2_stop_times_StAlbert stime
JOIN dbo.ETS2_trips_StAlbert t ON stime.trip_id=t.trip_id
JOIN dbo.ETS2_routes_StAlbert r ON t.route_id=r.route_id
JOIN dbo.ETS2_calendar_dates_complete_StAlbert c ON c.service_id=t.service_id

GO

CREATE VIEW ETS2_trip_stop_datetimes_Strathcona WITH SCHEMABINDING AS
SELECT --TOP 10000
CASE WHEN departure_hour > 23 THEN
CONVERT(datetime, DATEADD(d, 1, date), 121)+CONVERT(datetime, CAST(departure_hour%24 AS varchar)+':'+CAST(departure_minute AS varchar), 121)
ELSE
CONVERT(datetime, date, 121)+CONVERT(datetime, CAST(departure_hour AS varchar)+':'+CAST(departure_minute AS varchar), 121)
END --CASE
AS ActualDateTime,
stime.trip_id, stime.arrival_time, stime.departure_hour, stime.departure_minute,stop_id, stime.stop_sequence, stime.stop_headsign, stime.pickup_type, stime.drop_off_type,
stime.shape_dist_traveled, stime.timepoint,  t.route_id, t.service_id, t.trip_headsign, t.direction_id, t.block_id, t.shape_id, r.route_short_name, r.route_long_name, c.date, c.exception_type
FROM dbo.ETS2_stop_times_Strathcona stime
JOIN dbo.ETS2_trips_Strathcona t ON stime.trip_id=t.trip_id
JOIN dbo.ETS2_routes_Strathcona r ON t.route_id=r.route_id
JOIN dbo.ETS2_calendar_dates_complete_Strathcona c ON c.service_id=t.service_id

GO

--This view adds a unique id based on the zone_id to create a unique identifier
--June 11, 2019 - Edmonton started adding zone IDs and Strathcona removed theirs. I just make up a city code for non-edmonton cities and prepent that now.
--St. Albert starts with StA, Strathcona Str, Edmonton are just the regular ID
--DROP VIEW ETS2_stops_all_agencies_unique 
CREATE VIEW ETS2_stops_all_agencies_unique WITH SCHEMABINDING AS
SELECT CONCAT(left(REPLACE(city_code, '. ', ''), 3), stop_id) AS astop_id,
stop_id, stop_code, stop_name, stop_desc, stop_lat, stop_lon, zone_id, stop_url, location_type, parent_station, is_lrt, exclusive
FROM (SELECT '' AS city_code, stop_id, stop_code, stop_name, stop_desc, stop_lat, stop_lon, zone_id, stop_url, location_type, parent_station, is_lrt, exclusive FROM dbo.ETS2_stops
UNION SELECT 'StA' AS city_code, stop_id, stop_code, stop_name, stop_desc, stop_lat, stop_lon, zone_id, stop_url, location_type, parent_station, is_lrt, exclusive FROM dbo.ETS2_stops_StAlbert
UNION SELECT 'Str' AS city_code, stop_id, stop_code, stop_name, stop_desc, stop_lat, stop_lon, zone_id, stop_url, location_type, parent_station, is_lrt, exclusive FROM dbo.ETS2_stops_Strathcona)
AS allstops WHERE exclusive=1

GO

--DROP VIEW ETS2_stops_all_agencies
CREATE VIEW ETS2_stops_all_agencies WITH SCHEMABINDING AS
SELECT stop_id, stop_code, stop_name, stop_desc, stop_lat, stop_lon, zone_id, stop_url, location_type, parent_station, is_lrt, exclusive, 1 AS agency_id FROM dbo.ETS2_stops
UNION SELECT stop_id, stop_code, stop_name, stop_desc, stop_lat, stop_lon, zone_id, stop_url, location_type, parent_station, is_lrt, exclusive, 2 AS agency_id FROM dbo.ETS2_stops_StAlbert
UNION SELECT stop_id, stop_code, stop_name, stop_desc, stop_lat, stop_lon, zone_id, stop_url, location_type, parent_station, is_lrt, exclusive, 3 AS agency_id FROM dbo.ETS2_stops_Strathcona

GO

--Create a view of all trips
CREATE VIEW ETS2_trips_all_agencies WITH SCHEMABINDING AS
SELECT route_id, service_id, trip_id, trip_headsign, direction_id, block_id, shape_id, wheelchair_accessible, bikes_allowed, 1 AS agency_id
FROM dbo.ETS2_trips
UNION SELECT route_id, service_id, trip_id, trip_headsign, direction_id, block_id, shape_id, wheelchair_accessible, bikes_allowed, 2 AS agency_id
FROM dbo.ETS2_trips_StAlbert
UNION SELECT route_id, service_id, trip_id, trip_headsign, direction_id, block_id, shape_id, wheelchair_accessible, bikes_allowed, 3 AS agency_id
FROM dbo.ETS2_trips_Strathcona

GO
--View of all shapes
CREATE VIEW ETS2_shapes_all_agencies WITH SCHEMABINDING AS
SELECT shape_id, shape_pt_lat, shape_pt_lon, shape_pt_sequence, 1 AS agency_id FROM dbo.ETS2_shapes
UNION SELECT shape_id, shape_pt_lat, shape_pt_lon, shape_pt_sequence, 2 AS agency_id FROM dbo.ETS2_shapes_StAlbert
UNION SELECT shape_id, shape_pt_lat, shape_pt_lon, shape_pt_sequence, 3 AS agency_id  FROM dbo.ETS2_shapes_Strathcona

GO

--DROP VIEW ETS2_stop_times_all_agencies
CREATE VIEW ETS2_stop_times_all_agencies WITH SCHEMABINDING AS
SELECT trip_id, arrival_time, departure_hour, departure_minute, departure_second, stop_id, stop_sequence, stop_headsign, pickup_type, drop_off_type, shape_dist_traveled, timepoint, 1 AS agency_id
FROM dbo.ETS2_stop_times UNION
SELECT trip_id, arrival_time, departure_hour, departure_minute, departure_second, stop_id, stop_sequence, stop_headsign, pickup_type, drop_off_type, shape_dist_traveled, timepoint, 2 AS agency_id
FROM dbo.ETS2_stop_times_StAlbert UNION
SELECT trip_id, arrival_time, departure_hour, departure_minute, departure_second, stop_id, stop_sequence, stop_headsign, pickup_type, drop_off_type, shape_dist_traveled, timepoint, 3 AS agency_id
FROM dbo.ETS2_stop_times_Strathcona

GO

--The big kahuna
CREATE VIEW ETS2_trip_stop_datetimes_all_agencies WITH SCHEMABINDING AS
SELECT
1 AS agency_id, ActualDateTime, trip_id, arrival_time, departure_hour, departure_minute, stop_id, stop_headsign, pickup_type, drop_off_type, shape_dist_traveled, timepoint, route_id, service_id, trip_headsign, direction_id, block_id, shape_id, route_short_name, route_long_name, date, exception_type
FROM dbo.ETS2_trip_stop_datetimes
UNION SELECT
2 AS agency_id, ActualDateTime, trip_id, arrival_time, departure_hour, departure_minute, stop_id, stop_headsign, pickup_type, drop_off_type, shape_dist_traveled, timepoint, route_id, service_id, trip_headsign, direction_id, block_id, shape_id, route_short_name, route_long_name, date, exception_type
FROM dbo.ETS2_trip_stop_datetimes_Strathcona
UNION SELECT
3 AS agency_id, ActualDateTime, trip_id, arrival_time, departure_hour, departure_minute, stop_id, stop_headsign, pickup_type, drop_off_type, shape_dist_traveled, timepoint, route_id, service_id, trip_headsign, direction_id, block_id, shape_id, route_short_name, route_long_name, date, exception_type
FROM dbo.ETS2_trip_stop_datetimes_StAlbert

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
	stop_id1 int NULL,
	stop_id2 int NULL,
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
	[stop_id] [int] NOT NULL,
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

