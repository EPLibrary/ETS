<cfsetting enablecfoutputonly="true" />
<cfsetting showdebugoutput="false" />
<cfheader name="Content-Type" value="application/json" />
<!--- Return (JSON) a list of routes sorted by the distance
from a given point to the nearest route stop to that point --->

<!--- Allow use of URL parameters, mainly for tracking. --->
<cfif isDefined('url.lat')><cfset form.lat = url.lat /></cfif>
<cfif isDefined('url.lon')><cfset form.lon = url.lon /></cfif>
<cfif isDefined('url.dow')><cfset form.dow = url.dow /></cfif>
<cfif isDefined('url.time')><cfset form.time = url.time /></cfif>
<cfif isDefined('url.range')><cfset form.range = url.range /></cfif>

<!--- Calculate the time we want to look at --->
<cfinclude template="#appsIncludes#/functions/weekdayToNum.cfm" />

<!--- Setting date variables for DepartureTimes query --->
<!--- Set the Day of Week. Sunday is 1, Saturday is 7 --->
<cfif isDefined('form.dow') AND len(form.dow) GTE 3>
	<cfset DOW = Left(form.dow, 3)>
<cfelse>
	<cfset DOW = Left(DayOfWeekAsString(DayOfWeek(now())),3)>
</cfif>

<!--- If it's Monday, and we've specified Sunday, we'll get -1. Add 7 to get 6 days ahead --->
<cfset dayDiff = weekdayToNum(DOW) - DayOfWeek(now())>
<cfif dayDiff LT 0><cfset dayDiff+=7></cfif> 

<!--- Our start datetime for purposes of the query will then be --->
<cfset SpecifiedDateTime = DateAdd('d', dayDiff, now()) >

<!--- If the user has specified a time, we set it here --->
<cfif isDefined('form.time') and len(form.time) GTE 3>
	<!--- Create a new SpecifiedDateTime with the speified time url --->
	<cfset SpecifiedDateTime=CreateDateTime(Year(SpecifiedDateTime), Month(SpecifiedDateTime), Day(SpecifiedDateTime), Hour(form.time), Minute(form.time), 0)>
</cfif>
<!--- Subtract three minutes to account for busses being a little late --->
<cfset SpecifiedDateTime = DateAdd("n", -3, SpecifiedDateTime)>


<!--- For privacy reasons I'd rather have people submit via post so the location isn't in the URL --->
<cfif isDefined('form.lat') AND isDefined('form.lon') AND isNumeric(form.lat) AND isNumeric(form.lon)>
	<!--- Allow the range from the current location to be customized --->
	<cfparam name="form.range" default="0" />

	<cfinclude template="#appsIncludes#/functions/querytostruct.cfm" />

	<!--- Choose the active database to use. --->
	<cfquery name="activedb" dbtype="ODBC" datasource="SecureSource">
		SELECT TOP 1 * FROM vsd.ETS_activeDB WHERE active = 1
	</cfquery>

	<cfset dbprefix = activedb.prefix />
	<!--- TEMPORARILY SET THIS MANUALLY FOR TESTING. REMOVE THIS LINE FOR PRODUCTION!!! --->
	<!--- <cfset dbprefix = 'ETS2' /> --->

	<!--- Query all stops with the distance from the specified point. We don't need to do this separately. --->
	<!---
	<cfquery name="stops" dbtype="ODBC" datasource="SecureSource">
		SELECT stop_id, stop_lat, stop_lon, ( 6371000 * acos( cos( radians(#form.lat#) ) * cos( radians( stop_lat ) ) 
		* cos( radians( stop_lon ) - radians(#form.lon#) ) + sin( radians(#form.lat#) ) * sin(radians(stop_lat)) ) ) AS distance 
		FROM vsd.#dbprefix#_stops 
		ORDER BY distance
	</cfquery>
	--->

<!--- This looks cool but is sorting by route_id, not distance --->
<!--- The horrifying way this query was done seemed relatively fast compared to other approaches. --->
<!--- 	<cfquery name="RouteByNearestStopDist" dbtype="ODBC" datasource="SecureSource">
		WITH summary AS (
	SELECT sdt.stop_id, sdt.route_id,
	(6371000*acos(cos(radians(#form.lat#))*cos(radians(stop_lat)) * cos(radians(stop_lon )-radians(#form.lon#))+sin(radians(#form.lat#)) * sin(radians(stop_lat)))) AS distance,
	ROW_NUMBER() OVER(PARTITION BY sdt.route_id ORDER BY
	(6371000*acos(cos(radians(#form.lat#))*cos(radians(stop_lat)) * cos(radians(stop_lon )-radians(#form.lon#))+sin(radians(#form.lat#)) * sin(radians(stop_lat)))) ASC) AS rk
		FROM vsd.#dbprefix#_trip_stop_datetimes sdt
		JOIN vsd.#dbprefix#_stops_all_agencies_unique s ON s.stop_id=sdt.stop_id
		WHERE ActualDateTime > DATEADD(n,-5, '#DateTimeFormat(SpecifiedDateTime, "YYYY-MM-DD HH:NN:SS")#') AND ActualDateTime < DATEADD(n,90, '#DateTimeFormat(SpecifiedDateTime, "YYYY-MM-DD HH:NN:SS")#')
		<!--- Limiting to stops within a few km is slighly faster, but limits results, obviously. This may usually be desirable --->
		AND sdt.stop_id IN (
			SELECT closeStops.stop_id FROM (
			SELECT closeStopsInner.stop_id, ( 6371000 * acos( cos( radians(#form.lat#) ) * cos( radians( stop_lat ) ) 
			* cos( radians( stop_lon ) - radians(#form.lon#) ) + sin( radians(#form.lat#) ) * sin(radians(stop_lat)) ) ) AS distance 
			FROM vsd.#dbprefix#_stops_all_agencies_unique AS closeStopsInner
			) AS closeStops WHERE closeStops.distance < #form.range#
			)
	UNION
		SELECT sdt.stop_id, sdt.route_id,
	(6371000*acos(cos(radians(#form.lat#))*cos(radians(stop_lat)) * cos(radians(stop_lon )-radians(#form.lon#))+sin(radians(#form.lat#)) * sin(radians(stop_lat)))) AS distance,
	ROW_NUMBER() OVER(PARTITION BY sdt.route_id ORDER BY
	(6371000*acos(cos(radians(#form.lat#))*cos(radians(stop_lat)) * cos(radians(stop_lon )-radians(#form.lon#))+sin(radians(#form.lat#)) * sin(radians(stop_lat)))) ASC) AS rk
		FROM vsd.#dbprefix#_trip_stop_datetimes_StAlbert sdt
		JOIN vsd.#dbprefix#_stops_all_agencies_unique s ON s.stop_id=sdt.stop_id
		WHERE ActualDateTime > DATEADD(n,-5, '#DateTimeFormat(SpecifiedDateTime, "YYYY-MM-DD HH:NN:SS")#') AND ActualDateTime < DATEADD(n,90, '#DateTimeFormat(SpecifiedDateTime, "YYYY-MM-DD HH:NN:SS")#')
		<!--- Limiting to stops within a few km is slighly faster, but limits results, obviously. This may usually be desirable --->
		AND sdt.stop_id IN (
			SELECT closeStops.stop_id FROM (
			SELECT closeStopsInner.stop_id, ( 6371000 * acos( cos( radians(#form.lat#) ) * cos( radians( stop_lat ) ) 
			* cos( radians( stop_lon ) - radians(#form.lon#) ) + sin( radians(#form.lat#) ) * sin(radians(stop_lat)) ) ) AS distance 
			FROM vsd.#dbprefix#_stops_all_agencies_unique AS closeStopsInner
			) AS closeStops WHERE closeStops.distance < #form.range#
			)
	UNION
			SELECT sdt.stop_id, sdt.route_id,
	(6371000*acos(cos(radians(#form.lat#))*cos(radians(stop_lat)) * cos(radians(stop_lon )-radians(#form.lon#))+sin(radians(#form.lat#)) * sin(radians(stop_lat)))) AS distance,
	ROW_NUMBER() OVER(PARTITION BY sdt.route_id ORDER BY
	(6371000*acos(cos(radians(#form.lat#))*cos(radians(stop_lat)) * cos(radians(stop_lon )-radians(#form.lon#))+sin(radians(#form.lat#)) * sin(radians(stop_lat)))) ASC) AS rk
		FROM vsd.#dbprefix#_trip_stop_datetimes_Strathcona sdt
		JOIN vsd.#dbprefix#_stops_all_agencies_unique s ON s.stop_id=sdt.stop_id
		WHERE ActualDateTime > DATEADD(n,-5, '#DateTimeFormat(SpecifiedDateTime, "YYYY-MM-DD HH:NN:SS")#') AND ActualDateTime < DATEADD(n,90, '#DateTimeFormat(SpecifiedDateTime, "YYYY-MM-DD HH:NN:SS")#')
		<!--- Limiting to stops within a few km is slighly faster, but limits results, obviously. This may usually be desirable --->
		AND sdt.stop_id IN (
			SELECT closeStops.stop_id FROM (
			SELECT closeStopsInner.stop_id, ( 6371000 * acos( cos( radians(#form.lat#) ) * cos( radians( stop_lat ) ) 
			* cos( radians( stop_lon ) - radians(#form.lon#) ) + sin( radians(#form.lat#) ) * sin(radians(stop_lat)) ) ) AS distance 
			FROM vsd.#dbprefix#_stops_all_agencies_unique AS closeStopsInner
			) AS closeStops WHERE closeStops.distance < #form.range#
			)
		)
		SELECT s.route_id as value, CONCAT(s.route_id, ' ', r.route_long_name, ' - ', CAST(s.distance AS int), 'm') AS text --, r.route_short_name, s.distance
		FROM summary s
		JOIN vsd.#dbprefix#_routes_all_agencies r ON s.route_id=r.route_id
		WHERE s.rk=1
		ORDER BY distance
	</cfquery> --->
<!--- Stupid CF capitalizes these which doesn't work with the dropdown plugin --->

<!--- This new query is *much* faster and shows all the routes, but it doesn't account for the current time at all.
(ie a route that has no trips at this time of the day still shows up) --->
<cfquery name="RouteByNearestStopDist" dbtype="ODBC" datasource="SecureSource">
	SELECT *, CONCAT(value, ' ', route_long_name, ' - ', CAST(distance AS int), 'm') AS text FROM (
	SELECT sr.stop_id, sr.route_id AS value, sr.agency_id, stop_lat, stop_lon, route_short_name, route_long_name,
	(6371000*acos(cos(radians(#form.lat#))*cos(radians(stop_lat)) * cos(radians(stop_lon)-radians(#form.lon#))+sin(radians(#form.lat#)) * sin(radians(stop_lat)))) AS distance,
	ROW_NUMBER() OVER(PARTITION BY sr.route_id ORDER BY
	(6371000*acos(cos(radians(#form.lat#))*cos(radians(stop_lat)) * cos(radians(stop_lon)-radians(#form.lon#))+sin(radians(#form.lat#)) * sin(radians(stop_lat)))) ASC) AS rk
	 FROM vsd.#dbprefix#_stop_routes_all_agencies sr
	JOIN vsd.#dbprefix#_stops_all_agencies s ON s.stop_id=sr.stop_id AND s.agency_id=sr.agency_id
	JOIN vsd.#dbprefix#_routes_all_agencies r ON sr.route_id=r.route_id AND sr.agency_id=r.agency_id
	) AS ard
	WHERE rk=1 <cfif range GT 0>AND distance < #form.range#</cfif>
	ORDER BY distance, value  ASC
</cfquery>

<cfoutput>#SerializeJSON(queryToStruct(RouteByNearestStopDist))#</cfoutput>
<cfelse>
<cfoutput>{"error": true,"message": "No location coordinates specified."}</cfoutput>
</cfif>