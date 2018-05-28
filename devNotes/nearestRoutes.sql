SET STATISTICS TIME ON 
-- AB Legislature
--53.534242, -113.506374
--I haven't verified that this formula works - it appears to be the haversine formula
SELECT DISTINCT st.route_id, r.route_short_name, r.route_long_name, r.route_type FROM (
SELECT TOP 2000 s.stop_id, sdt.route_id, --stop_lat, stop_lon,
( 6371000 * acos( cos( radians(53.5) ) * cos( radians( stop_lat ) ) 
* cos( radians( stop_lon ) - radians(-113.5) ) + sin( radians(53.5) ) * sin(radians(stop_lat)) ) ) AS distance 
FROM vsd.ETS1_stops s
JOIN vsd.ETS1_trip_stop_datetimes sdt ON s.stop_id=sdt.stop_id
WHERE ActualDateTime > DATEADD(n,-5, GETDATE()) AND ActualDateTime < DATEADD(n,90, GETDATE())
ORDER BY distance
) AS st
JOIN vsd.ETS1_routes r ON r.route_id=st.route_id


WITH summary AS (
	SELECT TOP 2000 s.stop_id, sdt.route_id, --stop_lat, stop_lon,
	( 6371000 * acos( cos( radians(53.5) ) * cos( radians( stop_lat ) ) 
	* cos( radians( stop_lon ) - radians(-113.5) ) + sin( radians(53.5) ) * sin(radians(stop_lat)) ) ) AS distance,
	ROW_NUMBER() OVER(PARTITION BY p.customer 
	FROM vsd.ETS1_stops s
	JOIN vsd.ETS1_trip_stop_datetimes sdt ON s.stop_id=sdt.stop_id
	WHERE ActualDateTime > DATEADD(n,-5, GETDATE()) AND ActualDateTime < DATEADD(n,90, GETDATE())
	ORDER BY distance
	) AS st


           ROW_NUMBER() OVER(PARTITION BY p.customer 
                                 ORDER BY p.total DESC) AS rk
      FROM PURCHASES p)
SELECT s.*
  FROM summary s
 WHERE s.rk = 1



SELECT TOP 100 * FROM vsd.ETS1_trip_stop_datetimes sdt
JOIN vsd.ETS1_stops s ON sdt.stop_id=s.stop_id
SELECT * FROM vsd.ETS1_stop_times
SELECT * FROM vsd.ETS1_trips

--I only need times 90 minutes from a specified datetime
SELECT DISTINCT route_id FROM vsd.ETS1_trip_stop_datetimes
WHERE ActualDateTime > DATEADD(n,-5, GETDATE()) AND ActualDateTime < DATEADD(n,90, GETDATE())

WITH summary AS (
SELECT sdt.stop_id, sdt.route_id,
( 6371000 * acos( cos( radians(53.543143) ) * cos( radians( stop_lat ) ) * cos( radians( stop_lon ) - radians(-113.5) ) + sin( radians(53.543143) ) * sin(radians(stop_lat)) ) ) AS distance,
ROW_NUMBER() OVER(PARTITION BY sdt.route_id ORDER BY
( 6371000 * acos( cos( radians(53.543143) ) * cos( radians( stop_lat ) ) * cos( radians( stop_lon ) - radians(-113.5) ) + sin( radians(53.543143) ) * sin(radians(stop_lat)) ) ) ASC) AS rk
FROM vsd.ETS1_trip_stop_datetimes sdt
JOIN vsd.ETS1_stops s ON s.stop_id=sdt.stop_id
WHERE ActualDateTime > DATEADD(n,-5, GETDATE()) AND ActualDateTime < DATEADD(n,90, GETDATE())
)
SELECT s.stop_id, s.route_id, s.distance FROM summary s WHERE s.rk=1
ORDER BY distance


WITH summary AS (
SELECT sdt.stop_id, sdt.route_id,
( 6371000 * acos( cos( radians(53.543143) ) * cos( radians( stop_lat ) ) * cos( radians( stop_lon ) - radians(-113.5) ) + sin( radians(53.543143) ) * sin(radians(stop_lat)) ) ) AS distance,
ROW_NUMBER() OVER(PARTITION BY sdt.route_id ORDER BY
( 6371000 * acos( cos( radians(53.543143) ) * cos( radians( stop_lat ) ) * cos( radians( stop_lon ) - radians(-113.5) ) + sin( radians(53.543143) ) * sin(radians(stop_lat)) ) ) ASC) AS rk
FROM vsd.ETS1_trip_stop_datetimes sdt
JOIN vsd.ETS1_stops s ON s.stop_id=sdt.stop_id
--WHERE ActualDateTime > DATEADD(n,-5, GETDATE()) AND ActualDateTime < DATEADD(n,90, GETDATE())
)
SELECT s.stop_id, s.route_id, s.distance FROM summary s WHERE s.rk=1
ORDER BY distance



-- Perhaps I can do a query like this first and then sort by the unique stop IDs I pull out or something like that
--This limits to stops within 6km
SELECT stop_id FROM (
SELECT stop_id, stop_lat, stop_lon, ( 6371000 * acos( cos( radians(53.543143) ) * cos( radians( stop_lat ) ) 
* cos( radians( stop_lon ) - radians(-113.5) ) + sin( radians(53.543143) ) * sin(radians(stop_lat)) ) ) AS distance 
FROM vsd.ETS1_stops
) AS s WHERE s.distance < 5000
ORDER BY s.distance


--Limiting query to stops within 5km
	WITH summary AS (
SELECT sdt.stop_id, sdt.route_id,
(6371000*acos(cos(radians(53.543143))*cos(radians(stop_lat)) * cos(radians(stop_lon )-radians(-113.489715))+sin(radians(53.543143)) * sin(radians(stop_lat)))) AS distance,
ROW_NUMBER() OVER(PARTITION BY sdt.route_id ORDER BY
(6371000*acos(cos(radians(53.543143))*cos(radians(stop_lat)) * cos(radians(stop_lon )-radians(-113.489715))+sin(radians(53.543143)) * sin(radians(stop_lat)))) ASC) AS rk
	FROM vsd.ETS1_trip_stop_datetimes sdt
	JOIN vsd.ETS1_stops s ON s.stop_id=sdt.stop_id
	WHERE ActualDateTime > DATEADD(n,-5, GETDATE()) AND ActualDateTime < DATEADD(n,90, GETDATE()) AND sdt.stop_id IN (
		SELECT closeStops.stop_id FROM (
		SELECT closeStopsInner.stop_id, ( 6371000 * acos( cos( radians(53.543143) ) * cos( radians( stop_lat ) ) 
		* cos( radians( stop_lon ) - radians(-113.489715) ) + sin( radians(53.543143) ) * sin(radians(stop_lat)) ) ) AS distance 
		FROM vsd.ETS1_stops AS closeStopsInner
		) AS closeStops WHERE closeStops.distance < 5000
		)
	)
	SELECT s.stop_id, s.route_id, s.distance FROM summary s WHERE s.rk=1
	ORDER BY distance


--Without stop limiting
	WITH summary AS (
SELECT sdt.stop_id, sdt.route_id,
(6371000*acos(cos(radians(53.543143))*cos(radians(stop_lat)) * cos(radians(stop_lon )-radians(-113.489715))+sin(radians(53.543143)) * sin(radians(stop_lat)))) AS distance,
ROW_NUMBER() OVER(PARTITION BY sdt.route_id ORDER BY
(6371000*acos(cos(radians(53.543143))*cos(radians(stop_lat)) * cos(radians(stop_lon )-radians(-113.489715))+sin(radians(53.543143)) * sin(radians(stop_lat)))) ASC) AS rk
	FROM vsd.ETS1_trip_stop_datetimes sdt
	JOIN vsd.ETS1_stops s ON s.stop_id=sdt.stop_id
	WHERE ActualDateTime > DATEADD(n,-5, GETDATE()) AND ActualDateTime < DATEADD(n,90, GETDATE()) 
	)
	SELECT s.stop_id, s.route_id, s.distance FROM summary s WHERE s.rk=1
	ORDER BY distance



SELECT TOP 10 * FROM vsd.ETS1_trip_stop_datetimes

SELECT * FROM vsd.ETS1_trips
SELECT * FROM vsd.ETS1_stops

SELECT * FROM vsd.ETS1_trip_stop_datetimes


--Try to go the other direction - get the list of routes, then find the closest stop for each one to determine the route distance

SELECT *, (
	SELECT TOP 1 sdt.stop_id
	FROM vsd.ETS1_trip_stop_datetimes sdt
	JOIN vsd.ETS1_stops s ON s.stop_id=sdt.stop_id
	WHERE route_id=r.route_id
	ORDER BY (6371000*acos(cos(radians(53.543143))*cos(radians(stop_lat)) * cos(radians(stop_lon )-radians(-113.489715))+sin(radians(53.543143)) * sin(radians(stop_lat)))) ASC) AS NearestStop
FROM vsd.ETS1_routes r
JOIN vsd.ETS1_stops ON stops.stop_id=sdt.NearestStop

	-- Does the current route have any instances
	-- where it is in the same trip as the routeFrom
	-- and has a stop_sequence that is higher?
	AND stop_sequence > (SELECT stop_sequence FROM vsd.ETS1_stop_times WHERE trip_id = sdt.trip_id AND stop_id=#url.routeFrom#)