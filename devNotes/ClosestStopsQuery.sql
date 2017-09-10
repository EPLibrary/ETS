--Use the location of MNA
--SELECT * FROM vsd.Offices WHERE OfficeCode='MNA'
--lat 53.543202	
--lon -113.489606

--Limit to stops within 10km

--Limiting to 5km in each direction gives you around 1,000 stops.
SELECT *
--Distance seems to be off by a meter or two. Hmm.
,ROUND(
6371000 * 2 * ATN2(
SQRT(SQUARE(SIN(RADIANS(stop_lat-lat)/2)) + COS(RADIANS(lat)) * COS(RADIANS(stop_lat)) * SQUARE(SIN(RADIANS(stop_lon-lon))/2)),
SQRT(1-SQUARE(SIN(RADIANS(stop_lat-lat)/2)) + COS(RADIANS(lat)) * COS(RADIANS(stop_lat)) * SQUARE(SIN(RADIANS(stop_lon-lon))/2))
), 2) AS distance
FROM vsd.ETS_stops s
--Specify your lat/lon here (or replace 53, -113 with variables)
JOIN (SELECT 53.543202  AS lat,  -113.489606 AS lon) AS p ON 1=1
--Limit to stops within 4km in each direction to speed up the query
--(via pythegorian theorem that is a max distance of about 5.66 km)
--Distance between degrees lat is about 111.045km
--Distance between degrees lon in Edmonton at about 53.543 N Lat is about 66.29 km
WHERE stop_lat	BETWEEN lat - (4/111.045)
				AND lat +(4/111.045)
AND stop_lon	BETWEEN lon - (4/66.29)
				AND lon +(4/66.29)
ORDER BY distance
