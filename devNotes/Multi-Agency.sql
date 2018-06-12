SELECT * FROM vsd.PersonalizedList
SELECT * FROM vsd.ETS_activedb
SELECT * FROM vsd.ETS2_agency


SELECT * FROM vsd.ETS1_calendar_dates
SELECT * FROM vsd.ETS1_routes

/*
ALTER TABLE vsd.ETS1_routes ADD route_color varchar(20)
ALTER TABLE vsd.ETS2_routes ADD route_color varchar(20)
ALTER TABLE vsd.ETS1_routes ADD route_text_color varchar(20)
ALTER TABLE vsd.ETS2_routes ADD route_text_color varchar(20)
*/


--Let's see if there's some way to create a view showing each stop only once if it is the same stop.
--This shows all the stops with the same ID. There are 700 in this list.
SELECT stop_id, stop_name FROM
(SELECT * FROM vsd.ETS1_stops_Strathcona
--UNION
--SELECT * FROM vsd.ETS1_stops_StAlbert
UNION
SELECT * FROM vsd.ETS1_stops) AS AllStops1
WHERE Stop_ID IN (
SELECT Stop_ID FROM
(SELECT * FROM vsd.ETS1_stops_Strathcona
--UNION
--SELECT * FROM vsd.ETS1_stops_StAlbert
UNION
SELECT * FROM vsd.ETS1_stops) AS AllStops2
GROUP BY Stop_ID
HAVING COUNT(*) > 1
)
GROUP BY stop_id, stop_name
 ORDER BY stop_id,stop_name




-- I want to see stops where the ID occurs more than once but where the stop name is NOT the same.

--I need a query that can replace St with Street and Av with Avenue without screwing things up. Should be case sensitive, look for spaces.
--I believe these will only apply to strathcona

SELECT * FROM vsd.ETS1_stops_Strathcona
WHERE vsd.ETS1_stops_Strathcona.stop_id IN (SELECT stop_id FROM vsd.ETS1_stops)
AND vsd.ETS1_stops_Strathcona.stop_lat-.0001 < (SELECT s.stop_lat FROM vsd.ETS1_stops s WHERE stop_id=vsd.ETS1_stops_Strathcona.stop_id)
AND vsd.ETS1_stops_Strathcona.stop_lat+.0001 > (SELECT s.stop_lat FROM vsd.ETS1_stops s WHERE stop_id=vsd.ETS1_stops_Strathcona.stop_id)
AND vsd.ETS1_stops_Strathcona.stop_lon-.0001 < (SELECT s.stop_lon FROM vsd.ETS1_stops s WHERE stop_id=vsd.ETS1_stops_Strathcona.stop_id)
AND vsd.ETS1_stops_Strathcona.stop_lon+.0001 > (SELECT s.stop_lon FROM vsd.ETS1_stops s WHERE stop_id=vsd.ETS1_stops_Strathcona.stop_id)


--106 St & 117 Av
SELECT * FROM vsd.ETS1_stops_Strathcona

--This will ensure that the stop_name of stops with same ID and similar coordinates (within about ten metres) match exactly
UPDATE vsd.ETS1_stops_Strathcona SET stop_name = (SELECT stop_name FROM vsd.ETS1_stops WHERE stop_id=vsd.ETS1_stops_Strathcona.stop_id)
WHERE vsd.ETS1_stops_Strathcona.stop_id IN (SELECT stop_id FROM vsd.ETS1_stops)
AND vsd.ETS1_stops_Strathcona.stop_lat-.0001 < (SELECT s.stop_lat FROM vsd.ETS1_stops s WHERE stop_id=vsd.ETS1_stops_Strathcona.stop_id)
AND vsd.ETS1_stops_Strathcona.stop_lat+.0001 > (SELECT s.stop_lat FROM vsd.ETS1_stops s WHERE stop_id=vsd.ETS1_stops_Strathcona.stop_id)
AND vsd.ETS1_stops_Strathcona.stop_lon-.0001 < (SELECT s.stop_lon FROM vsd.ETS1_stops s WHERE stop_id=vsd.ETS1_stops_Strathcona.stop_id)
AND vsd.ETS1_stops_Strathcona.stop_lon+.0001 > (SELECT s.stop_lon FROM vsd.ETS1_stops s WHERE stop_id=vsd.ETS1_stops_Strathcona.stop_id)


--This misses about 12. I need to refine this to match stops with the same ID but are within ~3 10,000ths of a degree on each axis
--Should have 37 matches.

--Clean up strathcona street and avenue abbreviations
UPDATE vsd.ETS1_stops_Strathcona SET stop_name = REPLACE(stop_name, ' St ', ' Street ') WHERE stop_name like '% St %'
UPDATE vsd.ETS1_stops_Strathcona SET stop_name = REPLACE(stop_name, ' St', ' Street') WHERE stop_name like '% St'
UPDATE vsd.ETS1_stops_Strathcona SET stop_name = REPLACE(stop_name, ' St. ', ' Street ') WHERE stop_name like '% St. %'
UPDATE vsd.ETS1_stops_Strathcona SET stop_name = REPLACE(stop_name, ' St.', ' Street') WHERE stop_name like '% St.'
UPDATE vsd.ETS1_stops_Strathcona SET stop_name = REPLACE(stop_name, ' Av ', ' Avenue ') WHERE stop_name like '% Av %'
UPDATE vsd.ETS1_stops_Strathcona SET stop_name = REPLACE(stop_name, ' Av', ' Avenue') WHERE stop_name like '% Av'
UPDATE vsd.ETS1_stops_Strathcona SET stop_name = REPLACE(stop_name, ' Ave ', ' Avenue ') WHERE stop_name like '% Ave %'
UPDATE vsd.ETS1_stops_Strathcona SET stop_name = REPLACE(stop_name, ' Ave', ' Avenue') WHERE stop_name like '% Ave'
UPDATE vsd.ETS1_stops_Strathcona SET stop_name = REPLACE(stop_name, ' Ave. ', ' Avenue ') WHERE stop_name like '% Ave. %'
UPDATE vsd.ETS1_stops_Strathcona SET stop_name = REPLACE(stop_name, ' Ave.', ' Avenue') WHERE stop_name like '% Ave.'
UPDATE vsd.ETS1_stops_Strathcona SET stop_name = REPLACE(stop_name, ' and ', ' & ') WHERE stop_name like '% and %'

UPDATE vsd.ETS1_stops_Strathcona SET exclusive=1

--Set the exclusive flag to 0 for stops that are actually ETS stops
UPDATE vsd.ETS1_stops_Strathcona SET exclusive=0
WHERE stop_id IN (SELECT stop_id FROM vsd.ETS1_stops)
AND vsd.ETS1_stops_Strathcona.stop_name=(SELECT stop_name FROM vsd.ETS1_stops WHERE stop_id = vsd.ETS1_stops_Strathcona.stop_id)

-- This query should have no two stops which are actually the same stop, but with a slightly different id and coords.
-- Double check this list
SELECT * FROM (
SELECT * FROM vsd.ETS1_stops_Strathcona WHERE exclusive=1 AND stop_id IN (SELECT stop_id FROM vsd.ETS1_stops)
UNION
SELECT * FROM vsd.ETS1_stops WHERE stop_id IN (SELECT stop_id FROM vsd.ETS1_stops_Strathcona WHERE exclusive=1 AND stop_id IN (SELECT stop_id FROM vsd.ETS1_stops))
) AS Sto WHERE Sto.stop_id IN (1321,1679,11444)




-- I need a bit in the stops db tables to flag that stops are shared between agencies.
-- I can then leave these stops out of any union/view showing all the agencies' stops.


SELECT * FROM vsd.ETS1_stops WHERE stop_name like '%nearside'

-- Query for stops that have the same stop_id, lat and lon as those in Edmonton and then set the name to match
SELECT * FROM vsd.ETS1_stops_Strathcona sstr
WHERE stop_id IN (SELECT stop_id FROM vsd.ETS1_stops)
AND sstr.stop_lat = (SELECT s.stop_lat FROM vsd.ETS1_stops s WHERE stop_id=sstr.stop_id)
AND sstr.stop_lon = (SELECT s.stop_lon FROM vsd.ETS1_stops s WHERE stop_id=sstr.stop_id)



--Compare these values between Edmonton and Strathcona tables.
SELECT * FROM
(SELECT * FROM vsd.ETS1_stops_Strathcona
UNION
SELECT * FROM vsd.ETS1_stops) AS TheStops
WHERE stop_id IN (
SELECT stop_id FROM vsd.ETS1_stops_Strathcona sstr
WHERE stop_id IN (SELECT stop_id FROM vsd.ETS1_stops)
AND sstr.stop_lat = (SELECT s.stop_lat FROM vsd.ETS1_stops s WHERE stop_id=sstr.stop_id)
AND sstr.stop_lon = (SELECT s.stop_lon FROM vsd.ETS1_stops s WHERE stop_id=sstr.stop_id)
)


SELECT * FROM vsd.ETS1_stops_Strathcona
UNION
SELECT * FROM vsd.ETS1_stops_StAlbert
UNION
SELECT * FROM vsd.ETS1_stops


-- Notes: Here are stops that are probably the same stop but have slight differences in spelling
/*
1321	100 Street & 102 Avenue
1321	100 Street & 102 Avenue nearside
1364	100 Street & 103 Avenue
1364	100 Street & 103 Avenue nearside
1629	106 Street & 96 Avenue
1629	96 Avenue & 106 Street
1679	104 Avenue & 105 Street
1679	105 Street & 104 Avenue
1915	103 Street & 104 Avenue
1915	104 Avenue & 103 Street
1941	107 Street & 100 Avenue
1941	107 Street & Jasper Avenue
2131	82 Avenue & 91 Street
2131	91 Street & 82 Avenue
2159	83 Street & 82 Avenue
2159	83 Street & 82 Avenue
2159	83 Street and 82 Avenue
2255	82 Avenue & 83 Street
2255	83 Street & 82 Avenue
2437	53 Street & Terrace Road
2437	Terrace Rd & 53 Street
2454	73 Street & 82 Avenue
2454	82 Avenue & 73 Street
2722	105 Street & 82 Avenue
2722	82 Avenue & 105 Street
2844	116 Street & 87 Avenue
2844	87 Avenue & 114 Street
2845	105 Street & 82 Avenue
2845	82 Avenue & 105 Street
2848	82 Avenue & 91 Street
2848	91 Street & 82 Avenue
*/

SELECT * FROM vsd.ETS1_stops_Strathcona WHERE stop_id=2159