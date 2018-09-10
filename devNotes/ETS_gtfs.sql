/************************************************************************
*
*  The ETS1 database is an alternate database so that the production and
*  import databases can be separated to avoid a catastrophic failure.
*
*************************************************************************/

DROP VIEW vsd.ETS1_trip_stop_datetimes_all_agencies
DROP VIEW vsd.ETS1_trip_stop_datetimes
DROP VIEW vsd.ETS1_trip_stop_datetimes_StAlbert
DROP VIEW vsd.ETS1_trip_stop_datetimes_Strathcona
DROP TABLE vsd.ETS1_stop_times
DROP TABLE vsd.ETS1_stop_times_StAlbert
DROP TABLE vsd.ETS1_stop_times_Strathcona
DROP TABLE vsd.ETS1_drop_off_types
DROP TABLE vsd.ETS1_pickup_types
DROP TABLE vsd.ETS1_transfers
DROP TABLE vsd.ETS1_transfers_StAlbert
DROP TABLE vsd.ETS1_transfers_Strathcona
DROP TABLE vsd.ETS1_transfer_types
DROP TABLE vsd.ETS1_trips
DROP TABLE vsd.ETS1_trips_StAlbert
DROP TABLE vsd.ETS1_trips_Strathcona
DROP TABLE vsd.ETS1_stops
DROP TABLE vsd.ETS1_stops_StAlbert
DROP TABLE vsd.ETS1_stops_Strathcona
DROP TABLE vsd.ETS1_shapes
DROP TABLE vsd.ETS1_shapes_StAlbert
DROP TABLE vsd.ETS1_shapes_Strathcona
DROP TABLE vsd.ETS1_routes
DROP TABLE vsd.ETS1_routes_StAlbert
DROP TABLE vsd.ETS1_routes_Strathcona
DROP TABLE vsd.ETS1_route_types
DROP TABLE vsd.ETS1_calendar_dates
DROP TABLE vsd.ETS1_calendar_dates_StAlbert
DROP TABLE vsd.ETS1_calendar_dates_Strathcona
DROP TABLE vsd.ETS1_agency
DROP TABLE vsd.ETS1_agency_StAlbert
DROP TABLE vsd.ETS1_agency_Strathcona

CREATE TABLE vsd.ETS1_agency (
	aID INT NOT NULL IDENTITY PRIMARY KEY,
	agency_name nvarchar(255) NOT NULL,
	agency_url nvarchar(1024) NOT NULL,
	agency_timezone nvarchar(255) NOT NULL,
	agency_lang varchar(5) NOT NULL,
	agency_phone varchar(16) NULL
)

CREATE TABLE vsd.ETS1_agency_StAlbert (
	aID INT NOT NULL IDENTITY PRIMARY KEY,
	agency_name nvarchar(255) NOT NULL,
	agency_url nvarchar(1024) NOT NULL,
	agency_timezone nvarchar(255) NOT NULL,
	agency_lang varchar(5) NOT NULL,
	agency_phone varchar(16) NULL
)

CREATE TABLE vsd.ETS1_agency_Strathcona (
	aID INT NOT NULL IDENTITY PRIMARY KEY,
	agency_name nvarchar(255) NOT NULL,
	agency_url nvarchar(1024) NOT NULL,
	agency_timezone nvarchar(255) NOT NULL,
	agency_lang varchar(5) NOT NULL,
	agency_phone varchar(16) NULL
)

CREATE TABLE vsd.ETS1_calendar (
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

CREATE TABLE vsd.ETS1_calendar_StAlbert (
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

CREATE TABLE vsd.ETS1_calendar_Strathcona (
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

CREATE TABLE vsd.ETS1_calendar_dates (
	cdID INT NOT NULL IDENTITY PRIMARY KEY,
	service_id varchar(255) NOT NULL,
	date DATE NOT NULL,
	exception_type INT NOT NULL,
	UNIQUE(service_id,date)
)

CREATE TABLE vsd.ETS1_calendar_dates_StAlbert (
	cdID INT NOT NULL IDENTITY PRIMARY KEY,
	service_id varchar(255) NOT NULL,
	date DATE NOT NULL,
	exception_type INT NOT NULL,
	UNIQUE(service_id,date)
)

CREATE TABLE vsd.ETS1_calendar_dates_Strathcona (
	cdID INT NOT NULL IDENTITY PRIMARY KEY,
	service_id varchar(255) NOT NULL,
	date DATE NOT NULL,
	exception_type INT NOT NULL,
	UNIQUE(service_id,date)
)

--calendar_dates_complete is a version of calendar dates that just has every date in it, like Edmonton's, so this can be used in the main view
CREATE TABLE vsd.ETS1_calendar_dates_complete_StAlbert (
	cdcID INT NOT NULL IDENTITY PRIMARY KEY,
	service_id varchar(255) NOT NULL,
	date DATE NOT NULL,
	exception_type INT NOT NULL,
	UNIQUE(service_id,date)
)

CREATE TABLE vsd.ETS1_calendar_dates_complete_Strathcona (
	cdcID INT NOT NULL IDENTITY PRIMARY KEY,
	service_id varchar(255) NOT NULL,
	date DATE NOT NULL,
	exception_type INT NOT NULL,
	UNIQUE(service_id,date)
)


CREATE INDEX ix_ETS1_C_service_id ON vsd.ETS1_calendar_dates(service_id)
CREATE INDEX ix_ETS1_C_date ON vsd.ETS1_calendar_dates(date)

CREATE INDEX ix_ETS1_C_service_id_SA ON vsd.ETS1_calendar_dates_StAlbert(service_id)
CREATE INDEX ix_ETS1_C_date_SA ON vsd.ETS1_calendar_dates_StAlbert(date)

CREATE INDEX ix_ETS1_C_service_id_SC ON vsd.ETS1_calendar_dates_Strathcona(service_id)
CREATE INDEX ix_ETS1_C_date_SC ON vsd.ETS1_calendar_dates_Strathcona(date)

CREATE INDEX ix_ETS2_CC_service_id_SA ON vsd.ETS1_calendar_dates_complete_StAlbert(service_id)
CREATE INDEX ix_ETS2_CC_date_SA ON vsd.ETS1_calendar_dates_complete_StAlbert(date)

CREATE INDEX ix_ETS2_CC_service_id_SC ON vsd.ETS1_calendar_dates_complete_Strathcona(service_id)
CREATE INDEX ix_ETS2_CC_date_SC ON vsd.ETS1_calendar_dates_complete_Strathcona(date)

--INSERT INTO vsd.ETS1_calendar_dates VALUES('1-Saturday-1-JUN17-0000010',	'20170715',	1)
--SELECT * FROM vsd.ETS1_calendar_dates

--
CREATE TABLE vsd.ETS1_route_types (
	route_type INT PRIMARY KEY,
	route_type_name nvarchar(255) NOT NULL,
	route_type_desc nvarchar(1024) NULL
)

INSERT INTO vsd.ETS1_route_types VALUES(0, 'Tram, Streetcar, Light Rail', 'Any light rail or street level system within a metropolitan area.')
INSERT INTO vsd.ETS1_route_types VALUES(1, 'Subway, Metro', 'Any underground rail system within a metropolitan area.')
INSERT INTO vsd.ETS1_route_types VALUES(2, 'Rail', 'Used for intercity or long-distance travel.')
INSERT INTO vsd.ETS1_route_types VALUES(3, 'Bus', 'Used for short- and long-distance bus routes.')
INSERT INTO vsd.ETS1_route_types VALUES(4, 'Ferry', 'Used for short- and long-distance boat service.')
INSERT INTO vsd.ETS1_route_types VALUES(5, 'Cable Car', 'Used for street-level cable cars where the cable runs beneath the car.')
INSERT INTO vsd.ETS1_route_types VALUES(6, 'Gondola, Suspended cable car.', 'Typically used for aerial cable cars where the car is suspended from the cable.')
INSERT INTO vsd.ETS1_route_types VALUES(7, 'Funicular', 'Any rail system designed for steep inclines.')

--DELETE FROM vsd.ETS1_routes
--DROP TABLE vsd.ETS1_routes
--2018-06-11 - updated route_id to be varchar to allow for Strathcona & St. Albert's format.
-- I'm concerned about the performance ramifications of this.
CREATE TABLE vsd.ETS1_routes (
	route_id VARCHAR(20) PRIMARY KEY,
	route_short_name nvarchar(511) NOT NULL,
	route_long_name nvarchar(1023) NOT NULL,
	route_desc nvarchar(1023) NULL,
	route_type INT NOT NULL FOREIGN KEY REFERENCES vsd.ETS1_route_types(route_type),
	route_url nvarchar(1023) NULL,
	route_color varchar(20),
	route_text_color varchar(20)
	--UNIQUE(route_id)
)

CREATE TABLE vsd.ETS1_routes_StAlbert (
	route_id VARCHAR(20) PRIMARY KEY,
	route_short_name nvarchar(511) NOT NULL,
	route_long_name nvarchar(1023) NOT NULL,
	route_desc nvarchar(1023) NULL,
	route_type INT NOT NULL FOREIGN KEY REFERENCES vsd.ETS1_route_types(route_type),
	route_url nvarchar(1023) NULL,
	route_color varchar(20),
	route_text_color varchar(20)
	--UNIQUE(route_id)
)

CREATE TABLE vsd.ETS1_routes_Strathcona (
	route_id VARCHAR(20) PRIMARY KEY,
	route_short_name nvarchar(511) NOT NULL,
	route_long_name nvarchar(1023) NOT NULL,
	route_desc nvarchar(1023) NULL,
	route_type INT NOT NULL FOREIGN KEY REFERENCES vsd.ETS1_route_types(route_type),
	route_url nvarchar(1023) NULL,
	route_color varchar(20),
	route_text_color varchar(20)
	--UNIQUE(route_id)
)

SELECT * FROM vsd.ETS1_routes
--INSERT INTO vsd.ETS1_routes VALUES(1,1,'West Edmonton Mall - Downtown - Capilano',NULL,3,NULL)

CREATE TABLE vsd.ETS1_shapes (
	shape_id varchar(255),
	shape_pt_lat float(8) NOT NULL,
	shape_pt_lon float(8) NOT NULL,
	shape_pt_sequence INT NOT NULL,
	PRIMARY KEY (shape_id, shape_pt_sequence)
)

CREATE TABLE vsd.ETS1_shapes_StAlbert (
	shape_id varchar(255),
	shape_pt_lat float(8) NOT NULL,
	shape_pt_lon float(8) NOT NULL,
	shape_pt_sequence INT NOT NULL,
	PRIMARY KEY (shape_id, shape_pt_sequence)
)

CREATE TABLE vsd.ETS1_shapes_Strathcona (
	shape_id varchar(255),
	shape_pt_lat float(8) NOT NULL,
	shape_pt_lon float(8) NOT NULL,
	shape_pt_sequence INT NOT NULL,
	PRIMARY KEY (shape_id, shape_pt_sequence)
)

--INSERT INTO vsd.ETS1_shapes VALUES('1-89-1',53.53864,-113.42325,1)
CREATE TABLE vsd.ETS1_stops (
	stop_id INT PRIMARY KEY,
	stop_code INT NULL,
	stop_name nvarchar(512) NOT NULL,
	stop_desc nvarchar(1023) NULL,
	stop_lat float(8) NOT NULL,
	stop_lon float(8) NOT NULL,
	zone_id varchar(30) NULL,
	stop_url nvarchar(1023) NULL,
	location_type bit NULL, --0/blank = stop, 1 = Station
	parent_station INT NULL,
	is_lrt bit NULL, --optional field added after import by my own code for simplicity
	exclusive bit NULL --can specify that this stop is not used by other agencies
)

--Experimental tables for other transit agencies
--DROP TABLE vsd.ETS1_stops_StAlbert
CREATE TABLE vsd.ETS1_stops_StAlbert (
	stop_id INT PRIMARY KEY,
	stop_code INT NULL,
	stop_name nvarchar(512) NOT NULL,
	stop_desc nvarchar(1023) NULL,
	stop_lat float(8) NOT NULL,
	stop_lon float(8) NOT NULL,
	zone_id varchar(30) NULL,
	stop_url nvarchar(1023) NULL,
	location_type bit NULL, --0/blank = stop, 1 = Station
	parent_station INT NULL,
	is_lrt bit NULL, --optional field added after import by my own code for simplicity
	exclusive bit NULL --can specify that this stop is not used by other agencies
)

--DROP TABLE vsd.ETS1_stops_Strathcona
CREATE TABLE vsd.ETS1_stops_Strathcona (
	stop_id INT PRIMARY KEY,
	stop_code INT NULL,
	stop_name nvarchar(512) NOT NULL,
	stop_desc nvarchar(1023) NULL,
	stop_lat float(8) NOT NULL,
	stop_lon float(8) NOT NULL,
	zone_id varchar(30) NULL,
	stop_url nvarchar(1023) NULL,
	location_type bit NULL, --0/blank = stop, 1 = Station
	parent_station INT NULL,
	is_lrt bit NULL, --optional field added after import by my own code for simplicity
	exclusive bit NULL --can specify that this stop is not used by other agencies
)

CREATE TABLE vsd.ETS1_trips (
	route_id VARCHAR(20) FOREIGN KEY REFERENCES vsd.ETS1_routes(route_id),
	service_id varchar(255), --FOREIGN KEY REFERENCES vsd.ETS1_calendar_dates(service_id),
	trip_id VARCHAR(30) PRIMARY KEY,
	trip_headsign nvarchar(255) NULL,
	direction_id bit NULL, --0 = outbound, 1 = inbound
	block_id  varchar(30) NULL, /* Identifies the block to which the trip belongs. A block consists of two or more sequential trips made using the same vehicle, where a passenger can transfer from one trip to the next just by staying in the vehicle. The block_id must be referenced by two or more trips in trips.txt. */
	shape_id varchar(255) NULL --REFERENCES vsd.ETS1_shapes(shape_id)
)
--DROP TABLE vsd.ETS1_trips_StAlbert
CREATE TABLE vsd.ETS1_trips_StAlbert (
	route_id VARCHAR(20) FOREIGN KEY REFERENCES vsd.ETS1_routes_StAlbert(route_id),
	service_id varchar(255), --FOREIGN KEY REFERENCES vsd.ETS1_calendar_dates(service_id),
	trip_id VARCHAR(30) PRIMARY KEY,
	trip_headsign nvarchar(255) NULL,
	direction_id bit NULL, --0 = outbound, 1 = inbound
	block_id varchar(30) NULL, /* Identifies the block to which the trip belongs. A block consists of two or more sequential trips made using the same vehicle, where a passenger can transfer from one trip to the next just by staying in the vehicle. The block_id must be referenced by two or more trips in trips.txt. */
	shape_id varchar(255) NULL --REFERENCES vsd.ETS1_shapes(shape_id)
)
--DROP TABLE vsd.ETS1_trips_Strathcona
CREATE TABLE vsd.ETS1_trips_Strathcona (
	route_id VARCHAR(20) FOREIGN KEY REFERENCES vsd.ETS1_routes_Strathcona(route_id),
	service_id varchar(255), --FOREIGN KEY REFERENCES vsd.ETS1_calendar_dates(service_id),
	trip_id VARCHAR(30) PRIMARY KEY,
	trip_headsign nvarchar(255) NULL,
	direction_id bit NULL, --0 = outbound, 1 = inbound
	block_id varchar(30) NULL, /* Identifies the block to which the trip belongs. A block consists of two or more sequential trips made using the same vehicle, where a passenger can transfer from one trip to the next just by staying in the vehicle. The block_id must be referenced by two or more trips in trips.txt. */
	shape_id varchar(255) NULL --REFERENCES vsd.ETS1_shapes(shape_id)
)


CREATE INDEX ix_ETS1_trip_id ON vsd.ETS1_trips(trip_id)
CREATE INDEX ix_ETS1_T_service_id ON vsd.ETS1_trips(service_id)

CREATE TABLE vsd.ETS1_transfer_types (
	transfer_type INT PRIMARY KEY,
	transfer_type_name nvarchar(255) NOT NULL,
	transfer_type_desc nvarchar(1024) NULL
)
INSERT INTO vsd.ETS1_transfer_types VALUES(0, 'Recommended', 'This is a recommended transfer point between two routes.')
INSERT INTO vsd.ETS1_transfer_types VALUES(1, 'Timed', ' This is a timed transfer point between two routes. The departing vehicle is expected to wait for the arriving one, with sufficient time for a passenger to transfer between routes.')
INSERT INTO vsd.ETS1_transfer_types VALUES(2, 'Requires Min. Time', 'This transfer requires a minimum amount of time between arrival and departure to ensure a connection. The time required to transfer is specified by min_transfer_time.')
INSERT INTO vsd.ETS1_transfer_types VALUES(3, 'Not Possible', 'Transfers are not possible between routes at this location.')


CREATE TABLE vsd.ETS1_transfers (
	from_stop_id VARCHAR(30) NOT NULL REFERENCES vsd.ETS1_trips(trip_id),
	to_stop_id VARCHAR(30) NOT NULL REFERENCES vsd.ETS1_trips(trip_id),
	transfer_type INT NULL REFERENCES vsd.ETS1_transfer_types(transfer_type),
	min_transfer_time INT NULL, -- value in seconds
	PRIMARY KEY (from_stop_id, to_stop_id)
)

CREATE TABLE vsd.ETS1_transfers_StAlbert (
	from_stop_id VARCHAR(30) NOT NULL REFERENCES vsd.ETS1_trips_StAlbert(trip_id),
	to_stop_id VARCHAR(30) NOT NULL REFERENCES vsd.ETS1_trips_StAlbert(trip_id),
	transfer_type INT NULL REFERENCES vsd.ETS1_transfer_types(transfer_type),
	min_transfer_time INT NULL, -- value in seconds
	PRIMARY KEY (from_stop_id, to_stop_id)
)

CREATE TABLE vsd.ETS1_transfers_Strathcona (
	from_stop_id VARCHAR(30) NOT NULL REFERENCES vsd.ETS1_trips_Strathcona(trip_id),
	to_stop_id VARCHAR(30) NOT NULL REFERENCES vsd.ETS1_trips_Strathcona(trip_id),
	transfer_type INT NULL REFERENCES vsd.ETS1_transfer_types(transfer_type),
	min_transfer_time INT NULL, -- value in seconds
	PRIMARY KEY (from_stop_id, to_stop_id)
)

--WTH is trip_pattern.txt? It doesn't have a header and isn't documented in https://developers.google.com/transit/gtfs/reference/


CREATE TABLE vsd.ETS1_pickup_types (
	pickup_type INT PRIMARY KEY,
	pickup_type_name nvarchar(255) NOT NULL,
	pickup_type_desc nvarchar(1024) NULL
)
INSERT INTO vsd.ETS1_pickup_types VALUES(0, 'Regular', 'Regularly scheduled pickup')
INSERT INTO vsd.ETS1_pickup_types VALUES(1, 'No pickup', 'No pickup available')
INSERT INTO vsd.ETS1_pickup_types VALUES(2, 'Phone', 'Must phone agency to arrange pickup')
INSERT INTO vsd.ETS1_pickup_types VALUES(3, 'Coordinate with Driver', 'Must coordinate with driver to arrange pickup')

CREATE TABLE vsd.ETS1_drop_off_types (
	drop_off_type INT PRIMARY KEY,
	drop_off_type_name nvarchar(255) NOT NULL,
	drop_off_type_desc nvarchar(1024) NULL
)
INSERT INTO vsd.ETS1_drop_off_types VALUES(0, 'Regular', 'Regularly scheduled drop off')
INSERT INTO vsd.ETS1_drop_off_types VALUES(1, 'No drop off', 'No drop off available')
INSERT INTO vsd.ETS1_drop_off_types VALUES(2, 'Phone', 'Must phone agency to arrange drop off')
INSERT INTO vsd.ETS1_drop_off_types VALUES(3, 'Coordinate with Driver', 'Must coordinate with driver to arrange drop off')


--INSERT INTO vsd.ETS1_stops VALUES(1001,1001,'Abbottsfield Transit Centre',NULL,53.571965,-113.390362,NULL,NULL,0,NULL)
--DROP TABLE vsd.ETS1_stop_times
CREATE TABLE vsd.ETS1_stop_times (
	--stimeID INT IDENTITY PRIMARY KEY, --I don't use this so removing it might save me from running out of keys later
	trip_id VARCHAR(30) NOT NULL REFERENCES vsd.ETS1_trips(trip_id),
	arrival_time varchar(8) NOT NULL, ---not used in practice. Can't store as time because they can go over 24:00 (even over 25:00)
	departure_hour int NOT NULL, --The hour and minute will be broken up here so they can be stored as INT for faster sorting
	departure_minute int NOT NULL,
	departure_second int NOT NULL,
	--departure_time varchar(8) NOT NULL, --Removed because this will now be split into hour/minute integers for smaller storage and faster operation
	stop_id INT NOT NULL FOREIGN KEY REFERENCES vsd.ETS1_stops(stop_id),
	stop_sequence int NOT NULL, --integer
	--for proper normalization, stop_sequence really should be another DB table, but since it only seems to ever be one number, that's not so necesssary
	stop_headsign nvarchar(255) NULL,
	pickup_type INT DEFAULT 0 FOREIGN KEY REFERENCES vsd.ETS1_pickup_types(pickup_type),
	drop_off_type INT DEFAULT 0 FOREIGN KEY REFERENCES vsd.ETS1_drop_off_types(drop_off_type),
	shape_dist_traveled FLOAT(8) NULL, --theoretically could be a float, but is only ever int LOOKS LIKE I WAS WRONG ABOUT THIS!
)

CREATE TABLE vsd.ETS1_stop_times_StAlbert (
	--stimeID INT IDENTITY PRIMARY KEY, --I don't use this so removing it might save me from running out of keys later
	trip_id VARCHAR(30) NOT NULL REFERENCES vsd.ETS1_trips_StAlbert(trip_id),
	arrival_time varchar(8) NOT NULL, ---not used in practice. Can't store as time because they can go over 24:00 (even over 25:00)
	departure_hour int NOT NULL, --The hour and minute will be broken up here so they can be stored as INT for faster sorting
	departure_minute int NOT NULL,
	departure_second int NOT NULL,
	--departure_time varchar(8) NOT NULL, --Removed because this will now be split into hour/minute integers for smaller storage and faster operation
	stop_id INT NOT NULL FOREIGN KEY REFERENCES vsd.ETS1_stops_StAlbert(stop_id),
	stop_sequence int NOT NULL, --integer
	--for proper normalization, stop_sequence really should be another DB table, but since it only seems to ever be one number, that's not so necesssary
	stop_headsign nvarchar(255) NULL,
	pickup_type INT DEFAULT 0 FOREIGN KEY REFERENCES vsd.ETS1_pickup_types(pickup_type),
	drop_off_type INT DEFAULT 0 FOREIGN KEY REFERENCES vsd.ETS1_drop_off_types(drop_off_type),
	shape_dist_traveled FLOAT(8) NULL, --theoretically could be a float, but is only ever int LOOKS LIKE I WAS WRONG ABOUT THIS!
)

CREATE TABLE vsd.ETS1_stop_times_Strathcona (
	--stimeID INT IDENTITY PRIMARY KEY, --I don't use this so removing it might save me from running out of keys later
	trip_id VARCHAR(30) NOT NULL REFERENCES vsd.ETS1_trips_Strathcona(trip_id),
	arrival_time varchar(8) NOT NULL, ---not used in practice. Can't store as time because they can go over 24:00 (even over 25:00)
	departure_hour int NOT NULL, --The hour and minute will be broken up here so they can be stored as INT for faster sorting
	departure_minute int NOT NULL,
	departure_second int NOT NULL,
	--departure_time varchar(8) NOT NULL, --Removed because this will now be split into hour/minute integers for smaller storage and faster operation
	stop_id INT NOT NULL FOREIGN KEY REFERENCES vsd.ETS1_stops_Strathcona(stop_id),
	stop_sequence int NOT NULL, --integer
	--for proper normalization, stop_sequence really should be another DB table, but since it only seems to ever be one number, that's not so necesssary
	stop_headsign nvarchar(255) NULL,
	pickup_type INT DEFAULT 0 FOREIGN KEY REFERENCES vsd.ETS1_pickup_types(pickup_type),
	drop_off_type INT DEFAULT 0 FOREIGN KEY REFERENCES vsd.ETS1_drop_off_types(drop_off_type),
	shape_dist_traveled FLOAT(8) NULL, --theoretically could be a float, but is only ever int LOOKS LIKE I WAS WRONG ABOUT THIS!
)

--Table that allows quickly sorting nearby stops. This gets recreated every time the update is done.
CREATE TABLE vsd.ETS1_stop_routes_all_agencies (
stop_id INT NOT NULL,
route_id varchar(20) NOT NULL,
agency_id INT NOT NULL, 
PRIMARY KEY (stop_id, route_id, agency_id)
)

--Create some indicies on stop_times to improve certain operations
--DROP INDEX ix_ETS1_departure_hour ON vsd.ETS1_stop_times
--DROP INDEX ix_ETS1_departure_minute ON vsd.ETS1_stop_times
--DROP INDEX ix_ETS1_stop_id ON vsd.ETS1_stop_times
--DROP INDEX ix_ETS1_stop_sequence ON vsd.ETS1_stop_times
--DROP INDEX ix_ETS1_STIME_trip_id ON vsd.ETS1_stop_times
--DROP INDEX ix_ETS1_STIME_stop_id_trip_id ON vsd.ETS1_stop_times
-- For some reason these indexes seem to be slowing things down way more than helping.
--CREATE INDEX ix_ETS1_departure_hour ON vsd.ETS1_stop_times(departure_hour)
--CREATE INDEX ix_ETS1_departure_minute ON vsd.ETS1_stop_times(departure_minute)
--CREATE INDEX ix_ETS1_stop_id ON vsd.ETS1_stop_times(stop_id)
--CREATE INDEX ix_ETS1_stop_sequence ON vsd.ETS1_stop_times(stop_sequence)
--CREATE INDEX ix_ETS1_STIME_trip_id ON vsd.ETS1_stop_times(trip_id)
-- This index helps a lot, slows down imports by several seconds
--CREATE NONCLUSTERED INDEX ix_ETS1_STIME_stop_id_trip_id ON vsd.ETS1_stop_times (stop_id) INCLUDE (trip_id)

--This index gives me a 5x improvement
CREATE NONCLUSTERED INDEX ix_ETS1_STIME_trip_id_stop_id_stop_sequence ON [vsd].[ETS1_stop_times] ([trip_id],[stop_id],[stop_sequence])
--This index also speeds up the query a fair bit more
CREATE NONCLUSTERED INDEX ix_ETS1_stop_id ON [vsd].[ETS1_stop_times] ([stop_id]) INCLUDE ([trip_id])
--The benefits of this one seem insignificant
--CREATE NONCLUSTERED INDEX ix_ETS1_stopId_pickup_type ON [vsd].[ETS_stop_times] ([stop_id],[pickup_type]) INCLUDE ([trip_id],[arrival_time],[departure_hour],[departure_minute],[stop_sequence],[stop_headsign],[drop_off_type],[shape_dist_traveled])
CREATE NONCLUSTERED INDEX ix_ETS1_trip_id_stop_id_stop_sequence ON [vsd].[ETS1_stop_times] ([trip_id],[stop_id],[stop_sequence])


CREATE NONCLUSTERED INDEX ix_ETS1_STIME_trip_id_stop_id_stop_sequence_SA ON [vsd].[ETS1_stop_times_StAlbert] ([trip_id],[stop_id],[stop_sequence])
--This index also speeds up the query a fair bit more
CREATE NONCLUSTERED INDEX ix_ETS1_stop_id_SA ON [vsd].[ETS1_stop_times_StAlbert] ([stop_id]) INCLUDE ([trip_id])
--The benefits of this one seem insignificant
--CREATE NONCLUSTERED INDEX ix_ETS1_stopId_pickup_type ON [vsd].[ETS_stop_times] ([stop_id],[pickup_type]) INCLUDE ([trip_id],[arrival_time],[departure_hour],[departure_minute],[stop_sequence],[stop_headsign],[drop_off_type],[shape_dist_traveled])
CREATE NONCLUSTERED INDEX ix_ETS1_trip_id_stop_id_stop_sequence_SA ON [vsd].[ETS1_stop_times_StAlbert] ([trip_id],[stop_id],[stop_sequence])


CREATE NONCLUSTERED INDEX ix_ETS1_STIME_trip_id_stop_id_stop_sequence_SC ON [vsd].[ETS1_stop_times_Strathcona] ([trip_id],[stop_id],[stop_sequence])
--This index also speeds up the query a fair bit more
CREATE NONCLUSTERED INDEX ix_ETS1_stop_id_SC ON [vsd].[ETS1_stop_times_Strathcona] ([stop_id]) INCLUDE ([trip_id])
--The benefits of this one seem insignificant
--CREATE NONCLUSTERED INDEX ix_ETS1_stopId_pickup_type ON [vsd].[ETS_stop_times] ([stop_id],[pickup_type]) INCLUDE ([trip_id],[arrival_time],[departure_hour],[departure_minute],[stop_sequence],[stop_headsign],[drop_off_type],[shape_dist_traveled])
CREATE NONCLUSTERED INDEX ix_ETS1_trip_id_stop_id_stop_sequence_SC ON [vsd].[ETS1_stop_times_Strathcona] ([trip_id],[stop_id],[stop_sequence])


--View containing all agencies with my hardcoded agency IDs
CREATE VIEW vsd.ETS1_agency_all_agencies WITH SCHEMABINDING AS
SELECT 1 AS agency_id, agency_name, agency_url, agency_timezone, agency_lang, agency_phone FROM vsd.ETS1_agency
UNION
SELECT 2 AS agency_id, agency_name, agency_url, agency_timezone, agency_lang, agency_phone FROM vsd.ETS1_agency_StAlbert
UNION
SELECT 3 AS agency_id, agency_name, agency_url, agency_timezone, agency_lang, agency_phone FROM vsd.ETS1_agency_Strathcona

CREATE VIEW vsd.ETS1_routes_all_agencies WITH SCHEMABINDING AS
SELECT route_id, route_short_name, route_long_name, route_desc, route_type, route_url, route_color, route_text_color, 1 AS agency_id
FROM vsd.ETS1_routes UNION
SELECT route_id, route_short_name, route_long_name, route_desc, route_type, route_url, route_color, route_text_color, 2 AS agency_id
FROM vsd.ETS1_routes_StAlbert UNION
SELECT route_id, route_short_name, route_long_name, route_desc, route_type, route_url, route_color, route_text_color, 3 AS agency_id
FROM vsd.ETS1_routes_Strathcona

--DROP VIEW vsd.ETS1_trip_stop_datetimes
-- Creates a very useful view from the stop_times
CREATE VIEW vsd.ETS1_trip_stop_datetimes WITH SCHEMABINDING AS
SELECT --TOP 10000
CASE WHEN departure_hour > 23 THEN
CONVERT(datetime, DATEADD(d, 1, date), 121)+CONVERT(datetime, CAST(departure_hour%24 AS varchar)+':'+CAST(departure_minute AS varchar), 121)
ELSE
CONVERT(datetime, date, 121)+CONVERT(datetime, CAST(departure_hour AS varchar)+':'+CAST(departure_minute AS varchar), 121)
END --CASE
AS ActualDateTime,
stime.trip_id, stime.arrival_time, stime.departure_hour, stime.departure_minute,stop_id, stime.stop_sequence, stime.stop_headsign, stime.pickup_type, stime.drop_off_type,
stime.shape_dist_traveled, t.route_id, t.service_id, t.trip_headsign, t.direction_id, t.block_id, t.shape_id, c.date, c.exception_type
FROM vsd.ETS1_stop_times stime
JOIN vsd.ETS1_trips t ON stime.trip_id=t.trip_id
JOIN vsd.ETS1_calendar_dates c ON c.service_id=t.service_id


CREATE VIEW vsd.ETS1_trip_stop_datetimes_StAlbert WITH SCHEMABINDING AS
SELECT --TOP 10000
CASE WHEN departure_hour > 23 THEN
CONVERT(datetime, DATEADD(d, 1, date), 121)+CONVERT(datetime, CAST(departure_hour%24 AS varchar)+':'+CAST(departure_minute AS varchar), 121)
ELSE
CONVERT(datetime, date, 121)+CONVERT(datetime, CAST(departure_hour AS varchar)+':'+CAST(departure_minute AS varchar), 121)
END --CASE
AS ActualDateTime,
stime.trip_id, stime.arrival_time, stime.departure_hour, stime.departure_minute,stop_id, stime.stop_sequence, stime.stop_headsign, stime.pickup_type, stime.drop_off_type,
stime.shape_dist_traveled, t.route_id, t.service_id, t.trip_headsign, t.direction_id, t.block_id, t.shape_id, c.date, c.exception_type
FROM vsd.ETS1_stop_times_StAlbert stime
JOIN vsd.ETS1_trips_StAlbert t ON stime.trip_id=t.trip_id
JOIN vsd.ETS1_calendar_dates_complete_StAlbert c ON c.service_id=t.service_id


CREATE VIEW vsd.ETS1_trip_stop_datetimes_Strathcona WITH SCHEMABINDING AS
SELECT --TOP 10000
CASE WHEN departure_hour > 23 THEN
CONVERT(datetime, DATEADD(d, 1, date), 121)+CONVERT(datetime, CAST(departure_hour%24 AS varchar)+':'+CAST(departure_minute AS varchar), 121)
ELSE
CONVERT(datetime, date, 121)+CONVERT(datetime, CAST(departure_hour AS varchar)+':'+CAST(departure_minute AS varchar), 121)
END --CASE
AS ActualDateTime,
stime.trip_id, stime.arrival_time, stime.departure_hour, stime.departure_minute,stop_id, stime.stop_sequence, stime.stop_headsign, stime.pickup_type, stime.drop_off_type,
stime.shape_dist_traveled, t.route_id, t.service_id, t.trip_headsign, t.direction_id, t.block_id, t.shape_id, c.date, c.exception_type
FROM vsd.ETS1_stop_times_Strathcona stime
JOIN vsd.ETS1_trips_Strathcona t ON stime.trip_id=t.trip_id
JOIN vsd.ETS1_calendar_dates_complete_Strathcona c ON c.service_id=t.service_id


--This view adds a unique id based on the zone_id to create a unique identifier
--St. Albert starts with StA, Strathcona Str, Edmonton are just the regular ID
CREATE VIEW vsd.ETS1_stops_all_agencies_unique WITH SCHEMABINDING AS
SELECT CONCAT(left(REPLACE(zone_id, '. ', ''), 3), stop_id) AS astop_id,
stop_id, stop_code, stop_name, stop_desc, stop_lat, stop_lon, zone_id, stop_url, location_type, parent_station, is_lrt, exclusive
FROM (SELECT stop_id, stop_code, stop_name, stop_desc, stop_lat, stop_lon, zone_id, stop_url, location_type, parent_station, is_lrt, exclusive FROM vsd.ETS1_stops
UNION SELECT stop_id, stop_code, stop_name, stop_desc, stop_lat, stop_lon, zone_id, stop_url, location_type, parent_station, is_lrt, exclusive FROM vsd.ETS1_stops_StAlbert
UNION SELECT stop_id, stop_code, stop_name, stop_desc, stop_lat, stop_lon, zone_id, stop_url, location_type, parent_station, is_lrt, exclusive FROM vsd.ETS1_stops_Strathcona)
AS allstops WHERE exclusive=1

CREATE VIEW vsd.ETS1_stops_all_agencies WITH SCHEMABINDING AS
SELECT stop_id, stop_code, stop_name, stop_desc, stop_lat, stop_lon, zone_id, stop_url, location_type, parent_station, is_lrt, 1 AS agency_id FROM vsd.ETS1_stops
UNION SELECT stop_id, stop_code, stop_name, stop_desc, stop_lat, stop_lon, zone_id, stop_url, location_type, parent_station, is_lrt, 2 AS agency_id FROM vsd.ETS1_stops_StAlbert
UNION SELECT stop_id, stop_code, stop_name, stop_desc, stop_lat, stop_lon, zone_id, stop_url, location_type, parent_station, is_lrt, 3 AS agency_id FROM vsd.ETS1_stops_Strathcona


--Create a view of all trips
CREATE VIEW vsd.ETS1_trips_all_agencies WITH SCHEMABINDING AS
SELECT route_id, service_id, trip_id, trip_headsign, direction_id, block_id, shape_id, 1 AS agency_id
FROM vsd.ETS1_trips
UNION SELECT route_id, service_id, trip_id, trip_headsign, direction_id, block_id, shape_id, 2 AS agency_id
FROM vsd.ETS1_trips_StAlbert
UNION SELECT route_id, service_id, trip_id, trip_headsign, direction_id, block_id, shape_id, 3 AS agency_id
FROM vsd.ETS1_trips_Strathcona

--View of all shapes
CREATE VIEW vsd.ETS1_shapes_all_agencies WITH SCHEMABINDING AS
SELECT shape_id, shape_pt_lat, shape_pt_lon, shape_pt_sequence, 1 AS agency_id FROM vsd.ETS1_shapes
UNION SELECT shape_id, shape_pt_lat, shape_pt_lon, shape_pt_sequence, 2 AS agency_id FROM vsd.ETS1_shapes_StAlbert
UNION SELECT shape_id, shape_pt_lat, shape_pt_lon, shape_pt_sequence, 3 AS agency_id  FROM vsd.ETS1_shapes_Strathcona

--DROP VIEW vsd.ETS1_stop_times_all_agencies
CREATE VIEW vsd.ETS1_stop_times_all_agencies WITH SCHEMABINDING AS
SELECT trip_id, arrival_time, departure_hour, departure_minute, departure_second, stop_id, stop_sequence, stop_headsign, pickup_type, drop_off_type, shape_dist_traveled, 1 AS agency_id
FROM vsd.ETS1_stop_times UNION
SELECT trip_id, arrival_time, departure_hour, departure_minute, departure_second, stop_id, stop_sequence, stop_headsign, pickup_type, drop_off_type, shape_dist_traveled, 2 AS agency_id
FROM vsd.ETS1_stop_times_StAlbert UNION
SELECT trip_id, arrival_time, departure_hour, departure_minute, departure_second, stop_id, stop_sequence, stop_headsign, pickup_type, drop_off_type, shape_dist_traveled, 3 AS agency_id
FROM vsd.ETS2_stop_times_Strathcona


--The big kahuna
CREATE VIEW vsd.ETS1_trip_stop_datetimes_all_agencies WITH SCHEMABINDING AS
SELECT
1 AS agency_id, ActualDateTime, trip_id, arrival_time, departure_hour, departure_minute, stop_id, stop_headsign, pickup_type, drop_off_type, shape_dist_traveled, route_id, service_id, trip_headsign, direction_id, block_id, shape_id, date, exception_type
FROM vsd.ETS1_trip_stop_datetimes
UNION SELECT
2 AS agency_id, ActualDateTime, trip_id, arrival_time, departure_hour, departure_minute, stop_id, stop_headsign, pickup_type, drop_off_type, shape_dist_traveled, route_id, service_id, trip_headsign, direction_id, block_id, shape_id, date, exception_type
FROM vsd.ETS1_trip_stop_datetimes_Strathcona
UNION SELECT
3 AS agency_id, ActualDateTime, trip_id, arrival_time, departure_hour, departure_minute, stop_id, stop_headsign, pickup_type, drop_off_type, shape_dist_traveled, route_id, service_id, trip_headsign, direction_id, block_id, shape_id, date, exception_type
FROM vsd.ETS1_trip_stop_datetimes_StAlbert


/************************************************************************
*
*  The ETS2 database is an alternate database so that the production and
*  import databases can be separated to avoid a catastrophic failure.
*
*************************************************************************/



DROP VIEW vsd.ETS2_trip_stop_datetimes_all_agencies
DROP VIEW vsd.ETS2_trip_stop_datetimes
DROP VIEW vsd.ETS2_trip_stop_datetimes_StAlbert
DROP VIEW vsd.ETS2_trip_stop_datetimes_Strathcona
DROP TABLE vsd.ETS2_stop_times
DROP TABLE vsd.ETS2_stop_times_StAlbert
DROP TABLE vsd.ETS2_stop_times_Strathcona
DROP TABLE vsd.ETS2_drop_off_types
DROP TABLE vsd.ETS2_pickup_types
DROP TABLE vsd.ETS2_transfers
DROP TABLE vsd.ETS2_transfers_StAlbert
DROP TABLE vsd.ETS2_transfers_Strathcona
DROP TABLE vsd.ETS2_transfer_types
DROP TABLE vsd.ETS2_trips
DROP TABLE vsd.ETS2_trips_StAlbert
DROP TABLE vsd.ETS2_trips_Strathcona
DROP TABLE vsd.ETS2_stops
DROP TABLE vsd.ETS2_stops_StAlbert
DROP TABLE vsd.ETS2_stops_Strathcona
DROP TABLE vsd.ETS2_shapes
DROP TABLE vsd.ETS2_shapes_StAlbert
DROP TABLE vsd.ETS2_shapes_Strathcona
DROP TABLE vsd.ETS2_routes
DROP TABLE vsd.ETS2_routes_StAlbert
DROP TABLE vsd.ETS2_routes_Strathcona
DROP TABLE vsd.ETS2_route_types
DROP TABLE vsd.ETS2_calendar_dates
DROP TABLE vsd.ETS2_calendar_dates_StAlbert
DROP TABLE vsd.ETS2_calendar_dates_Strathcona
DROP TABLE vsd.ETS2_agency
DROP TABLE vsd.ETS2_agency_StAlbert
DROP TABLE vsd.ETS2_agency_Strathcona

CREATE TABLE vsd.ETS2_agency (
	aID INT NOT NULL IDENTITY PRIMARY KEY,
	agency_name nvarchar(255) NOT NULL,
	agency_url nvarchar(1024) NOT NULL,
	agency_timezone nvarchar(255) NOT NULL,
	agency_lang varchar(5) NOT NULL,
	agency_phone varchar(16) NULL
)

CREATE TABLE vsd.ETS2_agency_StAlbert (
	aID INT NOT NULL IDENTITY PRIMARY KEY,
	agency_name nvarchar(255) NOT NULL,
	agency_url nvarchar(1024) NOT NULL,
	agency_timezone nvarchar(255) NOT NULL,
	agency_lang varchar(5) NOT NULL,
	agency_phone varchar(16) NULL
)

CREATE TABLE vsd.ETS2_agency_Strathcona (
	aID INT NOT NULL IDENTITY PRIMARY KEY,
	agency_name nvarchar(255) NOT NULL,
	agency_url nvarchar(1024) NOT NULL,
	agency_timezone nvarchar(255) NOT NULL,
	agency_lang varchar(5) NOT NULL,
	agency_phone varchar(16) NULL
)

CREATE TABLE vsd.ETS2_calendar (
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

CREATE TABLE vsd.ETS2_calendar_StAlbert (
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

CREATE TABLE vsd.ETS2_calendar_Strathcona (
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


CREATE TABLE vsd.ETS2_calendar_dates (
	cdID INT NOT NULL IDENTITY PRIMARY KEY,
	service_id varchar(255) NOT NULL,
	date DATE NOT NULL,
	exception_type INT NOT NULL,
	UNIQUE(service_id,date)
)

CREATE TABLE vsd.ETS2_calendar_dates_StAlbert (
	cdID INT NOT NULL IDENTITY PRIMARY KEY,
	service_id varchar(255) NOT NULL,
	date DATE NOT NULL,
	exception_type INT NOT NULL,
	UNIQUE(service_id,date)
)

CREATE TABLE vsd.ETS2_calendar_dates_Strathcona (
	cdID INT NOT NULL IDENTITY PRIMARY KEY,
	service_id varchar(255) NOT NULL,
	date DATE NOT NULL,
	exception_type INT NOT NULL,
	UNIQUE(service_id,date)
)

CREATE TABLE vsd.ETS2_calendar_dates_complete_StAlbert (
	cdcID INT NOT NULL IDENTITY PRIMARY KEY,
	service_id varchar(255) NOT NULL,
	date DATE NOT NULL,
	exception_type INT NOT NULL,
	UNIQUE(service_id,date)
)

CREATE TABLE vsd.ETS2_calendar_dates_complete_Strathcona (
	cdcID INT NOT NULL IDENTITY PRIMARY KEY,
	service_id varchar(255) NOT NULL,
	date DATE NOT NULL,
	exception_type INT NOT NULL,
	UNIQUE(service_id,date)
)

CREATE INDEX ix_ETS2_C_service_id ON vsd.ETS2_calendar_dates(service_id)
CREATE INDEX ix_ETS2_C_date ON vsd.ETS2_calendar_dates(date)

CREATE INDEX ix_ETS2_C_service_id_SA ON vsd.ETS2_calendar_dates_StAlbert(service_id)
CREATE INDEX ix_ETS2_C_date_SA ON vsd.ETS2_calendar_dates_StAlbert(date)

CREATE INDEX ix_ETS2_C_service_id_SC ON vsd.ETS2_calendar_dates_Strathcona(service_id)
CREATE INDEX ix_ETS2_C_date_SC ON vsd.ETS2_calendar_dates_Strathcona(date)

CREATE INDEX ix_ETS2_CC_service_id_SA ON vsd.ETS2_calendar_dates_complete_StAlbert(service_id)
CREATE INDEX ix_ETS2_CC_date_SA ON vsd.ETS2_calendar_dates_complete_StAlbert(date)

CREATE INDEX ix_ETS2_CC_service_id_SC ON vsd.ETS2_calendar_dates_complete_Strathcona(service_id)
CREATE INDEX ix_ETS2_CC_date_SC ON vsd.ETS2_calendar_dates_complete_Strathcona(date)

--INSERT INTO vsd.ETS2_calendar_dates VALUES('1-Saturday-1-JUN17-0000010',	'20170715',	1)
--SELECT * FROM vsd.ETS2_calendar_dates

--
CREATE TABLE vsd.ETS2_route_types (
	route_type INT PRIMARY KEY,
	route_type_name nvarchar(255) NOT NULL,
	route_type_desc nvarchar(1024) NULL
)

INSERT INTO vsd.ETS2_route_types VALUES(0, 'Tram, Streetcar, Light Rail', 'Any light rail or street level system within a metropolitan area.')
INSERT INTO vsd.ETS2_route_types VALUES(1, 'Subway, Metro', 'Any underground rail system within a metropolitan area.')
INSERT INTO vsd.ETS2_route_types VALUES(2, 'Rail', 'Used for intercity or long-distance travel.')
INSERT INTO vsd.ETS2_route_types VALUES(3, 'Bus', 'Used for short- and long-distance bus routes.')
INSERT INTO vsd.ETS2_route_types VALUES(4, 'Ferry', 'Used for short- and long-distance boat service.')
INSERT INTO vsd.ETS2_route_types VALUES(5, 'Cable Car', 'Used for street-level cable cars where the cable runs beneath the car.')
INSERT INTO vsd.ETS2_route_types VALUES(6, 'Gondola, Suspended cable car.', 'Typically used for aerial cable cars where the car is suspended from the cable.')
INSERT INTO vsd.ETS2_route_types VALUES(7, 'Funicular', 'Any rail system designed for steep inclines.')

--DELETE FROM vsd.ETS2_routes
--DROP TABLE vsd.ETS2_routes
--2018-06-11 - updated route_id to be varchar to allow for Strathcona & St. Albert's format.
-- I'm concerned about the performance ramifications of this.
CREATE TABLE vsd.ETS2_routes (
	route_id VARCHAR(20) PRIMARY KEY,
	route_short_name nvarchar(511) NOT NULL,
	route_long_name nvarchar(1023) NOT NULL,
	route_desc nvarchar(1023) NULL,
	route_type INT NOT NULL FOREIGN KEY REFERENCES vsd.ETS2_route_types(route_type),
	route_url nvarchar(1023) NULL,
	route_color varchar(20),
	route_text_color varchar(20)
	--UNIQUE(route_id)
)

CREATE TABLE vsd.ETS2_routes_StAlbert (
	route_id VARCHAR(20) PRIMARY KEY,
	route_short_name nvarchar(511) NOT NULL,
	route_long_name nvarchar(1023) NOT NULL,
	route_desc nvarchar(1023) NULL,
	route_type INT NOT NULL FOREIGN KEY REFERENCES vsd.ETS2_route_types(route_type),
	route_url nvarchar(1023) NULL,
	route_color varchar(20),
	route_text_color varchar(20)
	--UNIQUE(route_id)
)

CREATE TABLE vsd.ETS2_routes_Strathcona (
	route_id VARCHAR(20) PRIMARY KEY,
	route_short_name nvarchar(511) NOT NULL,
	route_long_name nvarchar(1023) NOT NULL,
	route_desc nvarchar(1023) NULL,
	route_type INT NOT NULL FOREIGN KEY REFERENCES vsd.ETS2_route_types(route_type),
	route_url nvarchar(1023) NULL,
	route_color varchar(20),
	route_text_color varchar(20)
	--UNIQUE(route_id)
)

SELECT * FROM vsd.ETS2_routes
--INSERT INTO vsd.ETS2_routes VALUES(1,1,'West Edmonton Mall - Downtown - Capilano',NULL,3,NULL)

CREATE TABLE vsd.ETS2_shapes (
	shape_id varchar(255),
	shape_pt_lat float(8) NOT NULL,
	shape_pt_lon float(8) NOT NULL,
	shape_pt_sequence INT NOT NULL,
	PRIMARY KEY (shape_id, shape_pt_sequence)
)

CREATE TABLE vsd.ETS2_shapes_StAlbert (
	shape_id varchar(255),
	shape_pt_lat float(8) NOT NULL,
	shape_pt_lon float(8) NOT NULL,
	shape_pt_sequence INT NOT NULL,
	PRIMARY KEY (shape_id, shape_pt_sequence)
)

CREATE TABLE vsd.ETS2_shapes_Strathcona (
	shape_id varchar(255),
	shape_pt_lat float(8) NOT NULL,
	shape_pt_lon float(8) NOT NULL,
	shape_pt_sequence INT NOT NULL,
	PRIMARY KEY (shape_id, shape_pt_sequence)
)

--INSERT INTO vsd.ETS2_shapes VALUES('1-89-1',53.53864,-113.42325,1)
CREATE TABLE vsd.ETS2_stops (
	stop_id INT PRIMARY KEY,
	stop_code INT NULL,
	stop_name nvarchar(512) NOT NULL,
	stop_desc nvarchar(1023) NULL,
	stop_lat float(8) NOT NULL,
	stop_lon float(8) NOT NULL,
	zone_id varchar(30) NULL,
	stop_url nvarchar(1023) NULL,
	location_type bit NULL, --0/blank = stop, 1 = Station
	parent_station INT NULL,
	is_lrt bit NULL, --optional field added after import by my own code for simplicity
	exclusive bit NULL --can specify that this stop is not used by other agencies
)

--Experimental tables for other transit agencies
--DROP TABLE vsd.ETS2_stops_StAlbert
CREATE TABLE vsd.ETS2_stops_StAlbert (
	stop_id INT PRIMARY KEY,
	stop_code INT NULL,
	stop_name nvarchar(512) NOT NULL,
	stop_desc nvarchar(1023) NULL,
	stop_lat float(8) NOT NULL,
	stop_lon float(8) NOT NULL,
	zone_id varchar(30) NULL,
	stop_url nvarchar(1023) NULL,
	location_type bit NULL, --0/blank = stop, 1 = Station
	parent_station INT NULL,
	is_lrt bit NULL, --optional field added after import by my own code for simplicity
	exclusive bit NULL --can specify that this stop is not used by other agencies
)

--DROP TABLE vsd.ETS2_stops_Strathcona
CREATE TABLE vsd.ETS2_stops_Strathcona (
	stop_id INT PRIMARY KEY,
	stop_code INT NULL,
	stop_name nvarchar(512) NOT NULL,
	stop_desc nvarchar(1023) NULL,
	stop_lat float(8) NOT NULL,
	stop_lon float(8) NOT NULL,
	zone_id varchar(30) NULL,
	stop_url nvarchar(1023) NULL,
	location_type bit NULL, --0/blank = stop, 1 = Station
	parent_station INT NULL,
	is_lrt bit NULL, --optional field added after import by my own code for simplicity
	exclusive bit NULL --can specify that this stop is not used by other agencies
)

CREATE TABLE vsd.ETS2_trips (
	route_id VARCHAR(20) FOREIGN KEY REFERENCES vsd.ETS2_routes(route_id),
	service_id varchar(255), --FOREIGN KEY REFERENCES vsd.ETS2_calendar_dates(service_id),
	trip_id VARCHAR(30) PRIMARY KEY,
	trip_headsign nvarchar(255) NULL,
	direction_id bit NULL, --0 = outbound, 1 = inbound
	block_id  varchar(30) NULL, /* Identifies the block to which the trip belongs. A block consists of two or more sequential trips made using the same vehicle, where a passenger can transfer from one trip to the next just by staying in the vehicle. The block_id must be referenced by two or more trips in trips.txt. */
	shape_id varchar(255) NULL --REFERENCES vsd.ETS2_shapes(shape_id)
)
--DROP TABLE vsd.ETS2_trips_StAlbert
CREATE TABLE vsd.ETS2_trips_StAlbert (
	route_id VARCHAR(20) FOREIGN KEY REFERENCES vsd.ETS2_routes_StAlbert(route_id),
	service_id varchar(255), --FOREIGN KEY REFERENCES vsd.ETS2_calendar_dates(service_id),
	trip_id VARCHAR(30) PRIMARY KEY,
	trip_headsign nvarchar(255) NULL,
	direction_id bit NULL, --0 = outbound, 1 = inbound
	block_id varchar(30) NULL, /* Identifies the block to which the trip belongs. A block consists of two or more sequential trips made using the same vehicle, where a passenger can transfer from one trip to the next just by staying in the vehicle. The block_id must be referenced by two or more trips in trips.txt. */
	shape_id varchar(255) NULL --REFERENCES vsd.ETS2_shapes(shape_id)
)
--DROP TABLE vsd.ETS2_trips_Strathcona
CREATE TABLE vsd.ETS2_trips_Strathcona (
	route_id VARCHAR(20) FOREIGN KEY REFERENCES vsd.ETS2_routes_Strathcona(route_id),
	service_id varchar(255), --FOREIGN KEY REFERENCES vsd.ETS2_calendar_dates(service_id),
	trip_id VARCHAR(30) PRIMARY KEY,
	trip_headsign nvarchar(255) NULL,
	direction_id bit NULL, --0 = outbound, 1 = inbound
	block_id varchar(30) NULL, /* Identifies the block to which the trip belongs. A block consists of two or more sequential trips made using the same vehicle, where a passenger can transfer from one trip to the next just by staying in the vehicle. The block_id must be referenced by two or more trips in trips.txt. */
	shape_id varchar(255) NULL --REFERENCES vsd.ETS2_shapes(shape_id)
)


CREATE INDEX ix_ETS2_trip_id ON vsd.ETS2_trips(trip_id)
CREATE INDEX ix_ETS2_T_service_id ON vsd.ETS2_trips(service_id)

CREATE TABLE vsd.ETS2_transfer_types (
	transfer_type INT PRIMARY KEY,
	transfer_type_name nvarchar(255) NOT NULL,
	transfer_type_desc nvarchar(1024) NULL
)
INSERT INTO vsd.ETS2_transfer_types VALUES(0, 'Recommended', 'This is a recommended transfer point between two routes.')
INSERT INTO vsd.ETS2_transfer_types VALUES(1, 'Timed', ' This is a timed transfer point between two routes. The departing vehicle is expected to wait for the arriving one, with sufficient time for a passenger to transfer between routes.')
INSERT INTO vsd.ETS2_transfer_types VALUES(2, 'Requires Min. Time', 'This transfer requires a minimum amount of time between arrival and departure to ensure a connection. The time required to transfer is specified by min_transfer_time.')
INSERT INTO vsd.ETS2_transfer_types VALUES(3, 'Not Possible', 'Transfers are not possible between routes at this location.')


CREATE TABLE vsd.ETS2_transfers (
	from_stop_id VARCHAR(30) NOT NULL REFERENCES vsd.ETS2_trips(trip_id),
	to_stop_id VARCHAR(30) NOT NULL REFERENCES vsd.ETS2_trips(trip_id),
	transfer_type INT NULL REFERENCES vsd.ETS2_transfer_types(transfer_type),
	min_transfer_time INT NULL, -- value in seconds
	PRIMARY KEY (from_stop_id, to_stop_id)
)

CREATE TABLE vsd.ETS2_transfers_StAlbert (
	from_stop_id VARCHAR(30) NOT NULL REFERENCES vsd.ETS2_trips_StAlbert(trip_id),
	to_stop_id VARCHAR(30) NOT NULL REFERENCES vsd.ETS2_trips_StAlbert(trip_id),
	transfer_type INT NULL REFERENCES vsd.ETS2_transfer_types(transfer_type),
	min_transfer_time INT NULL, -- value in seconds
	PRIMARY KEY (from_stop_id, to_stop_id)
)

CREATE TABLE vsd.ETS2_transfers_Strathcona (
	from_stop_id VARCHAR(30) NOT NULL REFERENCES vsd.ETS2_trips_Strathcona(trip_id),
	to_stop_id VARCHAR(30) NOT NULL REFERENCES vsd.ETS2_trips_Strathcona(trip_id),
	transfer_type INT NULL REFERENCES vsd.ETS2_transfer_types(transfer_type),
	min_transfer_time INT NULL, -- value in seconds
	PRIMARY KEY (from_stop_id, to_stop_id)
)

--WTH is trip_pattern.txt? It doesn't have a header and isn't documented in https://developers.google.com/transit/gtfs/reference/


CREATE TABLE vsd.ETS2_pickup_types (
	pickup_type INT PRIMARY KEY,
	pickup_type_name nvarchar(255) NOT NULL,
	pickup_type_desc nvarchar(1024) NULL
)
INSERT INTO vsd.ETS2_pickup_types VALUES(0, 'Regular', 'Regularly scheduled pickup')
INSERT INTO vsd.ETS2_pickup_types VALUES(1, 'No pickup', 'No pickup available')
INSERT INTO vsd.ETS2_pickup_types VALUES(2, 'Phone', 'Must phone agency to arrange pickup')
INSERT INTO vsd.ETS2_pickup_types VALUES(3, 'Coordinate with Driver', 'Must coordinate with driver to arrange pickup')

CREATE TABLE vsd.ETS2_drop_off_types (
	drop_off_type INT PRIMARY KEY,
	drop_off_type_name nvarchar(255) NOT NULL,
	drop_off_type_desc nvarchar(1024) NULL
)
INSERT INTO vsd.ETS2_drop_off_types VALUES(0, 'Regular', 'Regularly scheduled drop off')
INSERT INTO vsd.ETS2_drop_off_types VALUES(1, 'No drop off', 'No drop off available')
INSERT INTO vsd.ETS2_drop_off_types VALUES(2, 'Phone', 'Must phone agency to arrange drop off')
INSERT INTO vsd.ETS2_drop_off_types VALUES(3, 'Coordinate with Driver', 'Must coordinate with driver to arrange drop off')


--INSERT INTO vsd.ETS2_stops VALUES(1001,1001,'Abbottsfield Transit Centre',NULL,53.571965,-113.390362,NULL,NULL,0,NULL)
--DROP TABLE vsd.ETS2_stop_times
CREATE TABLE vsd.ETS2_stop_times (
	--stimeID INT IDENTITY PRIMARY KEY, --I don't use this so removing it might save me from running out of keys later
	trip_id VARCHAR(30) NOT NULL REFERENCES vsd.ETS2_trips(trip_id),
	arrival_time varchar(8) NOT NULL, ---not used in practice. Can't store as time because they can go over 24:00 (even over 25:00)
	departure_hour int NOT NULL, --The hour and minute will be broken up here so they can be stored as INT for faster sorting
	departure_minute int NOT NULL,
	departure_second int NOT NULL,
	--departure_time varchar(8) NOT NULL, --Removed because this will now be split into hour/minute integers for smaller storage and faster operation
	stop_id INT NOT NULL FOREIGN KEY REFERENCES vsd.ETS2_stops(stop_id),
	stop_sequence int NOT NULL, --integer
	--for proper normalization, stop_sequence really should be another DB table, but since it only seems to ever be one number, that's not so necesssary
	stop_headsign nvarchar(255) NULL,
	pickup_type INT DEFAULT 0 FOREIGN KEY REFERENCES vsd.ETS2_pickup_types(pickup_type),
	drop_off_type INT DEFAULT 0 FOREIGN KEY REFERENCES vsd.ETS2_drop_off_types(drop_off_type),
	shape_dist_traveled FLOAT(8) NULL, --theoretically could be a float, but is only ever int LOOKS LIKE I WAS WRONG ABOUT THIS!
)

CREATE TABLE vsd.ETS2_stop_times_StAlbert (
	--stimeID INT IDENTITY PRIMARY KEY, --I don't use this so removing it might save me from running out of keys later
	trip_id VARCHAR(30) NOT NULL REFERENCES vsd.ETS2_trips_StAlbert(trip_id),
	arrival_time varchar(8) NOT NULL, ---not used in practice. Can't store as time because they can go over 24:00 (even over 25:00)
	departure_hour int NOT NULL, --The hour and minute will be broken up here so they can be stored as INT for faster sorting
	departure_minute int NOT NULL,
	departure_second int NOT NULL,
	--departure_time varchar(8) NOT NULL, --Removed because this will now be split into hour/minute integers for smaller storage and faster operation
	stop_id INT NOT NULL FOREIGN KEY REFERENCES vsd.ETS2_stops_StAlbert(stop_id),
	stop_sequence int NOT NULL, --integer
	--for proper normalization, stop_sequence really should be another DB table, but since it only seems to ever be one number, that's not so necesssary
	stop_headsign nvarchar(255) NULL,
	pickup_type INT DEFAULT 0 FOREIGN KEY REFERENCES vsd.ETS2_pickup_types(pickup_type),
	drop_off_type INT DEFAULT 0 FOREIGN KEY REFERENCES vsd.ETS2_drop_off_types(drop_off_type),
	shape_dist_traveled FLOAT(8) NULL, --theoretically could be a float, but is only ever int LOOKS LIKE I WAS WRONG ABOUT THIS!
)

CREATE TABLE vsd.ETS2_stop_times_Strathcona (
	--stimeID INT IDENTITY PRIMARY KEY, --I don't use this so removing it might save me from running out of keys later
	trip_id VARCHAR(30) NOT NULL REFERENCES vsd.ETS2_trips_Strathcona(trip_id),
	arrival_time varchar(8) NOT NULL, ---not used in practice. Can't store as time because they can go over 24:00 (even over 25:00)
	departure_hour int NOT NULL, --The hour and minute will be broken up here so they can be stored as INT for faster sorting
	departure_minute int NOT NULL,
	departure_second int NOT NULL,
	--departure_time varchar(8) NOT NULL, --Removed because this will now be split into hour/minute integers for smaller storage and faster operation
	stop_id INT NOT NULL FOREIGN KEY REFERENCES vsd.ETS2_stops_Strathcona(stop_id),
	stop_sequence int NOT NULL, --integer
	--for proper normalization, stop_sequence really should be another DB table, but since it only seems to ever be one number, that's not so necesssary
	stop_headsign nvarchar(255) NULL,
	pickup_type INT DEFAULT 0 FOREIGN KEY REFERENCES vsd.ETS2_pickup_types(pickup_type),
	drop_off_type INT DEFAULT 0 FOREIGN KEY REFERENCES vsd.ETS2_drop_off_types(drop_off_type),
	shape_dist_traveled FLOAT(8) NULL, --theoretically could be a float, but is only ever int LOOKS LIKE I WAS WRONG ABOUT THIS!
)

--Table that allows quickly sorting nearby stops. This gets recreated every time the update is done.
CREATE TABLE vsd.ETS2_stop_routes_all_agencies (
stop_id INT NOT NULL,
route_id varchar(20) NOT NULL,
agency_id INT NOT NULL, 
PRIMARY KEY (stop_id, route_id, agency_id)
)

--Create some indicies on stop_times to improve certain operations
--DROP INDEX ix_ETS2_departure_hour ON vsd.ETS2_stop_times
--DROP INDEX ix_ETS2_departure_minute ON vsd.ETS2_stop_times
--DROP INDEX ix_ETS2_stop_id ON vsd.ETS2_stop_times
--DROP INDEX ix_ETS2_stop_sequence ON vsd.ETS2_stop_times
--DROP INDEX ix_ETS2_STIME_trip_id ON vsd.ETS2_stop_times
--DROP INDEX ix_ETS2_STIME_stop_id_trip_id ON vsd.ETS2_stop_times
-- For some reason these indexes seem to be slowing things down way more than helping.
--CREATE INDEX ix_ETS2_departure_hour ON vsd.ETS2_stop_times(departure_hour)
--CREATE INDEX ix_ETS2_departure_minute ON vsd.ETS2_stop_times(departure_minute)
--CREATE INDEX ix_ETS2_stop_id ON vsd.ETS2_stop_times(stop_id)
--CREATE INDEX ix_ETS2_stop_sequence ON vsd.ETS2_stop_times(stop_sequence)
--CREATE INDEX ix_ETS2_STIME_trip_id ON vsd.ETS2_stop_times(trip_id)
-- This index helps a lot, slows down imports by several seconds
--CREATE NONCLUSTERED INDEX ix_ETS2_STIME_stop_id_trip_id ON vsd.ETS2_stop_times (stop_id) INCLUDE (trip_id)

--This index gives me a 5x improvement
CREATE NONCLUSTERED INDEX ix_ETS2_STIME_trip_id_stop_id_stop_sequence ON [vsd].[ETS2_stop_times] ([trip_id],[stop_id],[stop_sequence])
--This index also speeds up the query a fair bit more
CREATE NONCLUSTERED INDEX ix_ETS2_stop_id ON [vsd].[ETS2_stop_times] ([stop_id]) INCLUDE ([trip_id])
--The benefits of this one seem insignificant
--CREATE NONCLUSTERED INDEX ix_ETS2_stopId_pickup_type ON [vsd].[ETS_stop_times] ([stop_id],[pickup_type]) INCLUDE ([trip_id],[arrival_time],[departure_hour],[departure_minute],[stop_sequence],[stop_headsign],[drop_off_type],[shape_dist_traveled])
CREATE NONCLUSTERED INDEX ix_ETS2_trip_id_stop_id_stop_sequence ON [vsd].[ETS2_stop_times] ([trip_id],[stop_id],[stop_sequence])


CREATE NONCLUSTERED INDEX ix_ETS2_STIME_trip_id_stop_id_stop_sequence_SA ON [vsd].[ETS2_stop_times_StAlbert] ([trip_id],[stop_id],[stop_sequence])
--This index also speeds up the query a fair bit more
CREATE NONCLUSTERED INDEX ix_ETS2_stop_id_SA ON [vsd].[ETS2_stop_times_StAlbert] ([stop_id]) INCLUDE ([trip_id])
--The benefits of this one seem insignificant
--CREATE NONCLUSTERED INDEX ix_ETS2_stopId_pickup_type ON [vsd].[ETS_stop_times] ([stop_id],[pickup_type]) INCLUDE ([trip_id],[arrival_time],[departure_hour],[departure_minute],[stop_sequence],[stop_headsign],[drop_off_type],[shape_dist_traveled])
CREATE NONCLUSTERED INDEX ix_ETS2_trip_id_stop_id_stop_sequence_SA ON [vsd].[ETS2_stop_times_StAlbert] ([trip_id],[stop_id],[stop_sequence])


CREATE NONCLUSTERED INDEX ix_ETS2_STIME_trip_id_stop_id_stop_sequence_SC ON [vsd].[ETS2_stop_times_Strathcona] ([trip_id],[stop_id],[stop_sequence])
--This index also speeds up the query a fair bit more
CREATE NONCLUSTERED INDEX ix_ETS2_stop_id_SC ON [vsd].[ETS2_stop_times_Strathcona] ([stop_id]) INCLUDE ([trip_id])
--The benefits of this one seem insignificant
--CREATE NONCLUSTERED INDEX ix_ETS2_stopId_pickup_type ON [vsd].[ETS_stop_times] ([stop_id],[pickup_type]) INCLUDE ([trip_id],[arrival_time],[departure_hour],[departure_minute],[stop_sequence],[stop_headsign],[drop_off_type],[shape_dist_traveled])
CREATE NONCLUSTERED INDEX ix_ETS2_trip_id_stop_id_stop_sequence_SC ON [vsd].[ETS2_stop_times_Strathcona] ([trip_id],[stop_id],[stop_sequence])


--View containing all agencies with my hardcoded agency IDs
CREATE VIEW vsd.ETS2_agency_all_agencies WITH SCHEMABINDING AS
SELECT 1 AS agency_id, agency_name, agency_url, agency_timezone, agency_lang, agency_phone FROM vsd.ETS2_agency
UNION
SELECT 2 AS agency_id, agency_name, agency_url, agency_timezone, agency_lang, agency_phone FROM vsd.ETS2_agency_StAlbert
UNION
SELECT 3 AS agency_id, agency_name, agency_url, agency_timezone, agency_lang, agency_phone FROM vsd.ETS2_agency_Strathcona

CREATE VIEW vsd.ETS2_routes_all_agencies WITH SCHEMABINDING AS
SELECT route_id, route_short_name, route_long_name, route_desc, route_type, route_url, route_color, route_text_color, 1 AS agency_id
FROM vsd.ETS2_routes UNION
SELECT route_id, route_short_name, route_long_name, route_desc, route_type, route_url, route_color, route_text_color, 2 AS agency_id
FROM vsd.ETS2_routes_StAlbert UNION
SELECT route_id, route_short_name, route_long_name, route_desc, route_type, route_url, route_color, route_text_color, 3 AS agency_id
FROM vsd.ETS2_routes_Strathcona

--DROP VIEW vsd.ETS2_trip_stop_datetimes
-- Creates a very useful view from the stop_times
CREATE VIEW vsd.ETS2_trip_stop_datetimes WITH SCHEMABINDING AS
SELECT --TOP 10000
CASE WHEN departure_hour > 23 THEN
CONVERT(datetime, DATEADD(d, 1, date), 121)+CONVERT(datetime, CAST(departure_hour%24 AS varchar)+':'+CAST(departure_minute AS varchar), 121)
ELSE
CONVERT(datetime, date, 121)+CONVERT(datetime, CAST(departure_hour AS varchar)+':'+CAST(departure_minute AS varchar), 121)
END --CASE
AS ActualDateTime,
stime.trip_id, stime.arrival_time, stime.departure_hour, stime.departure_minute,stop_id, stime.stop_sequence, stime.stop_headsign, stime.pickup_type, stime.drop_off_type,
stime.shape_dist_traveled, t.route_id, t.service_id, t.trip_headsign, t.direction_id, t.block_id, t.shape_id, c.date, c.exception_type
FROM vsd.ETS2_stop_times stime
JOIN vsd.ETS2_trips t ON stime.trip_id=t.trip_id
JOIN vsd.ETS2_calendar_dates c ON c.service_id=t.service_id


CREATE VIEW vsd.ETS2_trip_stop_datetimes_StAlbert WITH SCHEMABINDING AS
SELECT --TOP 10000
CASE WHEN departure_hour > 23 THEN
CONVERT(datetime, DATEADD(d, 1, date), 121)+CONVERT(datetime, CAST(departure_hour%24 AS varchar)+':'+CAST(departure_minute AS varchar), 121)
ELSE
CONVERT(datetime, date, 121)+CONVERT(datetime, CAST(departure_hour AS varchar)+':'+CAST(departure_minute AS varchar), 121)
END --CASE
AS ActualDateTime,
stime.trip_id, stime.arrival_time, stime.departure_hour, stime.departure_minute,stop_id, stime.stop_sequence, stime.stop_headsign, stime.pickup_type, stime.drop_off_type,
stime.shape_dist_traveled, t.route_id, t.service_id, t.trip_headsign, t.direction_id, t.block_id, t.shape_id, c.date, c.exception_type
FROM vsd.ETS2_stop_times_StAlbert stime
JOIN vsd.ETS2_trips_StAlbert t ON stime.trip_id=t.trip_id
JOIN vsd.ETS2_calendar_dates_complete_StAlbert c ON c.service_id=t.service_id


CREATE VIEW vsd.ETS2_trip_stop_datetimes_Strathcona WITH SCHEMABINDING AS
SELECT --TOP 10000
CASE WHEN departure_hour > 23 THEN
CONVERT(datetime, DATEADD(d, 1, date), 121)+CONVERT(datetime, CAST(departure_hour%24 AS varchar)+':'+CAST(departure_minute AS varchar), 121)
ELSE
CONVERT(datetime, date, 121)+CONVERT(datetime, CAST(departure_hour AS varchar)+':'+CAST(departure_minute AS varchar), 121)
END --CASE
AS ActualDateTime,
stime.trip_id, stime.arrival_time, stime.departure_hour, stime.departure_minute,stop_id, stime.stop_sequence, stime.stop_headsign, stime.pickup_type, stime.drop_off_type,
stime.shape_dist_traveled, t.route_id, t.service_id, t.trip_headsign, t.direction_id, t.block_id, t.shape_id, c.date, c.exception_type
FROM vsd.ETS2_stop_times_Strathcona stime
JOIN vsd.ETS2_trips_Strathcona t ON stime.trip_id=t.trip_id
JOIN vsd.ETS2_calendar_dates_complete_Strathcona c ON c.service_id=t.service_id


--This view adds a unique id based on the zone_id to create a unique identifier
--St. Albert starts with StA, Strathcona Str, Edmonton are just the regular ID
CREATE VIEW vsd.ETS2_stops_all_agencies_unique WITH SCHEMABINDING AS
SELECT CONCAT(left(REPLACE(zone_id, '. ', ''), 3), stop_id) AS astop_id,
stop_id, stop_code, stop_name, stop_desc, stop_lat, stop_lon, zone_id, stop_url, location_type, parent_station, is_lrt, exclusive
FROM (SELECT stop_id, stop_code, stop_name, stop_desc, stop_lat, stop_lon, zone_id, stop_url, location_type, parent_station, is_lrt, exclusive FROM vsd.ETS2_stops
UNION SELECT stop_id, stop_code, stop_name, stop_desc, stop_lat, stop_lon, zone_id, stop_url, location_type, parent_station, is_lrt, exclusive FROM vsd.ETS2_stops_StAlbert
UNION SELECT stop_id, stop_code, stop_name, stop_desc, stop_lat, stop_lon, zone_id, stop_url, location_type, parent_station, is_lrt, exclusive FROM vsd.ETS2_stops_Strathcona)
AS allstops WHERE exclusive=1

CREATE VIEW vsd.ETS2_stops_all_agencies WITH SCHEMABINDING AS
SELECT stop_id, stop_code, stop_name, stop_desc, stop_lat, stop_lon, zone_id, stop_url, location_type, parent_station, is_lrt, 1 AS agency_id FROM vsd.ETS2_stops
UNION SELECT stop_id, stop_code, stop_name, stop_desc, stop_lat, stop_lon, zone_id, stop_url, location_type, parent_station, is_lrt, 2 AS agency_id FROM vsd.ETS2_stops_StAlbert
UNION SELECT stop_id, stop_code, stop_name, stop_desc, stop_lat, stop_lon, zone_id, stop_url, location_type, parent_station, is_lrt, 3 AS agency_id FROM vsd.ETS2_stops_Strathcona


--Create a view of all trips
CREATE VIEW vsd.ETS2_trips_all_agencies WITH SCHEMABINDING AS
SELECT route_id, service_id, trip_id, trip_headsign, direction_id, block_id, shape_id, 1 AS agency_id
FROM vsd.ETS2_trips
UNION SELECT route_id, service_id, trip_id, trip_headsign, direction_id, block_id, shape_id, 2 AS agency_id
FROM vsd.ETS2_trips_StAlbert
UNION SELECT route_id, service_id, trip_id, trip_headsign, direction_id, block_id, shape_id, 3 AS agency_id
FROM vsd.ETS2_trips_Strathcona

--All Shapes
CREATE VIEW vsd.ETS2_shapes_all_agencies WITH SCHEMABINDING AS
SELECT shape_id, shape_pt_lat, shape_pt_lon, shape_pt_sequence, 1 AS agency_id FROM vsd.ETS2_shapes
UNION SELECT shape_id, shape_pt_lat, shape_pt_lon, shape_pt_sequence, 2 AS agency_id FROM vsd.ETS2_shapes_StAlbert
UNION SELECT shape_id, shape_pt_lat, shape_pt_lon, shape_pt_sequence, 3 AS agency_id  FROM vsd.ETS2_shapes_Strathcona

CREATE VIEW vsd.ETS2_stop_times_all_agencies WITH SCHEMABINDING AS
SELECT trip_id, arrival_time, departure_hour, departure_minute, departure_second, stop_id, stop_sequence, stop_headsign, pickup_type, drop_off_type, shape_dist_traveled, 1 AS agency_id
FROM vsd.ETS2_stop_times UNION
SELECT trip_id, arrival_time, departure_hour, departure_minute, departure_second, stop_id, stop_sequence, stop_headsign, pickup_type, drop_off_type, shape_dist_traveled, 2 AS agency_id
FROM vsd.ETS2_stop_times_StAlbert UNION
SELECT trip_id, arrival_time, departure_hour, departure_minute, departure_second, stop_id, stop_sequence, stop_headsign, pickup_type, drop_off_type, shape_dist_traveled, 3 AS agency_id
FROM vsd.ETS2_stop_times_Strathcona


--The big kahuna
CREATE VIEW vsd.ETS2_trip_stop_datetimes_all_agencies WITH SCHEMABINDING AS
SELECT
1 AS agency_id, ActualDateTime, trip_id, arrival_time, departure_hour, departure_minute, stop_id, stop_headsign, pickup_type, drop_off_type, shape_dist_traveled, route_id, service_id, trip_headsign, direction_id, block_id, shape_id, date, exception_type
FROM vsd.ETS2_trip_stop_datetimes
UNION SELECT
2 AS agency_id, ActualDateTime, trip_id, arrival_time, departure_hour, departure_minute, stop_id, stop_headsign, pickup_type, drop_off_type, shape_dist_traveled, route_id, service_id, trip_headsign, direction_id, block_id, shape_id, date, exception_type
FROM vsd.ETS2_trip_stop_datetimes_Strathcona
UNION SELECT
3 AS agency_id, ActualDateTime, trip_id, arrival_time, departure_hour, departure_minute, stop_id, stop_headsign, pickup_type, drop_off_type, shape_dist_traveled, route_id, service_id, trip_headsign, direction_id, block_id, shape_id, date, exception_type
FROM vsd.ETS2_trip_stop_datetimes_StAlbert
/************************************************************************
*
*  The vsd.ETS_activedb
*  Specifies which datbase is the active database, and which is the download database.
*
*************************************************************************/

--DROP TABLE vsd.ETS_activedb
CREATE TABLE vsd.ETS_activedb (
	dbid INT IDENTITY PRIMARY KEY,
	prefix varchar(20) NOT NULL,
	description varchar(256) NULL,
	active bit NOT NULL,
	updated datetime NULL
)

INSERT INTO vsd.ETS_activedb (prefix, description, active) VALUES('ETS1', 'Primary ETS Database', 1)
INSERT INTO vsd.ETS_activedb (prefix, description, active) VALUES('ETS2', 'Secondary ETS Database', 0)

SELECT * FROM vsd.ETS_activedb


SELECT * FROM vsd.EZLRTStations

SELECT * FROM vsd.ETS1_stops_StAlbert