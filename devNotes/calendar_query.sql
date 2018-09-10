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
JOIN vsd.ETS1_calendar_dates_StAlbert c ON c.service_id=t.service_id


SELECT * FROM vsd.ETS1_stop_times_StAlbert
SELECT * FROM vsd.ETS1_trips_StAlbert
SELECT * FROM vsd.ETS1_calendar_dates_StAlbert -- Exceptions to the schedule. 2 means service has been removed. 1 means service has been added
SELECT * FROM vsd.ETS1_calendar_StAlbert -- This is the regular schedule.

/*
Try to come up with a view that shows every single stop time for every day.
This seems... impractical. Shit. I'll probably need a different kind of view.

For any particular date, I could look in the calendar table to see which service IDs apply, then look in the calendar dates table to see if there are any exceptions.
Then if service IDs are found, query for those.

So for today:
*/
SELECT c.service_id FROM vsd.ETS1_calendar_StAlbert c
JOIN vsd.ETS1_calendar_dates_StAlbert cd ON cd.service_id=c.service_id
WHERE start_date <= GETDATE() AND end_date >= GETDATE() AND monday=1

SELECT service_id, exception_type FROM vsd.ETS1_calendar_dates_StAlbert WHERE date=CONVERT(date, GETDATE())


--Start with a query like this. Normally for a weekday it'd return Fall_Class_2
--However, we can see that September 3rd (a holiday) is an exception.
SELECT c.service_id FROM vsd.ETS1_calendar_StAlbert c
WHERE start_date <= GETDATE() AND end_date >= GETDATE() AND monday=1

SELECT ISNull(cdserviceid, cserviceid) AS service_id FROM (
SELECT c.service_id AS cserviceid, cd.service_id AS cdserviceid, exception_type FROM vsd.ETS1_calendar_StAlbert c
LEFT OUTER JOIN vsd.ETS1_calendar_dates_StAlbert cd ON cd.date='2018-09-03'
WHERE start_date <= '2018-09-03' AND end_date >= '2018-09-03' AND monday=1
) AS subq WHERE exception_type = 1 OR exception_type IS NULL
--AND cd.date='2018-09-03'

SELECT ISNull(cdserviceid, cserviceid) AS service_id FROM (
SELECT c.service_id AS cserviceid, cd.service_id AS cdserviceid, exception_type FROM vsd.ETS1_calendar_StAlbert c
LEFT OUTER JOIN vsd.ETS1_calendar_dates_StAlbert cd ON cd.date='2018-09-10'
WHERE start_date <= '2018-09-10' AND end_date >= '2018-09-10' AND monday=1
) AS subq WHERE exception_type = 1 OR exception_type IS NULL
--AND cd.date='2018-09-10'



--Sample for Edmonton, which doesn't use the calendar.txt file at all.
SELECT ISNull(cdserviceid, cserviceid) AS service_id FROM (
SELECT c.service_id AS cserviceid, cd.service_id AS cdserviceid, exception_type FROM vsd.ETS1_calendar c
LEFT OUTER JOIN vsd.ETS1_calendar_dates cd ON cd.date='2018-09-10'
WHERE start_date <= '2018-09-10' AND end_date >= '2018-09-10' AND monday=1
) AS subq WHERE exception_type = 1 OR exception_type IS NULL
--NOPE!