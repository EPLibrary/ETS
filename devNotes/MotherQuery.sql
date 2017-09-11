SET statistics time ON
SET statistics IO ON


--CommonStops (Datasource=SecureSource, Time=47ms, Records=21) in C:\inetpub\apps.epl.ca\Dev\LRT\departureTimesGTFS.cfm @ 10:37:47.047
DECLARE @commonStops TABLE (stop_id INT);
INSERT INTO @commonStops (stop_id)
	SELECT stop_id FROM (
	--All stops on trips that include FROM station
	SELECT DISTINCT stop_id--, stop_sequence
	FROM vsd.ETS_stop_times WHERE trip_id IN (SELECT trip_ID from  vsd.ETS_stop_times WHERE stop_id IN (7977, 7977) )
	UNION ALL
	--All stops on trips that include TO station
	SELECT DISTINCT stop_id--, stop_sequence
	FROM vsd.ETS_stop_times WHERE trip_id IN (SELECT trip_ID from  vsd.ETS_stop_times WHERE stop_id IN (1116, 1116) )
	) AS bothRouteStops
	GROUP BY bothRouteStops.stop_id
	HAVING count(stop_id)=2


--MaxTrip (Datasource=SecureSource, Time=78ms, Records=1) in C:\inetpub\apps.epl.ca\Dev\LRT\departureTimesGTFS.cfm @ 10:37:47.047
DECLARE @maxStops INT = (
SELECT MAX(stop_sequence) AS max_stops FROM vsd.ETS_stop_times stimes WHERE trip_id IN (
	--list of trips with our from and connecting stations
	SELECT trip_id FROM
	(
		(SELECT DISTINCT trip_id FROM vsd.ETS_stop_times WHERE stop_id IN (SELECT stop_id FROM @commonStops) )
		UNION ALL
		(SELECT DISTINCT trip_id FROM vsd.ETS_stop_times
		WHERE stop_id IN --From station (NAIT in this example)
		(1116, 1116)
		) 
	) AS bothStopTrips
	GROUP BY trip_id HAVING count(*)=2
)
)



		
--ExampleTrip (Datasource=SecureSource, Time=62ms, Records=1) in C:\inetpub\apps.epl.ca\Dev\LRT\departureTimesGTFS.cfm @ 10:37:47.047
		-- This seems to work efficiently to get a trip ID
DECLARE @exampleTrip INT = (
		SELECT MAX(trip_id) AS trip_id FROM vsd.ETS_stop_times WHERE trip_id IN (
			--list of trips with our from and connecting stations
			SELECT trip_id FROM
			(	(SELECT DISTINCT trip_id FROM vsd.ETS_stop_times
				WHERE stop_id IN
					(SELECT stop_id FROM @commonStops)
				)
				UNION ALL
				(SELECT DISTINCT trip_id FROM vsd.ETS_stop_times
				WHERE stop_id IN
				--From station (Clareview in this example)
				(7977, 7977)
				)
			) AS bothStopTrips
			WHERE stop_sequence=@maxStops
			GROUP BY trip_id HAVING count(*)=2
		)
)
--ConnectingStopID (Datasource=SecureSource, Time=172ms, Records=1) in C:\inetpub\apps.epl.ca\Dev\LRT\departureTimesGTFS.cfm @ 10:37:48.048
DECLARE @connectingStopID INT = (
			SELECT TOP 1 stop_id FROM vsd.ETS_stop_times WHERE trip_id=@exampleTrip
			AND stop_sequence > (SELECT MAX(stop_sequence) FROM vsd.ETS_stop_times WHERE trip_id=@exampleTrip AND stop_id IN (7977,7977))
			AND stop_id IN (SELECT stop_id FROM @commonStops)
			ORDER BY stop_sequence
)
		
--ConnectingStation (Datasource=SecureSource, Time=0ms, Records=1) in C:\inetpub\apps.epl.ca\Dev\LRT\departureTimesGTFS.cfm @ 10:37:48.048
			SELECT * FROM vsd.EZLRTStations WHERE
			stop_id1 = @connectingStopID OR stop_id2 = @connectingStopID 